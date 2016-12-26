//
//  PMBaseNavController.swift
//  PMLefe
//
//  Created by wsy on 16/1/2.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMBaseNavController: UINavigationController {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func _setupNavigation(){
        self.navigationBar.translucent = false
        //        self.navigationBar.setBackgroundImage(UIImage(named: "home_nav")?.imageWithRenderingMode(.AlwaysOriginal), forBarMetrics: .Default)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
        self.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupNavigation()


        // Do any additional setup after loading the view.
    }
}
