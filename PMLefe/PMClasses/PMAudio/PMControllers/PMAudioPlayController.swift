//
//  PMAudioPlayController.swift
//  PMLefe
//
//  Created by wsy on 16/7/30.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMAudioPlayController: PMBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
//        self.view.alpha = 0.3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }

}
