# Strings

```go
package stringutils

import (
 "regexp"
 "strings"
 "unicode"
)

func StripHexPrefix(s string) string {
 return strings.TrimPrefix(strings.TrimPrefix(s, "0x"), "0X")
}

func removePunctuation(word string) string {
 return strings.Map(func(r rune) rune {
  if unicode.IsPunct(r) {
   return -1
  }
  return r
 }, word)
}

// ToLowerAll converts the entire string to lowercase.
func ToLowerAll(s string) string {
 return strings.ToLower(s)
}

// ToUpperAll converts the entire string to uppercase.
func ToUpperAll(s string) string {
 return strings.ToUpper(s)
}

// RemoveWhitespace trims and removes internal extra spaces.
func RemoveWhitespace(s string) string {
 fields := strings.Fields(s)
 return strings.Join(fields, "")
}

// CollapseSpaces trims and replaces multiple spaces with a single space.
func CollapseSpaces(s string) string {
 fields := strings.Fields(s)
 return strings.Join(fields, " ")
}

// ToLowerFirst makes only the first letter lowercase.
func ToLowerFirst(s string) string {
 if s == "" {
  return s
 }
 r := []rune(s)
 r[0] = unicode.ToLower(r[0])
 return string(r)
}

// ToUpperFirst makes only the first letter uppercase.
func ToUpperFirst(s string) string {
 if s == "" {
  return s
 }
 r := []rune(s)
 r[0] = unicode.ToUpper(r[0])
 return string(r)
}

// IsAlpha checks if the string contains only letters.
func IsAlpha(s string) bool {
 for _, r := range s {
  if !unicode.IsLetter(r) {
   return false
  }
 }
 return len(s) > 0
}

// IsNumeric checks if the string contains only digits.
func IsNumeric(s string) bool {
 for _, r := range s {
  if !unicode.IsDigit(r) {
   return false
  }
 }
 return len(s) > 0
}

// Reverse returns the reversed string (Unicode-safe).
func Reverse(s string) string {
 runes := []rune(s)
 for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
  runes[i], runes[j] = runes[j], runes[i]
 }
 return string(runes)
}

// RemoveNonAlphanumeric removes everything except letters and digits.
func RemoveNonAlphanumeric(s string) string {
 return strings.Map(func(r rune) rune {
  if unicode.IsLetter(r) || unicode.IsDigit(r) {
   return r
  }
  return -1
 }, s)
}

// Slugify converts to lowercase and replaces spaces & punctuation with hyphens.
func Slugify(s string) string {
 s = strings.ToLower(RemovePunctuation(s))
 s = CollapseSpaces(s)
 s = strings.ReplaceAll(s, " ", "-")
 return s
}

// ExtractDigits returns only the digits from a string.
func ExtractDigits(s string) string {
 return strings.Map(func(r rune) rune {
  if unicode.IsDigit(r) {
   return r
  }
  return -1
 }, s)
}

// RegexReplaceAll replaces all occurrences of pattern with repl (safe wrapper).
func RegexReplaceAll(s, pattern, repl string) string {
 re := regexp.MustCompile(pattern)
 return re.ReplaceAllString(s, repl)
}

// ContainsAnyFold checks if s contains any of the substrings (case-insensitive).
func ContainsAnyFold(s string, subs ...string) bool {
 s = strings.ToLower(s)
 for _, sub := range subs {
  if strings.Contains(s, strings.ToLower(sub)) {
   return true
  }
 }
 return false
}
```
