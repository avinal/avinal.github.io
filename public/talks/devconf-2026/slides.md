<!-- ===================================================== -->
<!-- SECTION 1: THE PROBLEM (mystery opening)              -->
<!-- ===================================================== -->

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

```bash
$ printf 'Dvořák' | wc -c
```
<!-- .element: data-id="mystery-code" -->

Note:
**Do:** Walk on stage, put terminal on screen, no output yet. Pause 3-4 seconds. Ask: "What do you think this prints?"

- **wc** = word count; **-c** = count bytes (not characters)
- Dvořák = Czech composer surname, pronounced "DVOR-zhahk"

--

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

```bash
$ printf 'Dvořák' | wc -c
8
```
<!-- .element: data-id="mystery-code" -->

Note:
**Do:** Reveal the 8. Pause. Dvořák has 6 visible letters — why 8? Don't explain yet.

- wc -c counts bytes, not characters — this is POSIX behavior, not a bug

--

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

```bash
$ printf 'Dvořák' | wc -c
8
```
<!-- .element: data-id="mystery-code" -->

<br />

How many people think this is **wrong**?
<!-- .element: class="medium" -->

Note:
**Do:** Ask the question. Wait 5 seconds. Let hands go up. Do NOT answer yet.

--

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

```bash
$ printf 'Dvořák' | wc -c
8

$ python3 -c "print(len('Dvořák'))"
6
```
<!-- .element: data-id="mystery-code" -->

Note:
Two different answers for the same string. Let the confusion build.

- Python 3 len() counts Unicode code points, not bytes
- *Exception:* Python 2 len() counted bytes — this changed in 2→3

--

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

```bash
$ printf '😀' | wc -c
4

$ python3 -c "print(len('😀'))"
1
```
<!-- .element: data-id="mystery-code" -->

Note:
An emoji: 4 bytes vs 1 character.

- 😀 = U+1F600 "Grinning Face." Needs 4 bytes in UTF-8 (F0 9F 98 80) because it's above the **BMP** (Basic Multilingual Plane, U+0000–U+FFFF)
- *Exception:* On macOS, `echo` appends a newline — use `printf` to avoid off-by-one

--

<!-- .slide: data-background-color="#2f2f2f" -->

Which one is **correct**?
<!-- .element: class="big" -->

All of them.
<!-- .element: class="fragment zoom-in glow-blue big" -->

Understanding why is basically the entire talk.
<!-- .element: class="fragment fade-up small dim" -->

Note:
**Do:** Pause before "All of them." Then: *"They're counting different things. wc counts bytes. Python counts code points. Both correct."*

**Key thesis:** bytes ≠ characters ≠ code points

---

<!-- ===================================================== -->
<!-- SECTION 2: INTRODUCTION                               -->
<!-- ===================================================== -->

<!-- .slide: data-background-color="#2f2f2f" data-transition="zoom" -->

## Lost in Transliteration

Why `strlen("Dvořák")` Returns **8**
<!-- .element: class="medium" style="opacity: 0.9" -->

<br />

Avinal Kumar · glibc contributor
<!-- .element: style="font-weight: 500" -->

<span class="badge badge-blue">DevConf.CZ 2026</span>
<!-- .element: class="small dim" -->

Note:
**Do:** Brief intro, under 30 seconds:
*"I'm Avinal. I contribute to glibc — the GNU C Library. I got into character encodings through an iconv bug at the glibc workshop here at DevConf. Today I'll take you through that journey."*

- **glibc** = GNU C Library — the standard C library on most Linux distros
- **iconv** = POSIX API for converting text between character encodings

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

### Today we'll answer

1. Why does `strlen("Dvořák")` return 8?
2. Why does Unicode exist?
3. How does the C library handle text?
4. How does `iconv` convert between encodings?
5. Does any of this still matter in 2026?

Note:
**Do:** Read out loud. Give the audience a roadmap. Don't linger.

- **strlen** = "string length" — counts bytes before the null terminator, NOT characters

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="fade" -->

<span class="glow-blue big">There is no such thing as plain text.</span>

<br />

If you remember one thing from this talk, remember that sentence.
<!-- .element: class="fragment fade-up small dim" -->

Note:
**Do:** Say this slowly. Pause. *"If you remember one thing, remember that sentence."*

- "Plain text" implies no encoding — but every byte sequence *has* an encoding. If you don't know it, you're guessing. Wrong guess = **mojibake** (文字化け, Japanese for garbled text, pronounced "mo-ji-ba-keh")

