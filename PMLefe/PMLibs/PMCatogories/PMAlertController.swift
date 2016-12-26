//
//  PMAlertController.swift
//  PMLefe
//
//  Created by wsy on 16/1/22.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import UIKit

public enum PMAlertType{
    case None
    case Input
    case Alert
}

extension UIAlertController{
    class func showAlertController(showType type: PMAlertType, title: String?, message: String?, completeHandler: (inputText: String?)->()) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (cancelAction: UIAlertAction) -> Void in
            
        }
        alertController.addAction(cancelAction)
        
        var inputTextField: UITextField?
        
        let okAction = UIAlertAction(title: "确定", style: .Destructive) { (okAction: UIAlertAction) -> Void in
            completeHandler(inputText: inputTextField?.text)
        }
        alertController.addAction(okAction)
        
        if type == PMAlertType.Input{
            alertController.addTextFieldWithConfigurationHandler({ (textFiled: UITextField) -> Void in
                textFiled.placeholder = "请输入..."
                textFiled.clearButtonMode = UITextFieldViewMode.WhileEditing
                inputTextField = textFiled
            })
        }
        return alertController
    }
    
   class func pm_showWithMessage(message: String, completion: ((NSInteger)->(Void))) -> UIAlertController {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: {(_) -> Void in
            completion(0)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("pm_ok", comment: ""), style: UIAlertActionStyle.Destructive, handler: {(_) -> Void in
            completion(1)
        }))
        return alert
    }

}