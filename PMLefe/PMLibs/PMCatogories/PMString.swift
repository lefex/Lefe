//
//  PMString.swift
//  PMLefe
//
//  Created by wsy on 16/2/28.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(path)
    }
    
    func pm_stringByDeletingPathExtension() -> String {
        return (self as NSString).stringByDeletingPathExtension
    }
    
    var pm_length: Int{
        get
        {
          return (self as NSString).length
        }
    }
    
    func heightWithFont(font: UIFont, width: CGFloat) -> CGFloat{
        return sizeWithFont(font, width: width).height
    }
    
    func sizeWithFont(font: UIFont, width: CGFloat) -> CGSize{
        let rect = (self as NSString).boundingRectWithSize(CGSize(width: width, height: 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil)
        return rect.size
    }
    
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex   = self.startIndex.advancedBy(r.endIndex)
            return self[Range(startIndex..<endIndex)]
        }
    }
}