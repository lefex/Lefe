//
//  AppDelegate.swift
//  PMLefe
//
//  Created by wsy on 16/1/2.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RealmSwift
import Appsee


@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var isShowPwd = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Configure app analysis
        Appsee.start(PMConstant.kAppseeKey)
        
        let bugOption = BugtagsOptions()
        bugOption.trackingCrashes = true
        Bugtags.startWithAppKey(PMConstant.kBugTagsKey, invocationEvent: BTGInvocationEventShake)
        
        // Configure
        UMFeedback.setAppkey(PMConstant.kUMengKey)

        
        // Configure data base
        Realm.Configuration.defaultConfiguration = LefeDB.configureDataBase()
        
        // Configure local file directory
        PMLocalFileManager.createLefeLocalDircetory()
        

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Have password
        
        if let pwd = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
            if !pwd.isEmpty{
                if isShowPwd{
                    return
                }
                
                isShowPwd = true
                self._jumpPasswordViewController(pwd)
            }
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    
    func applicationDidBecomeActive(application: UIApplication) {
       
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }

    private func _jumpPasswordViewController(pwd: String){
        let pwdVC = PMPwdController()
        pwdVC.firstPwd = pwd
        pwdVC.pwdType = .Verify
        pwdVC.isShowRightItem = false
        
        let nav = PMBaseNavController(rootViewController: pwdVC)
        pwdVC.finishComplete = { pwd in
            
            self.isShowPwd = false
            nav.view.removeFromSuperview()
            
        }
        self.window!.addSubview(nav.view)
    }

}

