//
//  PMLocalFileServes.swift
//  PMLefe
//
//  Created by wsy on 16/3/25.
//  Copyright © 2016年 WSY. All rights reserved.
//

// 本地文件处理

import UIKit

private let PMLefeRootFilePath = "Lefe"

public class PMLocalFileServes {
    
    /// The app documents path
    static var documentPath: String{
        get{
            return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
        }
    }
    
    /// The app temp path
    static var tempPath: String{
        get{
            return NSTemporaryDirectory()
        }
    }

    // The app root local file path
    static var rootPath: String{
        get{
            return documentPath.stringByAppendingPathComponent(PMLefeRootFilePath)
        }
    }

    // Create root directory
    class func createRootPath(){
        if !NSFileManager.defaultManager().fileExistsAtPath(rootPath){
          let _ = try? NSFileManager.defaultManager().createDirectoryAtPath(rootPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // Create directory with name
    class func createLocalFilePathWithName(name: String){
        if name.isEmpty{
            return
        }
        
        let filePath = rootPath.stringByAppendingPathComponent(name)
        if !NSFileManager.defaultManager().fileExistsAtPath(filePath){
            let _ = try? NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
