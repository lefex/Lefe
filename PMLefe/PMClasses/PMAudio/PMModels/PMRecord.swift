//
//  PMRecord.swift
//  PMLefe
//
//  Created by wsy on 16/1/26.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMRecord {

    // record total time
    var totalTime: Int
    
    // record's format
    var format: String = ".caf"
    
    var recordName: String
    
    init(recordName: String?) {
        if let name = recordName{
            self.recordName = name
        }else{
            self.recordName = NSDate().pm_currentDateStr
        }
        self.totalTime = 0
    }
}

extension PMRecord{
    var fileUrl: NSURL{
        get{
            return NSURL(fileURLWithPath: PMLocalFileManager.audioRootPath.stringByAppendingPathComponent(fileNameContainExt))
        }
    }
    
    var fileNameContainExt: String{
        get{
            return self.recordName.stringByAppendingString(self.format)
        }
    }
    
    var totalTimeStr: String{
        get{
            let hour: Int = (totalTime/3600)
            let minute: Int = (totalTime - hour*3600)/60
            let second: Int  = totalTime - hour*3600 - minute*60
            
            func getTimeStr(seconds: Int) -> String{
                if seconds == 0{
                    return  "00"
                }else if seconds < 10{
                    return  "0" + String(seconds)
                }else{
                    return  String(seconds)
                }
            }
            return  getTimeStr(hour) + ":" + getTimeStr(minute) + ":" + getTimeStr(second)

        }
    }
}