---

<!-- ===================================================== -->
<!-- SECTION 3: HISTORY                                    -->
<!-- ===================================================== -->

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">How we ended up with this mess</p>

### ASCII: The 7-bit world

<div class="two-col">
<div>

- 128 characters (0–127)
- 7 bits per character
- English letters, digits, punctuation
- Bit 8 was "spare"

</div>
<div>

```text
0x41 = A
0x61 = a
0x30 = 0
0x20 = (space)
0x0A = (newline)
```

</div>
</div>

*"And all was good — if you spoke English."*
<!-- .element: class="fragment fade-up" -->

Note:
- **ASCII** = American Standard Code for Information Interchange (1963)
- 7 bits = 128 values. The 8th bit was for parity checking on noisy telegraph lines
- Only covers English — no accented chars, no Cyrillic, no CJK, no Arabic

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">How we ended up with this mess</p>

### Code Pages: Everyone fills bit 8 differently

If I send byte `0xE9` from Paris to Moscow, what character arrives?
<!-- .element: class="medium" -->

| Byte | CP-1252 (Western) | CP-866 (Russian) | CP-862 (Hebrew) |
|------|-------------------|-------------------|------------------|
| `0xE9` | é | щ | ט |
| `0xC4` | Ä | ─ | ד |
| `0xF1` | ñ | ё | ס |

<!-- .element: class="fragment fade-in" -->

CJK needed **thousands** — multi-byte encodings (Shift-JIS, EUC-KR, GB2312) where you can't even move backward in a string.
<!-- .element: class="fragment fade-up small" -->

Note:
**Do:** Ask *"If I send byte 0xE9 from Paris to Moscow, what character arrives?"* before revealing the table.

- **CP** = Code Page. CP-1252 = Windows Western. CP-866 = DOS Russian. CP-862 = DOS Hebrew
- Same byte, different characters — the bytes are correct, the *interpretation* is wrong
- **CJK** = Chinese, Japanese, Korean
- **Shift-JIS** = Shift Japanese Industrial Standards. **EUC-KR** = Extended Unix Code for Korean. **GB2312** = Chinese National Standard
- *Exception:* Multi-byte encodings have a "forward-only" problem — you can't tell if a byte is byte 1 or byte 2 of a character

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">How we ended up with this mess</p>

### Unicode: One number per character

```text
U+0041 = A      U+00E9 = é      U+010D = č
U+0639 = ع      U+4E16 = 世      U+1F600 = 😀
```

- Code points are **abstract numbers**, not bytes <!-- .element: class="fragment fade-up" -->
- <span class="red">Not</span> "16-bit characters" — that's the myth <!-- .element: class="fragment fade-up" -->
- 154,998 characters across 168 scripts <!-- .element: class="fragment fade-up" -->

Unicode separated the *idea* of a character from how it's stored.
<!-- .element: class="fragment zoom-in accent" -->

