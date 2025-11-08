---
title: Rust Pattern-Matching Cheatsheet (what to use, when)
---
Choosing the construct

- `match` statement → Multiple cases, exhaustive handling, returns a value.
- `if let` → You care about one pattern and want to ignore the rest.
- `while let` → Keep pulling values from an iterator/stack until a pattern fails.
- `let ... else` → Early-exit if a single pattern doesn’t match (since Rust 1.65).
- `matches!` macro → Boolean check (“does this value match this pattern?”).

## Core pattern syntax (works across constructs)

- Wildcards/ignore: `_`, and prefix `_name`
- Destructure: `Struct { a, b }`, `Enum::Var(x, y)`, `(x, y)`, `[a, b, ..]`
- Or-patterns: `p1 | p2 | p3`
- Ranges (integers/char): `0..=9`, `'a'..='z'`
- Bindings with test: `id @ 100..=199`
- Ignore “the rest”: `..` (struct/tuple/array/slice tails)
- Guards: `pattern if condition`
- References: `&x`, `&mut x`, `ref x`, `ref mut x` (rarely needed; see examples)

## `match` — exhaustive, expressive

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    Num(u32),
}

fn handle(msg: Message) -> String {
    match msg {
        Message::Quit => "bye".into(),

        // Struct variant destructure + guard
        Message::Move { x, y } if x == y => format!("diagonal {x}"),

        Message::Move { x, y } => format!("move {x},{y}"),

        // Tuple-like variant with binding + range
        Message::Num(n @ 1..=9) => format!("small {n}"),
        Message::Num(n) => format!("num {n}"),

        // Or-pattern of literals
        Message::Write(s) if matches!(s.as_str(), "ok" | "yes") => "affirmative".into(),
        Message::Write(s) => format!("say {s}"),
    }
}
```

Tips

- Use or-patterns to merge identical arms: `0 | 2 | 4 => "even"`.
- Use `_` or `..` to ignore fields you don’t need.
- Return values directly; `match` is an expression.

## `if let`: Single Pattern Focus

- Great when you only need the success case (e.g., `Some`, `Ok`, certain enum variant).
- You can add an `else` for the fallback, but if there are many cases, prefer `match`.

```rust
fn print_some(v: Option<i32>) {
    if let Some(x) = v {
        println!("got {x}");
    } else {
        println!("none");
    }
}
```

`if let` is syntactic sugar for a partial match.

```rust
// This:
if let Ok(v) = res {
  use_it(v)
}

// ...is syntactic sugar for this:
match res {
  Ok(v) => { use_it(v); }()()
  _ => {}
}
```

## `while let` — loop while pattern keeps matching

```rust
fn drain(mut it: impl Iterator<Item = i32>) {
    while let Some(x) = it.next() {
        println!("{x}");
    }
}
```

- Cleaner than manual `loop { match it.next() { ... } }`

## `let PATTERN = expr;` — destructuring binds

```rust
let (x, y, z) = (1, 2, 3);
let Point { x: px, y, .. } = Point { x: 10, y: 20 };
```

- Panics at runtime if the pattern can’t match; prefer `let ... else` to handle failure.

```rust
fn parse_port(s: &str) -> Result<u16, String> {
    let Ok(n) = s.parse::<u16>() else {
        return Err("not a u16".into());
    };
    Ok(n)
}
```

## `matches!` — quick boolean checks

```rust
let ready = matches!(state, State::Ready | State::Warm if temp > 30);
```

## Common Types & Idioms

### `Option<T>`

```rust
match maybe {
    Some(v) => do_something(v),
    None => default(),
}

// if-let when you only care about Some
if let Some(v) = maybe { use_it(v); }
```

### `Result<T, E>`

```rust
// To handle a result from both arms, 
match res {
    Ok(v) => handle(v),
    Err(e) => report(e),
}

// if-let for one-sided match
// This only handles the Ok case and ignores everything else (here, the Err case is a no-op).
// Ownership: Also consumes res by default, moving T into use_it(v).
if let Ok(v) = res { use_it(v); }
```

### Enums (tuple & struct variants)

```rust
enum Token {
    Ident(String),
    Number(i64),
    Arrow,     // unit variant
    Span { lo: usize, hi: usize },
}

fn classify(t: Token) {
    match t {
        Token::Ident(name) => println!("id {name}"),
        Token::Number(n @ 0..=9) => println!("small {n}"),
        Token::Number(n) => println!("{n}"),
        Token::Arrow => println!("→"),
        Token::Span { lo, hi } => println!("span {lo}-{hi}"),
    }
}
```

### Tuples

```rust
let pair = (3, "hi");
match pair {
    (0, _) => {}
    (x, s) if s.len() > 1 => println!("{x}:{s}"),
    _ => {}
}
```

### Structs

```rust
struct User { id: u64, name: String, admin: bool }
let u = User { id: 7, name: "Ada".into(), admin: true };

