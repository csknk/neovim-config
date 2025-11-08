---
title: go-guidelines
---

## Constructors & Types

### Zero value should define default behaviour, or be useful

```go
// Zero value is immediately usable: no init needed.
type Limiter struct {
 // zero values: 0 capacity == unlimited, 0 period == immediate
 capacity int
 period   time.Duration
}

func (l *Limiter) Allow() bool {
 // zero value acts like "always allow" - so an empty Limiter has meaning
 if l.capacity == 0 || l.period == 0 {
  return true
 }
 // ... real logic
 return true
}
```

### Validating Constructor - Envorce Invariants

```go
type Email struct {
 addr string // unexported to prevent invalid mutation
}

func NewEmail(s string) (Email, error) {
 // Enforcement:
 if s == "" {
  return Email{}, fmt.Errorf("email: empty")
 }
 if _, err := mail.ParseAddress(s); err != nil {
  return Email{}, fmt.Errorf("email: %w", err)
 }
 return Email{addr: s}, nil
}

type User struct {
 email Email
 age   int
}

func NewUser(email Email, age int) (User, error) {
 if age < 0 {
  return User{}, fmt.Errorf("age must be >= 0")
 }
 return User{email: email, age: age}, nil
}

```

## Constants

Use named constants instead of magic values. `http.StatusOK` is self-explanatory; 200 isn’t

Prevent security holes by using os.Root instead of os.Open, eliminating path traversal attacks:

```go
root, err := os.OpenRoot("/var/www/assets")
if err != nil {
    return err
}
defer root.Close()
file, err := root.Open("../../../etc/passwd")
// Error: 'openat ../../../etc/passwd: path escapes from parent'
<code data-enlighter-language="generic" class="EnlighterJSRAW"></code>
```
