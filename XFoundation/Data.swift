//
//  Data.swift
//  XFoundation
//
//  Created by yarshure on 2018/1/5.
//  Copyright © 2018年 yarshure. All rights reserved.
//

import Foundation
extension UInt8:ValueType {}
extension Int8:ValueType {}
extension UInt16:ValueType {}
extension Int16:ValueType {}
extension UInt32:ValueType {}
extension Int32:ValueType {}
enum DataLengthError: Error {
    case outofLength
    
}
extension Data{
    func valueForIndex<T:ValueType>(index:Int,type:T.Type) throws -> T {
        //        let size = type.size
        //let alignment = MemoryLayout<T>.alignment
        
        let stride =  MemoryLayout<T>.stride
        if self.count < index+stride {
            throw DataLengthError.outofLength
        }
        let subData = self.subdata(in: index..<(index+stride))
        var ptr :UnsafePointer<T>?
        
        subData.withUnsafeBytes { (p:UnsafePointer<T>) -> Void in
            ptr = p
        }
        return ptr!.pointee
    }
    static func testMemory(){
        let x:[UInt8] = [0xFF,0xFF,0x03,0x04]
        let data = Data.init(bytes: x)
        
        print("value \(try! data.valueForIndex(index: 0, type: UInt8.self))")
        print("value \(try! data.valueForIndex(index: 3, type: Int8.self))")
        print("value \(try! data.valueForIndex(index: 0, type: Int16.self))")
        print("value \(try! data.valueForIndex(index: 0, type: UInt16.self))")
        print("value \(try! data.valueForIndex(index: 0, type: UInt32.self))")
        print("value \(try! data.valueForIndex(index: 0, type: Int32.self))")
    }
    public func withUnsafeRawPointer<ResultType>(_ body: (UnsafeRawPointer) throws -> ResultType) rethrows -> ResultType {
        return try self.withUnsafeBytes { (ptr: UnsafePointer<Int8>) -> ResultType in
            let rawPtr = UnsafeRawPointer(ptr)
            return try body(rawPtr)
        }
    }
    public func scanValue<T>(start: Int, length: Int) -> T {
        //start+length > Data.last is security?
        return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }
    public var length:Int{
        get {
            return self.count
        }
    }
    //from start
    public func dataToInt() ->Int32 {
        //var a:Int32 = 0
        let x:Int32  = self.scanValue(start: 0, length: 1)
        //data.getBytes(&a, range: Range(0 ..< 1))
        return x
    }
    public func data2Int(len:Int) ->Int32 {
        //var a:Int32 = 0
        var l = 0
        if len > 4 {
            l = 4
        } else {
            l = len
        }
        let x:Int32  = self.scanValue(start: 0, length: l)
        
        return x
    }
    public func dataToInt(s:Int,len:Int) ->UInt16 {
        //var a:Int32 = 0
       
        let x:UInt16  = self.scanValue(start: s, length: len)
        
        return x
    }
    public func toIPString() -> String {
        //93ms
        if self.count == 4 {
            let length = Int(INET_ADDRSTRLEN)
            var buffer = [CChar](repeating: 0, count: length)
            var p: UnsafePointer<Int8>! = nil
            self.withUnsafeBytes({ (ptr: UnsafePointer<in_addr>)  in
                p = inet_ntop(AF_INET, ptr, &buffer, UInt32(INET_ADDRSTRLEN))
                
            })
            return String(cString:p)
            
            
        }else {
            let length = Int(INET6_ADDRSTRLEN)
            var buffer = [CChar](repeating: 0, count: length)
            var p: UnsafePointer<Int8>! = nil
            
            
            
            self.withUnsafeBytes({ (ptr: UnsafePointer<in_addr>)  in
                p = inet_ntop(AF_INET, ptr, &buffer, UInt32(INET_ADDRSTRLEN))
                
            })
            return String(cString:p)
            
        }
        
    }
    //public func int32toIP(data: NSData) -> String {
    //    var ip:String = ""
    //    //var p = data.bytes
    //
    //    var a:UInt8 = 0
    //    data.getBytes(&a, range: NSRange.init(location: 0, length: 1))
    //    var  b:UInt8 = 0
    //    data.getBytes(&b,range: NSRange.init(location: 1, length: 1))
    //
    //    var c:UInt8 = 0
    //    data.getBytes(&c, range:NSRange.init(location: 2, length: 1))
    //    var  d:UInt8 = 0
    //    data.getBytes(&d, range:NSRange.init(location: 3, length: 1))
    //    ip = "\(a).\(b).\(c).\(d)"
    //    return ip
    //}
}
