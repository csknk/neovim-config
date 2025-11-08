---
title: go-client
---

```go
 tr := &http.Transport{
  TLSHandshakeTimeout: 3 * time.Second,
  MaxIdleConns:        100,
  IdleConnTimeout:     30 * time.Second,
 }
 client := &http.Client{
  Transport: tr,
 }
 
 req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
 if err != nil {
  return err
 }
 resp, err := client.Do(req)
 if err != nil {
  return err
 }

 defer func() {
  if closeErr := resp.Body.Close(); closeErr != nil {
   fmt.Fprintf(os.Stderr, "error closing body for %s", url)
  }
 }()

 // return error if bad status code
 if resp.StatusCode < 200 || resp.StatusCode >= 300 {
  return fmt.Errorf("status %d", resp.StatusCode)
 }

 // access resp.Body
 body, err := io.ReadAll(resp.Body)
 if err != nil {
  return FetchResult{}, fmt.Errorf("error reading response from %s: %w", u, err)
 }
 
 return FetchResult{
  URL:     u,
  Status:  resp.StatusCode,
  Body:    body,
  Snippet: string(body)[:80] + "...",
 }, err
 
```
