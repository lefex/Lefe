//
//  PMTime.swift
//  PMLefe
//
//  Created by wsy on 16/1/16.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import Foundation

extension NSDate{
    
    private var components: NSDateComponents {
        return calendar.components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: self)
    }
    
    private var calendar: NSCalendar {
        return NSCalendar.currentCalendar()
    }
    
    
    // MARK: - Get components
    
    var year: Int {
        return components.year
    }
    
    var month: Int {
        return components.month
    }
    
    var weekday: Int {
        return components.weekday
    }
    
    var day: Int {
        return components.day
    }
    
    var hour: Int {
        return components.hour
    }
    
    var minute: Int {
        return components.minute
    }
    
    var second: Int {
        return components.second
    }
    
    var isCurrentYear: Bool{
        return year == NSDate().year
    }
    
    var isToday: Bool{
        return day == NSDate().day
    }
    
    var pm_timeStamp: String{
        get{
            return "\(timeIntervalSince1970*1000)"
        }
    }
    
    var pm_currentDateStr: String{
        get{
            return NSDateFormatter.localizedStringFromDate(self, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        }
    }
    
    var pm_YMD: String{
        get{
            return pm_timeWithFormater("YYYY-MM-dd")
        }
    }
    
    var pm_MD_HMS: String{
        get{
            return pm_timeWithFormater("MM-dd HH:mm:ss")
        }
    }
    
    var pm_YMD_HMS: String{
        get{
            return pm_timeWithFormater("YYYY-MM-dd HH:mm:ss")
        }
    }
    
    
    func pm_timeWithFormater(formater: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formater
        return dateFormatter.stringFromDate(self)
    }
    
    var pm_showTime: String{
        get{
            let dateFormatter = NSDateFormatter()
            if isCurrentYear {
                if isToday {
                    dateFormatter.dateFormat = "HH:mm"
                }else{
                    dateFormatter.dateFormat = "MM-dd"
                }
            }else{
                dateFormatter.dateFormat = "YY-MM-dd"
            }
            return dateFormatter.stringFromDate(self)
        }
    }
}
