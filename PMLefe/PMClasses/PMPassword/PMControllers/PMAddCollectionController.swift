//
//  PMAddPwdController.swift
//  PMLefe
//
//  Created by wsy on 16/6/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RealmSwift

private let kPwdHeight: CGFloat = 150

enum CLCollectionType: Int {
    case Password
    case Text
    case TelePhone
    case Msg
}

class PMAddCollectionController: PMBaseController {
    
    let realm = try! Realm()

    var currentType = CLCollectionType.Password
    
    var topView: PMInputView = {
        let view = PMInputView(frame: CGRect(x: 0, y: 0, width: PMUIContraint.kScreenWidth, height: 50))
        return view
    }()
    
    var pwdView: CLPwdView = {
       let view = CLPwdView(frame: CGRect.zero)
        return view
    }()
    
    var textView: PMTextView = {
        let view  = PMTextView()
        view.placeHolderText = NSLocalizedString("cl_input_text", comment: "")
        view.font = PMUIContraint.kFont
        view.textColor = UIColor.blackColor()
        return view
    }()
    
    
    // Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PMUIContraint.defaultTableColor()
        title = NSLocalizedString("cl_add_collection", comment: "")
        setLeftItemImage("pm_cancel")
        
        createUI()
        
        regiseterNotification()
        
        topView.inputAction = { [weak self] index in
            
            guard let wSelf = self else{
                return
            }
            
            if index == 2 {
                // OK
                // Save to db
                // 1.Save password
                if wSelf.pwdView.isAllValid{
                    LefeDB.write({ [weak self] in
                        guard let wSelf = self else{
                            return
                        }
                        
                        let aCollection = Collection()
                        aCollection.type = CLCollectionType.Password.rawValue
                        aCollection.title = wSelf.pwdView.titleTextField.text ?? ""
                        aCollection.account = wSelf.pwdView.accountTextField.text ?? ""
                        aCollection.pwd = wSelf.pwdView.pwdTextField.text ?? ""

                        wSelf.realm.add(aCollection)
                        
                    })
                }
                
                // 2.Save text
                if let text = wSelf.textView.text{
                    guard text.pm_length > 0 else{
                        wSelf.view.endEditing(true)
                        wSelf.dismissViewControllerAnimated(true, completion: nil)
                        return
                    }
                    
                    LefeDB.write({ [weak self] in
                        guard let wSelf = self else{
                            return
                        }
                        
                        let aCollection = Collection()
                        aCollection.type = CLCollectionType.Text.rawValue
                        aCollection.content = text
                        
                        wSelf.realm.add(aCollection)
                        
                        })
                }
                
                wSelf.view.endEditing(true)
                wSelf.dismissViewControllerAnimated(true, completion: nil)
            }
            else if index == 0{
                // Pwd
                guard self?.currentType != .Password else{
                    return
                }
                
                if !wSelf.pwdView.titleTextField.isFirstResponder(){
                    wSelf.pwdView.titleTextField.becomeFirstResponder()
                }
                wSelf.textView.hidden = true
                wSelf.pwdView.hidden = false
                wSelf.view.bringSubviewToFront((self?.pwdView)!)
                
                
            }
            else if index == 1{
                // Text
                guard self?.currentType != .Text else{
                    return
                }
                
                if !wSelf.textView.isFirstResponder(){
                    wSelf.textView.becomeFirstResponder()
                }
                wSelf.pwdView.hidden = true
                wSelf.textView.hidden = false
                wSelf.view.bringSubviewToFront((self?.textView)!)

            }
            
            if index != 2 {
                wSelf.currentType = CLCollectionType(rawValue: index)!
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pwdView.titleTextField.becomeFirstResponder()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: -Action
    override func didClickLeftItem() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: -Notification
    func regiseterNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo{
            if let endRect = userInfo["UIKeyboardBoundsUserInfoKey"]?.CGRectValue(){
                
                let topHeight = view.height - endRect.height
                // Text
                if currentType == .Text {
                    
                    textView.height = topHeight - 80
                }
                // Pwd
                else if currentType == .Password{
                    if topHeight > kPwdHeight + 20 {
                        pwdView.frame = CGRect(x: 10, y: (topHeight - kPwdHeight)/2.0, width: view.width - 20, height: kPwdHeight)
                    }else{
                        pwdView.frame = CGRect(x: 10, y: 20.0, width: view.width - 20, height: topHeight)
                    }
                }
            }
        }
    }
    
    // MARK: UI
    func createUI() {
        
        // Text
        textView.inputAccessoryView = topView
        textView.frame = CGRect(x: 10, y: 40, width: PMUIContraint.kScreenWidth - 20, height: 260)
        textView.hidden = true
        view.addSubview(textView)
        
        // Pwd
        pwdView.titleTextField.inputAccessoryView = topView
        pwdView.accountTextField.inputAccessoryView = topView
        pwdView.pwdTextField.inputAccessoryView = topView
        pwdView.frame = CGRect(x: 10, y: 40, width: PMUIContraint.kScreenWidth - 20, height: kPwdHeight)
        pwdView.hidden = false
        view.addSubview(pwdView)
        
    }
    
    
}
