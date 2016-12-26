//
//  PMCollectionDetailController.swift
//  PMLefe
//
//  Created by wsy on 16/7/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

class PMCollectionDetailController: PMBaseController {

    var collection: Collection?
    var topConstraint: Constraint? = nil
    
    var pwdView: CLPwdView = {
        let view = CLPwdView(frame: CGRect.zero)
        return view
    }()
    
    var textView: PMTextView = {
        let view  = PMTextView()
        view.font = PMUIContraint.fontWithNameSize(PMUIContraint.kFontHWFangsong, size: 20.0)
        view.textColor = PMUIContraint.defaultNoteTextColor()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionVC()
        regiseterNotification()


        if let aCollection = collection {
            if aCollection.type == CLCollectionType.Password.rawValue{
                view.addSubview(pwdView)
                pwdView.snp_makeConstraints(closure: { (make) in
                    make.leading.equalTo(10)
                    make.trailing.equalTo(10)
                    make.top.equalTo(20)
                    make.height.equalTo(150)
                })
                pwdView.pwdTextField.text = aCollection.pwd
                pwdView.accountTextField.text = aCollection.account
                pwdView.titleTextField.text = aCollection.title
            }
            else if aCollection.type == CLCollectionType.Text.rawValue{
                view.addSubview(textView)
                textView.snp_makeConstraints(closure: { [weak self] (make) in
                    make.top.equalTo(0)
                    make.trailing.equalTo(0)
                    make.leading.equalTo(0)
                    self?.topConstraint = make.bottom.equalTo(0).constraint
                })
                textView.attributedText = aCollection.contetnAtt
            }
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        LefeDB.write { [weak self] in
            
            guard let wself = self else{
                return
            }
            
            if let aCollection = wself.collection {
                if aCollection.type == CLCollectionType.Password.rawValue{
                    aCollection.pwd = wself.pwdView.pwdTextField.text ?? ""
                    aCollection.account = wself.pwdView.accountTextField.text ?? ""
                    aCollection.title = wself.pwdView.titleTextField.text ?? ""
                }
                else if aCollection.type == CLCollectionType.Text.rawValue{
                    aCollection.content = wself.textView.attributedText.string
                }
            }
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func configureCollectionVC(){
        title = NSLocalizedString("pm_password", comment: "")
        setRightItemImage("ph_album_detail")
    }
    
    
    // MARK: -Action
    override func didClickRightItem() {
        
        let alert = UIAlertController(title: nil, message:  nil, preferredStyle: .ActionSheet)
        
        if self.collection?.startPwd.pm_length > 0 {
            let setAction = UIAlertAction(title: NSLocalizedString("se_close_pwd", comment: ""), style: .Destructive, handler: { (action) in
                // 设置密码
                let setPwdVC = PMPwdController()
                setPwdVC.pwdType = PMPwdType.Verify
                setPwdVC.firstPwd = self.collection!.startPwd
                setPwdVC.finishComplete = { password in
                    LefeDB.write({
                        self.collection?.startPwd = ""
                    })
                    
                    setPwdVC.dismissViewControllerAnimated(true, completion: nil)
                }
                let nav = PMBaseNavController(rootViewController: setPwdVC)
                self.presentViewController(nav, animated: true, completion: nil)
                
            })
            alert.addAction(setAction)
        }
        else
        {
            let setAction = UIAlertAction(title: NSLocalizedString("ph_setPwd", comment: ""), style: .Destructive, handler: { (action) in
                // 设置密码
                let setPwdVC = PMPwdController()
                setPwdVC.pwdType = PMPwdType.Setting
                setPwdVC.finishComplete = { password in
                    LefeDB.write({
                        self.collection?.startPwd = password
                    })
                    
                    setPwdVC.dismissViewControllerAnimated(true, completion: nil)
                }
                let nav = PMBaseNavController(rootViewController: setPwdVC)
                self.presentViewController(nav, animated: true, completion: nil)
                
            })
            alert.addAction(setAction)
            
            if let pwd = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
                // 使用启动密码
                let setAction = UIAlertAction(title: NSLocalizedString("no_use_start_pwd", comment: ""), style: .Destructive, handler: { (action) in
                    
                    LefeDB.write({
                        self.collection?.startPwd = pwd
                    })
                })
                alert.addAction(setAction)
            }
        }
        
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: .Cancel, handler: { (action) in
            
        })
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    // MARK: -Notification
    func regiseterNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo{
            if let endRect = userInfo["UIKeyboardBoundsUserInfoKey"]?.CGRectValue(){
                
                if let aCollection = collection{
                    if aCollection.type == CLCollectionType.Text.rawValue{
                        self.topConstraint?.updateOffset(-endRect.height)
                        self.textView.layoutIfNeeded()
                    }
                }
                
            }
        }
    }



}
