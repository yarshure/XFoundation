//
//  String.swift
//  XFoundation
//
//  Created by yarshure on 2018/1/5.
//  Copyright © 2018年 yarshure. All rights reserved.
//

import Foundation

public extension String {
    func delLastN(_ n:Int) ->String{
        
        let i = self.index(self.endIndex, offsetBy: 0 - n)
        let d = self.to(index: i)
        return d
        
    }
    func to(index:Int) ->String{
        return String(self[..<self.index(self.startIndex, offsetBy:index)])
        
    }
    func to(index:String.Index) ->String{
        return String(self[..<index])
        
    }
    func from(index:Int) ->String{
        return String(self[self.index(self.startIndex, offsetBy:index)...])
        
    }
    func from(index:String.Index) ->String{
        return String(self[index...])
        
    }
    func toIPv6Addr() -> Data?  {
        var addr = in6_addr()
        let retval = withUnsafeMutablePointer(to: &addr) {
            inet_pton(AF_INET6, self, UnsafeMutablePointer($0))
        }
        if retval < 0 {
            return nil
        }
        
        let data = NSMutableData.init(length: 16)
        let p = UnsafeMutableRawPointer.init(mutating: (data?.bytes)!)
        //let addr6 =
        //#if swift("2.2")
        //memcpy(p, &(addr.__u6_addr), 16)
        memcpy(p, &addr, 16)
        //#else
        //#endif
        //print(addr.__u6_addr)
        return data as Data?
    }
}
