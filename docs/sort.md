# Sort in Go

```go
type WordFrequency struct {
	Word       string
	Count int
}

type ByFreq []WordFrequency

func (r ByFreq) Len() int {
	return len(r)
}

// Less: If i comes before j, make this return true.
// Should i come before j? If so use >
func (r ByFreq) Less(i, j int) bool {
	if r[i].Count != r[j].Count {
		// Big to small
		return r[i].Count > r[j].Count
	}
	return r[i].Word < r[j].Word
}

func (r ByFreq) Swap(i, j int) {
	r[i], r[j] = r[j], r[i]
}
...
	for _, rW := range resultMap {
		counted = append(counted, rW)
	}
	sort.Sort(ByFreq(counted))



```
