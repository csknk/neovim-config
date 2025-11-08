```go
package main

import (
 "context"
 "fmt"
 "os"
 "os/signal"
 "sync"
 "syscall"
 "time"
)

type Job struct {
 ID      int
 Payload string
}

type Result struct {
 JobID int
 Value string
 Err   error
}

// doWork processes a single job and returns a result.
// Replace the body with your real logic.
// workerID may be removed or used for logging
func doWork(ctx context.Context, j Job, workerID int) (Result, error) {
 // The select pattern ensures we can abort quickly if context is cancelled
 select {
 case <-ctx.Done():
  // Context was cancelled before work even started
  return Result{JobID: j.ID}, ctx.Err()

 default:
  // Proceed with actual work
 }

 // --- Perform your real task ---
 // E.g. network call
 // resp, err := http.Get(j.Payload)
 // if err != nil {
 //     return Result{JobID: j.ID}, err
 // }
 // defer resp.Body.Close()

 // Example 2: compute something
 time.Sleep(200 * time.Millisecond) // simulate work delay

 // Return a result normally
 return Result{
  JobID: j.ID,
  Value: fmt.Sprintf("processed: %s (worker %d)", j.Payload, workerID),
 }, nil
}

// worker reads jobs and writes results until jobs is closed or ctx is canceled.
func worker(
 ctx context.Context,
 id int,
 jobs <-chan Job,
 results chan<- Result,
 wg *sync.WaitGroup,
) {
 defer wg.Done()

 for {
  select {
  case <-ctx.Done():
   return
  case job, ok := <-jobs:
   if !ok { // channel closed: no more jobs
    return
   }
   res, err := doWork(ctx, job, id)
   if err != nil {
    res.Err = err
   }
   // Non-blocking respect for cancellation while sending.
   select {
   case results <- res:
   case <-ctx.Done():
    return
   }
  }
 }
}

// startWorkers launches n workers.
func startWorkers(
 ctx context.Context,
 n int,
 jobs <-chan Job,
 results chan<- Result,
) *sync.WaitGroup {
 var wg sync.WaitGroup
 wg.Add(n)
 for i := range n {
  go worker(ctx, i, jobs, results, &wg)
 }
 return &wg
}

func main() {
 // Cancel on timeout (or swap for signal.NotifyContext for Ctrl+C).
 // ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
 // defer cancel()
 ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
 defer stop()

 const (
  workerCount = 20
  totalJobs   = 20
 )

 jobs := make(chan Job)
 results := make(chan Result, workerCount) // small buffer helps avoid chatter deadlocks

 // Start a fixed-size worker pool.
 workersWG := startWorkers(ctx, workerCount, jobs, results)

 // Close results when all workers finish. The contents of the buffer are still available to be drained
 go func() {
  workersWG.Wait()
  close(results)
 }()

 // Enqueue jobs (producer).
 go func() {
  for i := range totalJobs {
   select {
   case jobs <- Job{ID: i, Payload: fmt.Sprintf("payload-%d", i)}:
   case <-ctx.Done():
    close(jobs)
    return
   }
  }
  close(jobs)
 }()

 // Consume results (collector).
 completed := 0
 for r := range results {
  if r.Err != nil {
   fmt.Printf("job %d error: %v\n", r.JobID, r.Err)
   continue
  }
  fmt.Printf("job %d => %s\n", r.JobID, r.Value)
  completed++
 }

 fmt.Printf("done: processed %d/%d jobs\n", completed, totalJobs)
}

```
