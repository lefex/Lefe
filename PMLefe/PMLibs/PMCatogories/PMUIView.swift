//
//  PMUIView.swift
//  PMLefe
//
//  Created by wsy on 16/3/30.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

extension UIView{
    // width
    var width: CGFloat{
        get
        {
            return frame.width
        }
        set
        {
            var tempFrame = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    // height
    var height: CGFloat{
        get
        {
            return frame.height
        }
        set
        {
            var tempFrame = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    // size
    var size: CGSize{
        get
        {
            return frame.size
        }
        set
        {
            var tempFrame = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    // X
    var x: CGFloat{
        get
        {
            return frame.origin.x
        }
        set
        {
            var tempFrame = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }

    // Y
    var y: CGFloat{
        get
        {
            return frame.origin.y
        }
        set
        {
            var tempFrame = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
//    var nearsetViewController: UIViewController{
//        let  viewController: UIViewController?
//        for (var next: UIView = self.superview; next; next = next.superview) {
//    UIResponder* nextResponder = [next nextResponder];
//    if ([nextResponder isKindOfClass:[UIViewController class]]) {
//    viewController = (UIViewController*)nextResponder;
//    break;
//    }
//    }
//    return viewController;
//    }

    
}