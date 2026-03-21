## 📘 README Section: XFoundation

### Project Introduction

XFoundation is a lightweight Swift utility library for:
- binary data parsing and scanning (`BinaryDataScanner`)
- low-level data conversions and IP handling (`Data` extensions)
- cryptographic hashing (MD5/SHA families via `HMAC` and `CommonCrypto`)
- small filesystem helpers (`FileManager`)
- string utilities (substring slices, IPv6 conversion)

It is optimized for:
- minimal dependencies (`Foundation` + `CommonCrypto`)
- Swift Package Manager support (Package.swift)
- easy use in macOS/iOS projects

---

### New API: `BinaryDataScanner` enhancements

`BinaryDataScanner` now includes:

- safe generic `read<T: BinaryReadable>() -> T?`  
  - reads `T` from current position
  - bound-checks remaining data
  - supports configurable endianness (`littleEndian: Bool`)
- `skip(to n: Int)` with bounds clamping (`0 ..< data.count`)
- `advance(by n: Int)` with bounds clamping
- read helpers:
  - `readByte() -> UInt8?`
  - `read16() -> UInt16?`
  - `read32() -> UInt32?`
  - `read64() -> UInt64?`

**Usage**

```swift
let input = Data([0x01,0x00,0x02,0x00])
let scanner = BinaryDataScanner(data: input, littleEndian: true)
let first = scanner.read16() // 1
let second = scanner.read16() // 2
```

---

### New API: `Data` IP conversion and safer scanning

New `Data` extension behavior:

- `toIPString() -> String`
  - IPv4 length 4 -> dotted string
  - IPv6 length 16 -> compressed IPv6 string
- `scanValue<T>(start:length:) -> T`
  - runtime precondition checks
  - loads from bytes safely
- `dataToInt()` (by first byte) and adapters remain with explicit preconditions

---

### New API: `EncryptExtension` fixes

- `hmacsha1(keyData:)` now returns full digest (20 bytes)  
- `String`/`Data` computed hash properties:
  - `md5x`, `sha1`, `sha224`, `sha256`, `sha384`, `sha512`
  
**Usage**

```swift
let hash = "hello".sha256
let dataSha256 = Data([0x01]) .sha256
```

---

### Tests included

- `testStringDelLastN`
- `testBinaryDataScannerRead`
- `testBinaryDataScannerBoundsAdvanceSkip`
- `testHMACSHA256`
- `testSFDataAppendAndRoundTrip`
- `testDataToIPStringIPv4`
- `testDataToIPStringIPv6`

---

### Getting started

1. Add package dependency:
   - `https://github.com/your-org/XFoundation.git`
2. Import:
   - `import XFoundation`
3. Build:
   - `swift build`
4. Run tests:
   - `swift test`

---

### Quick example

```swift
import XFoundation

let data = Data([0x01,0x02,0x03,0x04])
let scanner = BinaryDataScanner(data: data, littleEndian: false)
let value: UInt16? = scanner.read16()
print(value) // 258
```