Note:
- **Unicode** = Universal Coded Character Set (1991, Unicode Consortium)
- Code points are abstract numbers — how you *store* them is a separate question (that's what encodings answer)
- *Exception:* "Unicode is 16-bit" myth comes from Unicode 1.0 (1991) which only planned 65,536 chars. Unicode 2.0 (1996) expanded beyond 16 bits. Java and Windows adopted UTF-16 before that expansion, and are now stuck with it
- **BMP** = Basic Multilingual Plane (U+0000–U+FFFF). Characters above it (emoji, rare scripts) are in supplementary planes

---

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">How we ended up with this mess</p>

### Encodings: Serialization formats

<div class="three-col">
<div class="card fragment fade-up" data-fragment-index="1">
<h4 class="glow-blue">UTF-8</h4>

- 1–4 bytes
- ASCII-compatible
- <span class="badge badge-blue">98% of the web</span>
</div>
<div class="card fragment fade-up" data-fragment-index="2">
<h4 class="yellow">UTF-16</h4>

- 2 or 4 bytes
- Needs BOM
- <span class="badge badge-yellow">Windows, Java</span>
</div>
<div class="card fragment fade-up" data-fragment-index="3">
<h4 class="green">UTF-32</h4>

- Fixed 4 bytes
- Simple but wasteful
- <span class="badge badge-green">glibc internal</span>
</div>
</div>

Note:
- **UTF** = Unicode Transformation Format
- **UTF-8:** Designed 1992 by Ken Thompson & Rob Pike. ASCII bytes are identical — this is why it won. 98.2% of websites (W3Techs, 2024)
- **UTF-16:** Uses surrogate pairs above U+FFFF. **BOM** = Byte Order Mark (U+FEFF) — indicates endianness
- **UTF-32:** Also called **UCS-4** (Universal Coded Character Set, 4-byte). "hello" = 20 bytes instead of 5
- *Exception:* UTF-32 and UCS-4 are technically from different standards (ISO 10646 vs Unicode), but identical in practice

--

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

<p class="slide-title">How we ended up with this mess</p>

### Encodings: Serialization formats

<div class="hex-display" data-id="encoding-hex">
"Dvořák" in UTF-8: &nbsp;44 76 6F <span class="red" style="font-weight:700;">C5 99</span> C3 A1 6B &nbsp;&nbsp;&nbsp;<span class="badge badge-blue">8 bytes</span><br />
"Dvořák" in UTF-32: 00000044 00000076 0000006F <span class="red" style="font-weight:700;">00000159</span> 000000E1 0000006B &nbsp;<span class="badge badge-green">24 bytes</span>
</div>

<span class="glow-blue big">There is no such thing as plain text.</span>
<!-- .element: class="fragment zoom-in" -->

Note:
UTF-8 breakdown:
- D, v, o, k = 1 byte each (ASCII range)
- ř = C5 99 (2 bytes, U+0159)
- á = C3 A1 (2 bytes, U+00E1)
- Total: 4×1 + 2×2 = **8 bytes** for 6 characters

UTF-32: every char = 4 bytes → 6×4 = **24 bytes**. Same string, 3× the size.

---

<!-- ===================================================== -->
<!-- SECTION 4: INTO C — real examples, not code           -->
<!-- ===================================================== -->

<!-- .slide: data-background-color="#2f2f2f" data-transition="zoom" -->

<span class="badge badge-blue" style="font-size: 0.6em;">Part 2</span>

## Text in C: What actually happens

Note:
**Do:** *"Now we understand WHY bytes and characters differ. Let's see how C deals with it."*

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Text in C</p>

### C has two ways to see a string

<div class="two-col">
<div class="card">

#### `char` — bytes
- 1 byte per element, no encoding info
- `strlen("Dvořák")` → **8**
- `strlen("😀")` → **4**
- Indexing gives you bytes, not characters

</div>
<div class="card">

#### `wchar_t` — code points
- 4 bytes on Linux, <span class="red">2 on Windows</span>
- `wcslen(L"Dvořák")` → **6**
- `wcslen(L"😀")` → **1**
- Indexing gives you characters

</div>
</div>

<br />

`mbrtowc()` bridges between them. `setlocale()` tells it which encoding to expect.
<!-- .element: class="fragment fade-up small" -->

Note:
- **wchar_t** = "wide character type." Linux: 4 bytes (UCS-4). Windows: 2 bytes (UTF-16)
- **wcslen** = "wide character string length"
- **L"..."** prefix = wide string literal
- **mbrtowc** = "multibyte restartable to wide character" — converts one multibyte char to one wchar_t
- **setlocale** with LC_CTYPE tells mbrtowc the encoding. Without it → "C" locale = ASCII only
- *Exception:* On Windows, wcslen(L"😀") returns **2** (surrogate pair), not 1

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Text in C</p>

### What does "Dvořák" look like in memory?

```text
 Character:   D     v     o     ř        á        k
 UTF-8 hex:  44    76    6F   C5 99    C3 A1     6B
 Bytes:       1     1     1     2        2        1   =  8 bytes
 Code points: 1     1     1     1        1        1   =  6 characters
```

`strlen` counts the top row. `wcslen` counts the bottom row.
<!-- .element: class="fragment fade-up small" -->

Now you know why `strlen("Dvořák")` returns 8.
<!-- .element: class="fragment fade-up accent" -->

Note:
**Do:** Point at the diagram: *"strlen counts bytes: 1+1+1+2+2+1 = 8. wcslen counts characters: always 1 each = 6. Both correct."*

This is the answer to the opening mystery.

---

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

<p class="slide-title">Text in C</p>

### `iconv` — converting between encodings

```bash
$ echo 'Dvořák' | iconv -f UTF-8 -t ASCII
iconv: illegal input sequence at position 3
```
<!-- .element: data-id="iconv-demo" -->

Note:
- **iconv** = both a C API (iconv_open/iconv/iconv_close in `<iconv.h>`) and a CLI tool
- **-f** = from, **-t** = to
- Position 3 = 4th byte (0-indexed) = where ř starts. ASCII only has 0–127; C5 = 197 → fails
- **EILSEQ** = "illegal sequence" errno value

--

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

<p class="slide-title">Text in C</p>

### `iconv` — converting between encodings

```bash
$ echo 'Dvořák' | iconv -f UTF-8 -t ASCII
iconv: illegal input sequence at position 3

$ echo 'Dvořák' | iconv -f UTF-8 -t ASCII//TRANSLIT
Dvorak

$ echo 'Dvořák' | iconv -f UTF-8 -t ASCII//IGNORE
Dvok
```
<!-- .element: data-id="iconv-demo" -->

- **`//TRANSLIT`** — approximate: ř→r, á→a
- **`//IGNORE`** — drop what doesn't fit

Note:
- **//TRANSLIT** = transliteration. Appended to target encoding. Finds closest match: ř→r, á→a, ö→o, ñ→n
- **//IGNORE** = silently drop unconvertible chars. Notice "Dvok" — both ř AND á dropped
- *Exception:* //TRANSLIT is glibc-specific, not POSIX. musl libc (Alpine Linux) doesn't support it

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Text in C</p>

### Real encoding pairs from across the world

```bash
$ echo '東京' | iconv -f UTF-8 -t SHIFT_JIS | hexdump -C
00000000  93 8c 8b 9e 0a                          |.....|

$ echo 'こんにちは世界' | iconv -f UTF-8 -t EUC-JP | hexdump -C
00000000  a4 b3 a4 f3 a4 cb a4 c1  a4 cf c0 a4 b3 a6 0a  |...............|

$ echo 'Ελληνικά κείμενο' | iconv -f UTF-8 -t ISO-8859-7 | hexdump -C
00000000  c5 eb eb e7 ed e9 ea dc  20 ea e5 df ec e5 ed ef  |........ .......|
```

Same characters, completely different bytes — depending on the encoding.
<!-- .element: class="fragment fade-up small" -->

Note:
- 東京 = Tōkyō (Tokyo)
- こんにちは世界 = "Konnichiwa Sekai" = "Hello World"
- Ελληνικά κείμενο = "Elliniká keímeno" = "Greek text"
- **hexdump -C** = canonical hex+ASCII dump. Non-ASCII shows as dots
- Same text in Shift-JIS vs EUC-JP → completely different bytes. Without knowing the encoding, unreadable

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Text in C</p>

### When conversion fails

```bash
$ echo 'مرحبا' | iconv -f UTF-8 -t ISO-8859-1
iconv: illegal input sequence at position 0

$ echo 'Résumé' | iconv -f UTF-8 -t CP866
iconv: illegal input sequence at position 1

$ echo -ne '\xEF\xBB\xBFhello' | hexdump -C
00000000  ef bb bf 68 65 6c 6c 6f                  |...hello|

$ echo -ne '\xEF\xBB\xBFhello' | iconv -f UTF-8 -t ASCII//TRANSLIT
hello
```

- Arabic → Latin-1: impossible — the encoding can't hold it
- French Résumé → Russian CP866: `é` doesn't exist in that code page
- BOM: 3 invisible bytes at the start — your first "character" is garbage

Note:
- مرحبا = "marhaba" = "hello" in Arabic
- **ISO-8859-1** = Latin-1. Zero Arabic chars → fails at position 0
- **CP866** = DOS Cyrillic. é doesn't map → fails at position 1 (R is fine, é isn't)
- **BOM** = Byte Order Mark (U+FEFF, encoded EF BB BF in UTF-8). Windows Notepad adds it. Breaks JSON parsers, shell shebangs, and string comparisons

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Text in C</p>

