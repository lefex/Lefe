//
//  PMSettingController.swift
//  PMLefe
//
//  Created by wsy on 16/3/28.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let indentifier = "PMSettingCell"

enum SettingData: Int {
    case Font
    case StartPwd
    case ClosePwd
    
    static func settingWithIndexPath(indexPath: NSIndexPath) -> SettingData?{
        if indexPath.section == 0 && indexPath.row == 0 {
            return SettingData.Font
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            return SettingData.StartPwd
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            return SettingData.ClosePwd
        }
        else{
            return nil
        }
    }
    
    var title: String{
        switch self {
        case .Font:
            return NSLocalizedString("se_font", comment: "")
        case .StartPwd:
            return NSLocalizedString("se_start_pwd", comment: "")
        case .ClosePwd:
            return NSLocalizedString("se_close_pwd", comment: "")
        }
    }
    
    var detailTitle: String{
        switch self {
        case .Font:
            if let name = PMUserDefault.pm_stringValueForKey(PMFontNameKey){
                return name
            }
            return PMUIContraint.kDefaultFontName
        case .StartPwd:
            
            if let _ = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
                return NSLocalizedString("se_have_set", comment: "")
            }else{
                return NSLocalizedString("se_not_set", comment: "")

            }
        default:
            return ""
        }
    }
    
    var sectionTitle: String{
        switch self {
        case .Font:
            return NSLocalizedString("", comment: "")
        case .StartPwd:
            return NSLocalizedString("se_pwd_alert", comment: "")
        default:
            return ""
        }
        
    }
}

class PMSettingController: PMBaseController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(PMSettingCell.self, forCellReuseIdentifier: indentifier)
        tableView.tableFooterView = UIView()
        title = NSLocalizedString("se_setting", comment: "")
        
        registeNotification()
    }

    func registeNotification(){
        NSNotificationCenter.defaultCenter().addObserverForName(PMConstant.kNotificationFontChange, object: nil, queue: nil) {[weak self] (_) -> Void in
            self?.tableView.reloadData()
        }
    }
    
    func isSetupPwd() -> Bool {
        if let _ = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
            return true
        }
        return false
    }

}

extension PMSettingController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if self.isSetupPwd(){
                return 2
            }
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(indentifier)
        let settingData: SettingData = SettingData.settingWithIndexPath(indexPath)!
         cell?.textLabel?.text = settingData.title
         cell?.detailTextLabel?.text = settingData.detailTitle
         cell?.textLabel?.font = PMUIContraint.kFont
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let settingData: SettingData = SettingData.settingWithIndexPath(NSIndexPath(forItem: 0, inSection: section))!
//
//        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: settingData.sectionHeight)
//        let label = UILabel()
//        label.font = UIFont.systemFontOfSize(12)
//        label.frame = CGRect(x: 10, y: 0, width: self.view.width - 20, height: settingData.sectionHeight)
//        label.numberOfLines = 0
//        label.text = settingData.sectionTitle
//        label.textColor = UIColor.lightGrayColor()
//        view.addSubview(label)
//        
//        return view
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let settingData: SettingData = SettingData.settingWithIndexPath(indexPath)!

        // 设置字体
        if settingData == .Font {
            let fontNameVC = self.getViewControllerFromStoryboardWithIndentifier("PMFontNameSettingController", storyBoardType: PMUIContraint.kSettingStoryboard)
            navigationController?.pushViewController(fontNameVC, animated: true)
        }
        // 开启密码
        else if settingData == .StartPwd{
            if let pwd = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
                
                let setPwdVC = PMPwdController()
                setPwdVC.pwdType = PMPwdType.Change
                setPwdVC.firstPwd = pwd
                setPwdVC.finishComplete = { password in
                    PMUserDefault.pm_setValue(password, forKey: PMStartPwdKey)
                    
                    self.tableView.reloadData()
                    setPwdVC.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                let nav = PMBaseNavController(rootViewController: setPwdVC)
                self.presentViewController(nav, animated: true, completion: nil)
                
            }else{
                
                let alert = UIAlertController(title: NSLocalizedString("se_set_start_pwd", comment: ""), message:  NSLocalizedString("se_pwd_alert", comment: ""), preferredStyle: .Alert)
                
                let setAction = UIAlertAction(title: NSLocalizedString("se_setting", comment: ""), style: .Destructive, handler: { (action) in
                    
                    let setPwdVC = PMPwdController()
                    setPwdVC.pwdType = PMPwdType.Setting
                    setPwdVC.finishComplete = { password in
                        PMUserDefault.pm_setValue(password, forKey: PMStartPwdKey)
                        
                        self.tableView.reloadData()
                        setPwdVC.dismissViewControllerAnimated(true, completion: nil)
                    }
                    let nav = PMBaseNavController(rootViewController: setPwdVC)
                    self.presentViewController(nav, animated: true, completion: nil)
                })
                alert.addAction(setAction)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: .Cancel, handler: { (action) in
                    
                })
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        // 关闭密码
        else if settingData == .ClosePwd{
            if let pwd = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
                
                let setPwdVC = PMPwdController()
                setPwdVC.pwdType = PMPwdType.Verify
                setPwdVC.firstPwd = pwd
                setPwdVC.finishComplete = { password in
                    PMUserDefault.pm_setValue(nil, forKey: PMStartPwdKey)
                    self.tableView.reloadData()
                    
                    setPwdVC.dismissViewControllerAnimated(true, completion: nil)
                }
                let nav = PMBaseNavController(rootViewController: setPwdVC)
                self.presentViewController(nav, animated: true, completion: nil)
                
            }
        }
        
    }
}


class PMSettingCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        self.accessoryType = .DisclosureIndicator

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
