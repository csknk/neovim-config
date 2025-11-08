# Worker Group to Limit Max Concurrent Processes

```go
func FetchAll(ctx context.Context, urls []string, maxConcurrency int) map[string]string {
 jobs := make(chan string, len(urls))
 results := make(map[string]string)
 var (
  wg sync.WaitGroup
  mu sync.Mutex
 )

 // Start workers
 for i := 0; i < maxConcurrency; i++ {
  wg.Add(1)
  go func() {
   defer wg.Done()
   for {
    select {
    case <-ctx.Done():
     return
    case url, ok := <-jobs:
     if !ok {
      return
     }
     r, err := FetchURL(url)
     mu.Lock()
     if err != nil {
      results[url] = ""
     } else {
      results[url] = r
     }
     mu.Unlock()
    }
   }
  }()
 }

 // Feed jobs
 for _, url := range urls {
  select {
  case <-ctx.Done():
   break
  case jobs <- url:
  }
 }
 close(jobs)

 wg.Wait()
 return results
}

```
