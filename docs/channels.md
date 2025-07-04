
# Go Channels Cheatsheet

## Channel Basics

```go
ch := make(chan int)        // Unbuffered channel
ch := make(chan int, 10)    // Buffered channel
```

## Sending & Receiving

```go
ch <- 42        // Send value into channel
val := <-ch     // Receive value from channel
```

Note: Sending/receiving on unbuffered channels blocks until the other side is ready.

## Goroutines + Channels

```go
go func() {
    ch <- "hello"
}()
msg := <-ch
fmt.Println(msg)
```

## Closing Channels

```go
close(ch)
```

- **Senders** should close channels to indicate no more values will be sent.
- **Receivers** can check using:

```go
v, ok := <-ch
if !ok {
    // channel closed
}
```

## Ranging Over Channels

```go
for val := range ch {
    fmt.Println(val)
}
```

Loop exits when channel is closed.

## Buffered Channels

```go
ch := make(chan string, 2)
ch <- "foo"
ch <- "bar"
// no blocking unless buffer is full
```

## Select Statement

```go
select {
case msg1 := <-ch1:
    fmt.Println("received", msg1)
case ch2 <- msg2:
    fmt.Println("sent", msg2)
default:
    fmt.Println("no communication")
}
```

Great for multiplexing and avoiding blocking on a single channel.

## Timeouts with `select`

```go
select {
case res := <-ch:
    fmt.Println("got", res)
case <-time.After(1 * time.Second):
    fmt.Println("timeout")
}
```

## Preventing Goroutine Leaks

Use `done` channels or contexts to signal cancellation:

```go
done := make(chan struct{})

go func() {
    for {
        select {
        case <-done:
            return
        // other cases...
        }
    }
}()
```

## Tips

- Unbuffered channels are for synchronization.
- Buffered channels are for decoupling sender/receiver pace.
- Never send on a closed channel — it panics.
- It's OK to close a nil channel (does nothing), but sending/receiving blocks forever.
