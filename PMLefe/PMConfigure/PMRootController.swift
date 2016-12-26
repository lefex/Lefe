//
//  PMRootController.swift
//  PMLefe
//
//  Created by wsy on 16/6/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMRootController: PMBaseController {

    var isFirstLoading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoading {
            self._launchAnimation()
            isFirstLoading = false
        }
    }
    
    private func _jumpTabBarViewController(){
        // Main view controller
        let tabBarVC = getViewControllerFromStoryboardWithIndentifier("PMTabBarController", storyBoardType: PMUIContraint.kTabBarStoryboard)
        UIApplication.sharedApplication().delegate?.window!!.rootViewController = tabBarVC
    }
    
    private func _jumpPasswordViewController(pwd: String){
        let pwdVC = PMPwdController()
        pwdVC.firstPwd = pwd
        pwdVC.pwdType = .Verify
        pwdVC.isShowRightItem = false
        
        pwdVC.finishComplete = { pwd in
            
            pwdVC.dismissViewControllerAnimated(true, completion: nil)
            
            self._jumpTabBarViewController()
            
        }
        let nav = PMBaseNavController(rootViewController: pwdVC)
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    private func _launchAnimation(){
        
        let launchStorboard = UIStoryboard(name: "LaunchScreen", bundle: NSBundle.mainBundle())
        let viewController = launchStorboard.instantiateViewControllerWithIdentifier("LaunchScreenViewController")
        let lauchView = viewController.view
        guard let mainWindow = UIApplication.sharedApplication().keyWindow else{
            return
        }
        lauchView.frame = mainWindow.bounds
        mainWindow.addSubview(lauchView)

        UIView.animateWithDuration(0.25, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            lauchView.alpha = 0
            lauchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.8, 1.8, 1.0)
            }) { (isFinish) in
                if isFinish{
                    lauchView.removeFromSuperview()
                    self._jumpToNextViewController()
                }

        }
    }
    
    private func _jumpToNextViewController(){
        if let pwd = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
            if pwd.isEmpty{
                
                self._jumpTabBarViewController()
            }
            else
            {
                self._jumpPasswordViewController(pwd)
            }
        }
        else
        {
            self._jumpTabBarViewController()
        }

    }

}
