//
//  PMBaseController.swift
//  PMLefe
//
//  Created by wsy on 16/1/2.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMBaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewController init \(self.dynamicType)");

        self.view.backgroundColor = UIColor.whiteColor()

    }
    
    // Right navigation item
    func setRightItemImage(imageName: String) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal), landscapeImagePhone: nil, style: .Plain, target: self, action: #selector(PMBaseController.didClickRightItem))
    }
    
    func setRightItemTitle(title: String) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(PMBaseController.didClickRightItem))
    }
    
    // Left navigation item
    func setLeftItemImage(imageName: String) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal), landscapeImagePhone: nil, style: .Plain, target: self, action: #selector(PMBaseController.didClickLeftItem))
    }
    
    func setLeftItemTitle(title: String) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(PMBaseController.didClickLeftItem))
    }
    
    // Action
    func didClickRightItem() {
        
    }
    
    func didClickLeftItem() {
        
    }
    
    // Get viewController from storyboard
    func getViewControllerFromStoryboardWithIndentifier(indentifier: String, storyBoardType: String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyBoardType, bundle: NSBundle.mainBundle())
        let viewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier(indentifier)
        return viewController
    }
    
    deinit{
        print("viewController deinit \(self.dynamicType)");
    }

}
