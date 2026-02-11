---
title: ts-async
date: 10/02/2026_11:45:34
---

```ts
// index.ts

async function fetchNumber(): Promise<number> {
  // simulate async work (I/O, DB, HTTP, etc.)
  return new Promise((resolve) => {
    setTimeout(() => resolve(42), 500);
  });
}

async function main(): Promise<void> {
  try {
    const result = await fetchNumber();
    console.log("result:", result);
  } catch (err) {
    console.error("error:", err);
  }
}

main();
```
