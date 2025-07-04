# WaitGroups for Limited Concurrency

```go
func FetchAll(urls []string, maxConcurrency int) map[string]string {
	var (
		wg  sync.WaitGroup
		mu  sync.Mutex
		sem = make(chan struct{}, maxConcurrency)
	)
	result := make(map[string]string, len(urls))

	for _, url := range urls {
		url := url // capture loop variable

		// add to wg outside the goroutine
		wg.Add(1)

		go func() {
			defer wg.Done()

			// Take a token from the semaphore, return it when finished.
			// Achieved by adding an empty struct to the buffered channel. If channel is full, this will block.
			sem <- struct{}{}

			// Take from the semaphore channel, freeing up a token.
			defer func() { <-sem }()

			r, err := FetchURL(url)

			// Lock when accessing the map
			mu.Lock()
			if err != nil {
				result[url] = ""
			} else {
				result[url] = r
			}
			mu.Unlock()
		}()
	}
	wg.Wait()
	defer func() { close(sem) }()
	return result
}
```

With Context:

```go
func FetchAll(ctx context.Context, urls []string, maxConcurrency int) map[string]string {
	var (
		wg  sync.WaitGroup
		mu  sync.Mutex
		sem = make(chan struct{}, maxConcurrency)
	)
	result := make(map[string]string, len(urls))

	for _, url := range urls {
		url := url // capture loop variable
		wg.Add(1)
		go func() {
			defer wg.Done()

			select {
			case <-ctx.Done():
				// Skip this fetch if context is cancelled
				return
			case sem <- struct{}{}:
				// Acquired slot
			}
			defer func() { <-sem }() // free the slot

			r, err := FetchURL(url)

			mu.Lock()
			if err != nil {
				result[url] = ""
			} else {
				result[url] = r
			}
			mu.Unlock()
		}()
	}

	wg.Wait()
	return result
}

```
