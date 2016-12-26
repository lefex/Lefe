//
//  PMLocalFileManager.swift
//  PMLefe
//
//  Created by wsy on 16/6/18.
//  Copyright © 2016年 WSY. All rights reserved.
//  The Lefe file system

import Foundation

private let kAlbumName = "PMAlbum"
private let kVideoName = "PMVideo"
private let kAudioName = "PMAudio"

class PMLocalFileManager {
    
    // Create lefe local directory
    class func createLefeLocalDircetory() {
        PMLocalFileServes.createLocalFilePathWithName(kAlbumName)
        PMLocalFileServes.createLocalFilePathWithName(kVideoName)
        PMLocalFileServes.createLocalFilePathWithName(kAudioName)
    }
    
    class var albumRootPath: String{
        get{
            return PMLocalFileServes.rootPath.stringByAppendingPathComponent(kAlbumName)
        }
    }
    
    class var videoRootPath: String{
        get{
            return PMLocalFileServes.rootPath.stringByAppendingPathComponent(kVideoName)
        }
    }
    
    class var audioRootPath: String{
        get{
            return PMLocalFileServes.rootPath.stringByAppendingPathComponent(kAudioName)
        }
    }
    
}