match u {
    User { admin: true, id, .. } => println!("admin #{id}"),
    User { name, .. } if name.starts_with('A') => println!("A*"),
    _ => {}
}
```

### Arrays & Slices

```rust
fn head_tail(xs: &[i32]) {
    match xs {
        [] => println!("empty"),
        [only] => println!("one: {only}"),
        [first, rest @ ..] => println!("first={first}, rest={rest:?}"),
    }
}

// Fixed-size array (pattern must match length)
let [a, b, ..] = [1, 2, 3, 4]; // OK (arrays >= length, tail elided)
```

### Strings/`&str`

- You can match literal patterns: `match s { "yes" | "ok" => ... , _ => ... }`
- For dynamic conditions (prefix/suffix/etc.), use guards: `match s { _ if s.starts_with("0x") => ..., _ => ... }`

### References & Ownership Ergonimics

Match references with reference patterns:

```rust
let r: &Option<i32> = &Some(5);
match r {
    // note the &Some to match through reference
    &Some(n) => println!("{n}"),
    &None => {}
}
```

But idiomatic Rust leverages **match ergonomics** - the compiler inserts refs/derefs so you can usually write:

```rust
let r: &Option<i32> = &Some(5);
match r {
    Some(n) => println!("{n}"), // works (auto-deref)
    None => {}
}
```

For mutable borrows:

```rust
let mut v = Some(String::from("hi"));
if let Some(s) = v.as_mut() {
    s.push('!');
}
```

### Binding with @

```rust
match code {
    n @ 100..=199 => println!("1xx ({n})"),
    n @ 200..=299 => println!("2xx ({n})"),
    _ => {}
}

```

### Or-patterns

```rust
match ch {
    'a' | 'e' | 'i' | 'o' | 'u' => println!("vowel"),
    _ => println!("other"),
}
```

### Guards (`if`)

```rust
match n {
    x if x % 2 == 0 => println!("even"),
    _ => println!("odd"),
}
```

- `x` is a pattern variable that binds to the value of `n`.
- So if `n = 6`, then `x = 6` inside that arm.
- The guard `if x % 2 == 0` is then checked — if true, this branch is chosen.
- If the guard fails, Rust doesn’t “consume” the match — it just moves on and tries the next arm (`_` in your case).

## Control-flow shortcuts

### Early return with pattern failure

```rust
fn first_two(xs: &[i32]) -> Option<(i32, i32)> {
    let [a, b, ..] = *xs else { return None; };
    Some((a, b))
}
```

### Looping Extract

```rust
let mut stack = vec![1, 2, 3];
while let Some(top) = stack.pop() {
    // use top
}
```

## Pitfalls & tips

- Exhaustiveness: `match` must cover all cases. Use `_` as a final catch-all.
- Order matters: First matching arm runs; put specific arms before `_`.
- Ranges: Only inclusive `..=` is allowed in patterns.
- `..` elision: In structs/tuples/arrays, `..` means “ignore the rest”; you can’t use it twice at the same level.
- Borrowing: Prefer `.as_ref()`, `.as_mut()`, `.as_deref()`, `.as_deref_mut()` to avoid moving.
- Performance: Pattern matching is compiled to efficient tests; guards run after a pattern matches.

## Mini reference: when to pick what?

- “I need to branch on an enum (Option/Result/your enum) and return a value” → `match`
- “I only care about the Some/Ok case inline” → `if let`
- “Consume while next item is `Some(x)`” → `while let`
- “Fail fast if destructuring doesn’t work” → `let PATTERN = expr else { ... }`
- “Just need a bool for a filter/any/all” → `matches!(value, PATTERN)`

## TL;DR

```rust
// Or-patterns
match x { 0 | 2 | 4 => "even", _ => "odd" }

// Ranges + binding
match n { id @ 100..=199 => id, _ => 0 }

// Destructure struct
let User { id, name, .. } = user;

// Destructure tuple / slice
let (a, b) = pair;
match xs.as_slice() { [first, rest @ ..] => { /* ... */ }, [] => {} , _ => {} }

// Guards
match p { (x, y) if x == y => "diag", _ => "other" }

// if let / while let
if let Some(v) = opt { /* ... */ }
while let Some(v) = iter.next() { /* ... */ }

// let-else
let Some(v) = opt else { return Err("no value"); };

// matches!
let is_digit = matches!(ch, '0'..='9');
```
