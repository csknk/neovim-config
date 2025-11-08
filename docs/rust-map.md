---
title: rust-map
---
```rust
let mut map: HashMap<String, i32> = HashMap::new();
let count = map
        .entry(k) // Gets the given key's corresponding entry in the map for in-place manipulation.
        .and_modify(|v| *v += 1) // Provides in-place mutable access to an occupied entry before any potential inserts into the map.
        .or_insert(2); // Ensures a value is in the entry by inserting the default if empty, and returns a mutable reference to the value in the entry.
```

## Simple Lookup

Returns a reference to the value corresponding to the key.

The key may be any borrowed form of the map's key type, but [`Hash`](https://doc.rust-lang.org/stable/core/hash/trait.Hash.html) and [`Eq`](https://doc.rust-lang.org/stable/core/cmp/trait.Eq.html) on the borrowed form *must* match those for the key type.

```rust
use std::collections::HashMap;

let mut map = HashMap::new();
map.insert(1, "a");
assert_eq!(map.get(&1), Some(&"a"));
assert_eq!(map.get(&2), None);
```

## Modify a Map Value that is a Collection

```rust
let mut map: HashMap<i8, Vec<i8>> = HashMap::new();
let key = 42;
map.entry(key).or_default(); // Initialises a map entry for key with an empty Vector

let v: i8 = 13;
map.get_mut(&key).unwrap().push(v); // Access an existing value and mutate it; need to be sure it exists
map.entry(key).or_default().push(1); // Possibly safer, entry() allows the default to be added before push
```
