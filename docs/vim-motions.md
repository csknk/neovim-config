# 🧭 Vim Motions Cheat Sheet & Practice Plan

> A focused guide to mastering Vim movement, especially for developers.

---

## 🎯 Essential Motions

### 📄 By Character
- `h` → Left
- `l` → Right
- `0` → Start of line
- `^` → First non-blank character
- `$` → End of line

### 🧱 By Word
- `w` → Next word
- `W` → Next WORD (ignores punctuation)
- `e` → End of word
- `b` → Previous word

### 🧭 By Paragraph/Block
- `{` → Previous paragraph
- `}` → Next paragraph
- `[[` / `]]` → Move to previous/next function (code)

### 🔍 Search
- `/pattern` → Search forward
- `?pattern` → Search backward
- `n` → Next match
- `N` → Previous match

### 🚀 File Navigation
- `gg` → Start of file
- `G` → End of file
- `nG` → Line `n`
- `%` → Jump to matching `()`, `{}`, `[]`

---

## 🎓 Motion + Command Combos

- `dw` → delete word
- `d$` → delete to end of line
- `cW` → change WORD
- `y}` → yank paragraph
- `v0$` → visual select entire line

---

## 🧠 Practice Plan (30 Min Routine)

### ✅ 5 min — Warm-up (Use Vim Genius / OpenVim)
- Drill motions: `w`, `e`, `b`, `0`, `^`, `$`, `gg`, `G`, `}`, `{`

### ✅ 10 min — Real-File Navigation
- Use only Vim keys to jump through `.go`, `.md`, or `.json` files
- Practice searches `/`, `n`, and paragraph jumping `{`, `}`

### ✅ 10 min — Motion + Action Combos
Try using:
- `dw`, `d2w`, `c$`, `yG`, `ci"` etc.
- Work in NORMAL mode — no arrow keys!

### ✅ 5 min — Fun Reinforcement
- Play [Vim Adventures](https://vim-adventures.com/)
- Try [VimTutor Online](https://vimtutoronline.com/)

---

## ✅ Mastery Checklist

```text
[x] Word motions (w, e, b)
[x] Line anchors (0, ^, $)
[ ] Paragraphs ({, })
[ ] Searching (/pattern, n, N)
[ ] Motion + operator (d, c, y + motions)
