//
//  BinaryDataScanner.swift
//  Murphy
//
//  Created by Dave Peck on 7/20/14.
//  Copyright (c) 2014 Dave Peck. All rights reserved.
//

import Foundation

/*
 Toying with tools to help read binary formats.
 
 I've seen lots of approaches in swift that create
 an intermediate object per-read (usually another NSData)
 but even if these are lightweight under the hood,
 it seems like overkill. Plus this taught me about <()> aka <Void>
 
 And it would be nice to have an extension to
 NSFileHandle too that does much the same.
 */

public protocol BinaryReadable {
    var littleEndian: Self { get }
    var bigEndian: Self { get }
}

extension UInt8: BinaryReadable {
    public var littleEndian: UInt8 { return self }
    public var bigEndian: UInt8 { return self }
}

extension UInt16: BinaryReadable {}

extension UInt32: BinaryReadable {}

extension UInt64: BinaryReadable {}

open class BinaryDataScanner {
    let data: Data
    let littleEndian: Bool
    //    let encoding: NSStringEncoding
    
    var remaining: Int {
        get {
            return data.count - position
        }
    }
    
    public var position: Int = 0
    
    public init(data: Data, littleEndian: Bool) {
        self.data = data
        self.littleEndian = littleEndian
    }
    
    open func read<T: BinaryReadable>() -> T? {
        let size = MemoryLayout<T>.size
        guard remaining >= size else { return nil }

        let value: T = data.subdata(in: position ..< position + size).withUnsafeBytes { buffer in
            buffer.load(as: T.self)
        }

        position += size
        return littleEndian ? value.littleEndian : value.bigEndian
    }

    // swiftlint:disable variable_name
    open func skip(to n: Int) {
        guard n >= 0 else { return }
        position = min(n, data.count)
    }

    open func advance(by n: Int) {
        guard n >= 0 else { return }
        position = min(position + n, data.count)
    }
    
    /* convenience read funcs */
    
    open func readByte() -> UInt8? {
        return read()
    }
    
    open func read16() -> UInt16? {
        return read()
    }
    
    open func read32() -> UInt32? {
        return read()
    }
    
    open func read64() -> UInt64? {
        return read()
    }
}
