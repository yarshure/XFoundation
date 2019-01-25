//
//  File.swift
//  XFoundation
//
//  Created by yarshure on 2018/1/5.
//  Copyright © 2018年 yarshure. All rights reserved.
//

import Foundation

public extension FileManager {
    static func checkAndCreate(pathDir:String) throws ->Bool  {
        let m = self.default
        if !m.fileExists(atPath: pathDir) {
           try m.createDirectory(atPath: pathDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        
        return true
    }
}
