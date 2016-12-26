//
//  PMPwdController.swift
//  PMLefe
//
//  Created by wsy on 16/6/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

enum PMPwdType: Int {
    case Setting
    case Change
    case Verify
    
    var firstAlertTitle: String{
        switch self {
        case .Setting:
            return NSLocalizedString("pa_input_pwd", comment: "")
        case .Change:
            return NSLocalizedString("pa_input_old_pwd", comment: "")
        case .Verify:
            return NSLocalizedString("pa_input_pwd", comment: "")
        }

    }
}

class PMPwdController: PMBaseController {

    // MARK: - Properties
    var finishComplete: ((pwd: String) -> ())?
    
    var pwdTitle: String = NSLocalizedString("pa_pwd", comment: "")
    internal var firstPwd: String = ""
    internal var oldPwd: String = ""
    internal var isShowRightItem: Bool = true

    
    var pwdType: PMPwdType = PMPwdType(rawValue: 0)!
    var isVerify = false

    var alertLabel: UILabel!
    var pwdView: PMPwdView!
    
    // MARK: - ViewController life
    override func viewDidLoad() {
        super.viewDidLoad()

        title = pwdTitle
        
        if isShowRightItem {
            setLeftItemImage("pm_cancel")
        }

        createUI()
    }
    
    // MARK: - Action
    override func didClickRightItem() {
        pwdView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - CreateUI
    private func createUI(){
        // ALert
        alertLabel = UILabel()
        alertLabel.textAlignment = .Center
        alertLabel.textColor = UIColor.blackColor()
        alertLabel.font = PMUIContraint.fontWithName(15)
        alertLabel.text = pwdType.firstAlertTitle
        view.addSubview(alertLabel)
        alertLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(100)
        }
        
        // Pwd
        pwdView = PMPwdView(frame: CGRect(x: 0, y: 0, width: view.width, height: 60))
        view.addSubview(pwdView)
        pwdView.finishAction = { [weak self] password in
            if self?.pwdType == PMPwdType.Setting {
                //////////////////// 设置密码
                
                if self!.firstPwd.isEmpty{
                    self?.alertLabel.text = NSLocalizedString("pa_input_again", comment: "")
                    self?.firstPwd = password
                    self?.pwdView.reset()
                    
                }else{
                    if self?.firstPwd == password{
                        self?.pwdView.resignFirstResponder()
                        self?.finishComplete?(pwd: password)
                        self?.navigationController?.popViewControllerAnimated(true)
                        self?.finishComplete?(pwd: password)
                    }
                    else{
                        self?.alertLabel.textColor = UIColor.redColor()
                        self?.alertLabel.text = NSLocalizedString("pa_two_different", comment: "")
                        PMLefe.pm_dispatchAfter(2.0, block: { [weak self] in
                            self?.alertLabel.textColor = UIColor.blackColor()
                            self?.alertLabel.text = NSLocalizedString("pa_input_pwd", comment: "")
                            
                            self?.firstPwd = ""
                            self?.pwdView.reset()
                        })

                    }
                }
            }
            else if self?.pwdType == PMPwdType.Change{
                //////////////////////////////// 修改密码
                
                // 第一次输入，判断是否于旧密码是否正确
                if !self!.isVerify {
                    if password == self?.oldPwd{
                        self!.isVerify = true
                        self?.alertLabel.textColor = UIColor.blackColor()
                        self?.pwdView.reset()
                        self?.alertLabel.text = NSLocalizedString("pa_input_new_pwd", comment: "")
                        return;
                    }else{
                        self?.alertLabel.textColor = UIColor.redColor()
                        self?.alertLabel.text = NSLocalizedString("pa_pwd_error", comment: "")
                        self?.pwdView.reset()
                    }
                }
                
                guard self!.isVerify else{
                    return
                }
                
                // 验证老密码通过，设置新密码
                
                if self!.firstPwd.isEmpty {
                    self?.alertLabel.textColor = UIColor.blackColor()
                    self?.firstPwd = password
                    self?.alertLabel.text = NSLocalizedString("pa_input_new_pwd_again", comment: "")
                    self?.pwdView.reset()
                    
                }else{
                    if self?.firstPwd == password{
                        
                        self?.pwdView.resignFirstResponder()
                        self?.finishComplete?(pwd: password)
                        self?.navigationController?.popViewControllerAnimated(true)
                        self?.finishComplete?(pwd: password)
                        
                    }else{
                        self?.pwdView.resignFirstResponder()
                        self?.alertLabel.textColor = UIColor.redColor()
                        self?.alertLabel.text = NSLocalizedString("pa_pwd_error", comment: "")
                        PMLefe.pm_dispatchAfter(2.0, block: {
                            self?.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                }

                
              
            }
            else if self?.pwdType == PMPwdType.Verify{
                ///////////////////////////////// 验证密码
                
                if password == self?.firstPwd{
                    self?.finishComplete?(pwd: password)
                    self?.pwdView.resignFirstResponder()
                    self?.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    self?.alertLabel.textColor = UIColor.redColor()
                    self?.alertLabel.text = NSLocalizedString("pa_pwd_error", comment: "")
                    self?.pwdView.reset()
                }

            }

        }
        
        pwdView.snp_makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.centerX.equalTo(view)
            make.top.equalTo(alertLabel.snp_bottom).offset(10)
        }
    }

}