### Longer text, bigger difference

```bash
$ printf 'Příliš žluťoučký kůň úpěl ďábelské ódy' | wc -c
53

$ python3 -c "print(len('Příliš žluťoučký kůň úpěl ďábelské ódy'))"
38

$ echo 'Příliš žluťoučký kůň úpěl ďábelské ódy' \
    | iconv -f UTF-8 -t ASCII//TRANSLIT
Prilis zlutoucky kun upel dabelske ody
```

A Czech pangram: **38 characters**, **53 bytes** — a 40% difference.
<!-- .element: class="fragment fade-up" -->

`//TRANSLIT` strips all diacritics and produces valid ASCII.
<!-- .element: class="fragment fade-up small" -->

Note:
- **Translation:** "Too yellow a horse groaned devilish odes" — a Czech pangram (like "The quick brown fox" but for testing diacritics)
- 15 extra bytes from accented characters: each adds 1 byte in UTF-8
- Czech diacritics: **háček** (ˇ) = caron (ř, š, č, ž, ň, ď, ť, ě), **čárka** (´) = acute (á, é, í, ó, ú), **kroužek** (°) = ring (ů)
- **Do:** DevConf is in Brno — the audience will recognize this pangram

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Text in C</p>

### How many encodings?

```bash
$ iconv -l | wc -l
1180

$ find /usr/lib64/gconv -name '*.so' | wc -l
253
```

