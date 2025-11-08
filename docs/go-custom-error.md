---
title: go-custom-error
---
## Wrapping an error with fmt.Errorf and checking with errors.Is

```go
package main

import (
 "errors"
 "fmt"
)

var ErrNotFound = errors.New("not found") // sentinel error

func getUser(id int) error {
 if id != 42 {
  // wrap ErrNotFound
  return fmt.Errorf("getUser(%d): %w", id, ErrNotFound)
 }
 return nil
}

func main() {
 err := getUser(10)
 if err != nil {
  // check if underlying cause matches ErrNotFound
  if errors.Is(err, ErrNotFound) {
   fmt.Println("Handled not found error!")
  } else {
   fmt.Println("Some other error:", err)
  }
 }
}

```

Output: `Handled not found error!`

## Custom error type

```go
package main

import (
 "errors"
 "fmt"
)

// Step 1: Define a custom error type
type NotFoundError struct {
 Resource string
}

// This is what makes NotFoundError an error
func (e *NotFoundError) Error() string {
 return fmt.Sprintf("resource not found: %s", e.Resource)
}

// A sentinel (base) error can also be declared for comparison
var ErrNotFound = &NotFoundError{}

// Step 2: A function that returns a wrapped error
func findUser(id int) error {
 if id != 42 {
  // Wrap the custom error
  return fmt.Errorf("findUser failed: %w", &NotFoundError{Resource: fmt.Sprintf("user %d", id)})
 }
 return nil
}

// Step 3: Use errors.Is() to detect the custom error
func main() {
 err := findUser(10)
 if err != nil {
  // Direct type comparison
  if errors.Is(err, ErrNotFound) {
   fmt.Println("Handled NotFoundError via errors.Is()")
  } else {
   fmt.Println("Some other error:", err)
  }
 }
}
```
