---
title: backoff
---

```go
func backoff(attempt int) time.Duration {
 base := time.Millisecond *100
 // backoff is doubled with each retry, capped at 2^6
 // base << 6 == 100ms doubled 6 times, or 100ms* (2^6) = 6.4s
 d := base << min(attempt, 6) // cap growth
 // get a jitter value which is a random number bounded by zero and base/2
 jitter := time.Duration(rand.Int63n(int64(d / 2)))
 // add jitter to base to get a backoff value that is between d/2 and d (average 0.75d)
 return d/2 + jitter
}

func min(a, b int) int {
 if a < b {
  return a
 }
 return b
}
```