**1180** encoding names served by **253** shared libraries.
<!-- .element: class="fragment fade-up" -->

How does glibc manage this without writing thousands of converters?
<!-- .element: class="fragment fade-up accent" -->

Note:
**Do:** LIVE DEMO if possible.

- **iconv -l** = list all encodings. 1180 includes aliases (SHIFT-JIS, SJIS, MS_KANJI = same encoding)
- **/usr/lib64/gconv/** = where glibc stores converter .so files (Fedora/RHEL). Debian: /usr/lib/x86_64-linux-gnu/gconv/
- **.so** = shared object (dynamically loaded library)
- 1180 names, 253 plugins — far fewer than the 39,800 needed for N×N

---

<!-- ===================================================== -->
<!-- SECTION 5: HOW IT WORKS INSIDE                        -->
<!-- ===================================================== -->

<!-- .slide: data-background-color="#2f2f2f" data-transition="zoom" -->

<span class="badge badge-blue" style="font-size: 0.6em;">Part 3</span>

## Inside glibc's iconv

Note:
**Do:** *"We've seen what iconv does from the outside. Now let's look under the hood."*

- **gconv** = glibc's internal conversion framework ("g" = GNU, "conv" = conversion)

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Inside glibc</p>

### The naive approach: N×N converters

Suppose I support 200 encodings. How many converters do I need?
<!-- .element: class="medium" -->

```text
Shift-JIS → UTF-8       UTF-8 → Shift-JIS
Shift-JIS → EUC-KR      EUC-KR → Shift-JIS
UTF-8 → EUC-KR          EUC-KR → UTF-8
...
```
<!-- .element: class="fragment fade-in" -->

5 encodings = 20 converters. 200 encodings?
<!-- .element: class="fragment fade-up" -->

200 × 199 = <span class="red">39,800 converters</span>. That's not going to work.
<!-- .element: class="fragment zoom-in" -->

Note:
**Do:** Ask *"How many converters do I need?"* before revealing. Let them guess.

- Formula: N × (N-1) for directed pairs
- Nobody will write 39,800 converters

---

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

<p class="slide-title">Inside glibc</p>

### The smart approach: one universal pivot

What if every encoding just learned to convert to **one common format**?
<!-- .element: class="medium" -->

```text
Shift-JIS  →  ???  →  UTF-8
```
<!-- .element: data-id="hub-text" class="fragment fade-in" -->

Note:
Hub-and-spoke architecture — same principle as airline routing through hub airports.

--

<!-- .slide: data-auto-animate data-background-color="#2f2f2f" -->

<p class="slide-title">Inside glibc</p>

### The smart approach: one universal pivot

glibc's gconv framework uses an internal **UCS-4 based representation** as the pivot.

```text
Shift-JIS  →  UCS-4  →  UTF-8
```
<!-- .element: data-id="hub-text" -->

Now you need just **2 converters per encoding** (to UCS-4 and from UCS-4).
<!-- .element: class="fragment fade-up" -->

200 encodings × 2 = <span class="green">400 converters</span> instead of 39,800.
<!-- .element: class="fragment zoom-in" -->

Note:
- **UCS-4** = Universal Coded Character Set, 4-byte form (ISO 10646). Essentially UTF-32
- glibc calls it **INTERNAL** in gconv-modules config
- 2 converters per encoding → 400 total. 99% reduction
- *Exception:* glibc says "UCS-4 *based*" — the internal representation has nuances around stateful encodings

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Inside glibc</p>

### The lookup table: `gconv-modules`

<pre><code class="language-text" data-line-numbers data-ln-start-from="47"># iconvdata/gconv-modules
#   from             to              module     cost
module  ISO-8859-1// INTERNAL        ISO8859-1   1
module  INTERNAL     ISO-8859-1//    ISO8859-1   1</code></pre>

<pre><code class="language-text" data-line-numbers data-ln-start-from="415"># iconvdata/gconv-modules-extra.conf
module  SJIS//       INTERNAL        SJIS        1
module  INTERNAL     SJIS//          SJIS        1</code></pre>

`INTERNAL` = the UCS-4 pivot
<!-- .element: class="fragment fade-up accent" -->

Each line maps an encoding to a `.so` plugin. `iconv_open` reads this file, loads the right plugins, and chains them.
<!-- .element: class="fragment fade-up small" -->

Note:
These are actual files from the glibc source tree.

- Format: `module FROM// TO MODULE_NAME COST`
- **INTERNAL** = glibc's name for UCS-4
- **Cost** = routing weight when multiple paths exist (lower = preferred)
- Each encoding has exactly 2 lines — one each direction. Hub-and-spoke in practice

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Inside glibc</p>

### The conversion pipeline

<div class="mermaid">
<pre>
flowchart TB
    A["Shift-JIS bytes"] --> B["SJIS.so\n(gconv module)"]
    B --> C["UCS-4\n(internal pivot)"]
    C --> D["UTF-8 converter\n(built-in)"]
    D --> E["UTF-8 bytes"]
    style C fill:#0f62fe,stroke:#78a9ff,color:#fff
    style B fill:#393939,stroke:#78a9ff,color:#c6c6c6
    style D fill:#393939,stroke:#78a9ff,color:#c6c6c6
    style A fill:#262626,stroke:#525252,color:#f1c21b
    style E fill:#262626,stroke:#525252,color:#42be65
</pre>
</div>

Adding a new encoding = writing **one** `.so` plugin.
<!-- .element: class="fragment fade-up small" -->

Note:
**Do:** THIS IS THE MONEY SLIDE. Spend time here. Point at each box:
1. *"Shift-JIS bytes come in"*
2. *"SJIS.so converts to UCS-4"*
3. *"UTF-8 converter turns UCS-4 into UTF-8"*
4. *"UTF-8 bytes come out"*

Adding a new encoding = one .so that converts to/from UCS-4. People will photograph this.

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Inside glibc</p>

### The iconv flow

<div class="mermaid">
<pre>
sequenceDiagram
    participant App as Your Code
    participant glibc as glibc internals
    App->>glibc: iconv_open("UTF-8", "SJIS")
    Note right of glibc: look up gconv-modules
    Note right of glibc: load SJIS.so + UTF-8
    Note right of glibc: build step chain
    glibc-->>App: return descriptor
    App->>glibc: iconv(cd, &in, ...)
    Note right of glibc: step[0]: SJIS → UCS-4
    Note right of glibc: step[1]: UCS-4 → UTF-8
    glibc-->>App: advance pointers
    App->>glibc: iconv_close(cd)
    Note right of glibc: free chain, unload modules
</pre>
</div>

Three calls. That's the entire API.
<!-- .element: class="fragment fade-up small" -->

Note:
The API in three calls:
1. **iconv_open** → returns descriptor (pointer to gconv_info struct with step chain)
2. **iconv** → walks the chain. Both in/out pointers advance. Errors: **EILSEQ** (illegal sequence), **E2BIG** (output buffer full — flush and retry, not a real error), **EINVAL** (incomplete sequence)
3. **iconv_close** → free chain, unload modules

- *Highlight:* E2BIG is the #1 mistake — people call iconv once and assume it's done

---

<!-- ===================================================== -->
<!-- SECTION 6: RELEVANCE TODAY                            -->
<!-- ===================================================== -->

<!-- .slide: data-background-color="#2f2f2f" data-transition="zoom" -->

<span class="badge badge-red" style="font-size: 0.6em;">Part 4</span>

## Does this still matter?

Note:
**Do:** *"Modern languages have Unicode strings by default. So why should anyone care about iconv in 2026?"*

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Relevance today</p>

### How modern languages handle encoding

| Language | Strings are... | Encoding conversion |
|----------|----------------|---------------------|
| **Python 3** | Unicode internally | Built-in codecs |
| **Go** | UTF-8 by definition | `golang.org/x/text` |
| **Rust** | Always valid UTF-8 | `encoding_rs` crate |
| **Java** | UTF-16 internally | `java.nio.charset` |
| **C/C++** | Just bytes — no encoding | **`iconv`** |

Modern languages solved this by making strings Unicode-native. C didn't — and can't, because it would break 50 years of code.
<!-- .element: class="fragment fade-up small" -->

Note:
- C can't change because `char = 1 byte` is baked into the language spec and **ABI** (Application Binary Interface)
- Even modern languages need encoding conversion at **I/O boundaries** — files, sockets, C library calls via **FFI** (Foreign Function Interface)
- Python's codecs, Go's x/text, Rust's encoding_rs all exist because the outside world isn't always UTF-8

---

<!-- .slide: data-background-color="#2f2f2f" data-transition="slide" -->

<p class="slide-title">Relevance today</p>

### Encoding bugs are alive and well

<div class="two-col">
<div class="card">

#### The Turkish İ problem

| Locale | `toupper('i')` |
|--------|----------------|
| en_US | I |
| tr_TR | <span class="red">İ</span> (dotted!) |

Tests pass in English, break in Turkish.

</div>
<div class="card">

#### `//IGNORE` inconsistency

```bash
$ echo 'héllo' | iconv \
  -f UTF-8 -t ASCII//IGNORE
```

Some modules skip the bad byte. Some stop with an error.
**Same flag, different behavior.**

</div>
</div>

<br />

Every time a language reads a file, parses a socket, or calls a C library — encoding conversion still happens. These bugs still bite.
<!-- .element: class="fragment fade-up accent small" -->

Note:
**Turkish İ:**
- Turkish has 4 i's: i, İ, ı, I. toupper('i') → İ (U+0130), not I
- Any case-insensitive comparison using toupper/tolower is locale-dependent

**//IGNORE:**
- Behavior depends on *which* gconv module runs — inconsistent across encodings
- This is a real unfixed glibc bug. This is what got me into the codebase

