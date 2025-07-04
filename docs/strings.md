# Strings

## Remove Punctuation

```go
func removePunctuation(word string) string {
	return strings.Map(func(r rune) rune {
		if unicode.IsPunct(r) {
			return -1
		}
		return r
	}, word)
}
```
