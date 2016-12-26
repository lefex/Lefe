//
//  PMLefe.swift
//  PMLefe
//
//  Created by wsy on 16/1/13.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMLefe{

    class func pm_lefeSafeMainThread(block: ()->()){
        if NSThread.isMainThread(){
            block()
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                block()
            })
        }
    }
    
    class func pm_dispatchAfter(seconds: Double, block: ()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                    Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            block()
        })
    }
}