---

<!-- ===================================================== -->
<!-- SECTION 7: GLIBC WORKSHOP                             -->
<!-- ===================================================== -->

<!-- .slide: data-background-color="#2f2f2f" data-transition="fade" -->

### glibc Development Workshop — Third Edition

Led by **Arjun Shankar** (Red Hat, glibc developer)

<span class="accent medium">Tomorrow, Friday June 19 · 10:15 AM · Room A218</span>

Pick a bug, get a cheat sheet, ship a patch.

6 patches in 2024 · 15+ in 2025 · **yours in 2026?**

Note:
**Do:** Tell the personal story:
*"Two years ago I walked into this workshop at DevConf. Arjun gave me a small iconv task. I got curious, fell down the rabbit hole, and that became this talk. That one task turned into 14 patches in glibc."*

- **Arjun Shankar** = Red Hat engineer, glibc developer. Runs this workshop yearly at DevConf.CZ
- Format: show up, get a cheat sheet with a small bug + pointers, experienced contributors help you submit
- Room A218, capacity 20. First come, first served
- *"If anything in this talk made you curious, room A218 tomorrow morning."*

---

<!-- ===================================================== -->
<!-- SECTION 8+9: REFERENCES + QUESTIONS                   -->
<!-- ===================================================== -->

<!-- .slide: data-background-color="#2f2f2f" data-transition="fade" -->

### Questions? · Resources

- **Joel Spolsky** — "The Absolute Minimum Every Software Developer Must Know About Unicode" <!-- .element: class="small" -->
- **GNU C Library Manual** — "Character Set Handling" chapter <!-- .element: class="small" -->
- **unicode.org** — the specification <!-- .element: class="small" -->

<span class="badge badge-blue">avinal.space</span> · <span class="badge badge-purple">@avinal</span>

Attendance at DevConf.CZ 2026 was supported by the **[GNU Toolchain Fund](https://my.fsf.org/civicrm/contribute/transact?reset=1&id=57)**, a part of the FSF's Working Together for Free Software Fund.
<!-- .element: class="small" -->

Note:
**Do:** Leave this up during Q&A.

- Joel Spolsky's article (2003) — the classic intro, entertaining
- glibc manual — authoritative API reference (sourceware.org/glibc/manual)
- **GNU Toolchain Fund** = part of the **FSF's** (Free Software Foundation) "Working Together for Free Software" fund
