import XCTest
@testable import XFoundation

final class XFoundationTests: XCTestCase {
    func testStringDelLastN() {
        XCTAssertEqual("hello".delLastN(2), "hel")
        XCTAssertEqual("abc".delLastN(0), "abc")
        XCTAssertEqual("x".delLastN(1), "")
    }

    func testBinaryDataScannerRead() {
        let data = Data([0x01, 0x00, 0x02, 0x00])
        let scannerLE = BinaryDataScanner(data: data, littleEndian: true)
        XCTAssertEqual(scannerLE.read16(), 0x0001)
        XCTAssertEqual(scannerLE.read16(), 0x0002)

        let scannerBE = BinaryDataScanner(data: data, littleEndian: false)
        XCTAssertEqual(scannerBE.read16(), 0x0100)
        XCTAssertEqual(scannerBE.read16(), 0x0200)
    }

    func testHMACSHA256() {
        XCTAssertEqual("abc".sha256,
                       "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
        let d = "abc".data(using: .utf8)!
        XCTAssertEqual(d.sha256,
                       Data([0xba,0x78,0x16,0xbf,0x8f,0x01,0xcf,0xea,0x41,0x41,0x40,0xde,0x5d,0xae,0x22,0x23,0xb0,0x03,0x61,0xa3,0x96,0x17,0x7a,0x9c,0xb4,0x10,0xff,0x61,0xf2,0x00,0x15,0xad]))
    }

    func testSFDataAppendAndRoundTrip() {
        let s = SFData()
        s.append(UInt8(0xFA))
        s.append(Data([0x01, 0x02, 0x03]))
        s.append(UInt32(0x04030201))
        s.append("xyz")

        XCTAssertEqual(s.data.prefix(1), Data([0xFA]))
        XCTAssertEqual(s.data[1..<4], Data([0x01, 0x02, 0x03]))
        XCTAssertEqual(s.data[4..<8], Data([0x01, 0x02, 0x03, 0x04]))
        XCTAssertEqual(String(data: s.data.suffix(3), encoding: .utf8), "xyz")
    }

    func testDataToIPStringIPv4() {
        let data = Data([192, 168, 0, 1])
        XCTAssertEqual(data.toIPString(), "192.168.0.1")
    }

    func testDataToIPStringIPv6() {
        let data = Data([0x20,0x01,0x0d,0xb8,0x85,0xa3,0x00,0x00,0x00,0x00,0x8a,0x2e,0x03,0x70,0x73,0x34])
        XCTAssertEqual(data.toIPString(), "2001:db8:85a3::8a2e:370:7334")
    }

    func testBinaryDataScannerBoundsAdvanceSkip() {
        let data = Data([0x10, 0x20, 0x30, 0x40])
        let scanner = BinaryDataScanner(data: data, littleEndian: true)

        scanner.advance(by: 2)
        XCTAssertEqual(scanner.readByte(), 0x30)

        scanner.skip(to: 1)
        XCTAssertEqual(scanner.readByte(), 0x20)

        XCTAssertEqual(scanner.read16(), 0x4030)
        XCTAssertNil(scanner.read16()) // now no remaining bytes
    }
}
