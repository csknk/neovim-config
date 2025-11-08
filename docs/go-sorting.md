---
title: go-sorting
---
## 1. Built-in slices of primitives

```go
import "sort"

sort.Ints(nums)         // []int ascending
sort.Float64s(floats)   // []float64 ascending
sort.Strings(strs)      // []string ascending

// Descending
sort.Sort(sort.Reverse(sort.IntSlice(nums)))

## 2. Custom sort with sort.Slice

```go
// Ascending by Age
sort.Slice(people, func(i, j int) bool {
    return people[i].Age < people[j].Age
})

// Descending by Name
sort.Slice(people, func(i, j int) bool {
    return people[i].Name > people[j].Name
})
```

## 3. Implementing sort.Interface (reusable sorter)

```go
type ByAge []Person

func (a ByAge) Len() int           { return len(a) }
func (a ByAge) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a ByAge) Less(i, j int) bool { return a[i].Age < a[j].Age }

// Usage:
sort.Sort(ByAge(people))                 // ascending by Age
sort.Sort(sort.Reverse(ByAge(people)))   // descending by Age
```

## Key reminders

- ByAge(people) is just a cast (no copy).
- Use sort.Slice for quick one-off sorts.
- Use sort.Interface (e.g. ByAge) if you’ll reuse the criterion.
