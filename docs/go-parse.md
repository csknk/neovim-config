---
title: go-parse
---
parsing first 4 bytes from a `[]byte`:

```go
package main

import (
 "bytes"
 "encoding/binary"
 "fmt"
 "log"
)

func main() {
 // Example input (e.g., from a file, network, or message)
 data := []byte{0x01, 0x00, 0x00, 0x00, 0xAA, 0xBB, 0xCC}

 // 1️⃣ Wrap the slice in a *bytes.Reader*
 r := bytes.NewReader(data)

 // 2️⃣ Define a variable of the right size
 var version uint32

 // 3️⃣ Read the first 4 bytes into 'version'
 //    binary.LittleEndian is common for protocols like Bitcoin.
 err := binary.Read(r, binary.LittleEndian, &version)
 if err != nil {
  log.Fatalf("failed to read: %v", err)
 }

 fmt.Printf("version: %d (0x%x)\n", version, version)

 // Reader now points to the 5th byte:
 fmt.Printf("next unread byte: 0x%x\n", data[len(data)-int(r.Len())])
}

```
