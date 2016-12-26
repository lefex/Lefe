//
//  PMAudioFile.swift
//  PMLefe
//
//  Created by wsy on 16/1/12.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

public let audioIOqueueName = "com.lefe.pmlefe.audiofiles"

class PMAudioFile {
    
    /// init filename's suffix can not .wav, if will crash
    var fileName: String?
    private let audioIOqueue: dispatch_queue_t!
    private let fileManager: NSFileManager!
    
    
    init(fileName: String?) {
        if let fileName = fileName{
            self.fileName = fileName
        }else{
            self.fileName = nil
        }
        
        fileManager = NSFileManager.defaultManager()
        audioIOqueue = dispatch_queue_create(audioIOqueueName, DISPATCH_QUEUE_SERIAL)
        
        if !fileManager.fileExistsAtPath(PMLocalFileManager.audioRootPath){
            do{
                try  NSFileManager.defaultManager().createDirectoryAtPath(PMLocalFileManager.audioRootPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError{
                print("create record root path error: \(error.localizedDescription)")
            }
           
        }
    }
}

// MARK: - file handle

extension PMAudioFile{
    
    /// get all audio files
    
     func queryAllAudioFilesWithCompleteHander(completeHandler: ((([String], [String]))->())){
       
        dispatch_async(audioIOqueue) { () -> Void in
            var files: [String] = []
            var directories: [String] = []
            
            let audioURL = NSURL(fileURLWithPath: PMLocalFileManager.audioRootPath)
            let resourcesKeys = [NSURLIsDirectoryKey, NSURLNameKey, NSURLCreationDateKey]
            
            if let fileEnumerator = self.fileManager.enumeratorAtURL(audioURL, includingPropertiesForKeys: resourcesKeys, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, errorHandler: nil), urls = fileEnumerator.allObjects as? [NSURL]
            {
                for fileURL in urls
                {
                    do {
                        let resourceValues = try fileURL.resourceValuesForKeys(resourcesKeys)
                        // If it is a Directory. Continue to next file URL.
                        if let isDirectory = resourceValues[NSURLIsDirectoryKey]?.boolValue {
                            if isDirectory {
                                if let fileName = resourceValues[NSURLNameKey] as? String {
                                    directories.append(fileName)
                                }
                                continue
                            }
                        }
                        
                        if let fileName = resourceValues[NSURLNameKey] as? String {
                            files.append(fileName)
                        }
                    } catch _ {
                        
                    }
                }

            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completeHandler((files, directories))
            })
        }
        
    }
    
    /// create directory in audio root path
    
    func createDirectoryWithName(directoryName: String) -> Bool{
        let dircetoryPath: String = PMLocalFileManager.audioRootPath + "/\(directoryName)"

        var isDirectory: ObjCBool = false
        if self.fileManager.fileExistsAtPath(dircetoryPath, isDirectory: &isDirectory){
            return false
            
        }else{

            do{
                try self.fileManager.createDirectoryAtPath(dircetoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print("create file dircetory error: \(error.localizedDescription)")
                return false
            }
            return isDirectory.boolValue
        }
    }
    
    /// delete directory or file
    
    func deleteDirectoryOrFileWithName(fileName: String) -> Bool{
        let dircetoryPath: String = PMLocalFileManager.audioRootPath + "/\(fileName)"
        do{
            try self.fileManager.removeItemAtPath(dircetoryPath)
        }catch let error as NSError{
            print("delete file dircetory error: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
}