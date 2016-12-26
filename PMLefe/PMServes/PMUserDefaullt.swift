//
//  PMUserDefaullt.swift
//  PMLefe
//
//  Created by wsy on 16/4/17.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation

// Font size
public let PMFontSizeKey = "PMFontSizeKey"
// Font name
public let PMFontNameKey = "PMFontNameKey"
// Start password
public let PMStartPwdKey = "PMStarkPwdKey"


class PMUserDefault {
    class func pm_setValue(value: String?, forKey key: String){
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func pm_stringValueForKey(key: String) -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(key)
    }
    
    class func pm_boolValueForKey(key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    class func pm_floatValueForKey(key: String) -> Float {
        return NSUserDefaults.standardUserDefaults().floatForKey(key)
    }

}