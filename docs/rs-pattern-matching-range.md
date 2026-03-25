---
title: Pattern Matching with Ranges in Rust
date: 11/02/2026_14:34:16
---

```rs
// Inefficient prime finder demonstrates:
// - Pattern matching within ranges 0..=1, 2..n
// - Iterator methods (any)
// - Expression oriented design (no return, everything is an expression)
fn is_prime(n: u64) -> bool {
    match n {
        0..=1 => false,
        _ => !(2..n).any(|d| n % d == 0),
    }
}
```
