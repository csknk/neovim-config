---
title: go-expand-path
date: 04/11/2025_10:41:13
---

```go
// expandPath expands a given file path by resolving environment variables and
// the leading ~ symbol. If the input path is empty, an empty string is
// returned.
// Parameters:
// - p: a string representing the file path to expand
// Returns:
// - string: the expanded file path
// - error: an error if any occurred during the expansion process
func expandPath(p string) (string, error) {
 if p == "" {
  return "", nil
 }
 // Expand env vars
 p = os.ExpandEnv(p)
 // Expand leading ~
 if strings.HasPrefix(p, "~") {
  home, err := os.UserHomeDir()
  if err != nil {
   return "", fmt.Errorf("resolve home dir: %w", err)
  }
  p = filepath.Join(home, strings.TrimPrefix(p, "~"))
 }
 abs, err := filepath.Abs(p)
 if err != nil {
  return "", fmt.Errorf("abs path: %w", err)
 }
 return abs, nil
}

```
