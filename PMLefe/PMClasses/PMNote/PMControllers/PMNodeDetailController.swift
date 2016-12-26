//
//  PMNodeDetailController.swift
//  PMLefe
//
//  Created by wsy on 16/7/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import WebKit

class PMNodeDetailController: PMBaseController {

    var subjectLabel: UILabel!
    var contentTextView: PMTextView!
    
    var note: Note?
    
    // Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNoteVC()
        
        createUI()
        
        subjectLabel.text = note!.title
        contentTextView.attributedText = note!.contetnAtt
    }
    
    
    private func configureNoteVC(){
        title = NSLocalizedString("pm_note", comment: "")
        setRightItemImage("ph_album_detail")
    }
    
    
    // MARK: -Action
    override func didClickRightItem() {
        
        let alert = UIAlertController(title: nil, message:  nil, preferredStyle: .ActionSheet)
        
        if self.note?.pwd.pm_length > 0 {
            let setAction = UIAlertAction(title: NSLocalizedString("se_close_pwd", comment: ""), style: .Destructive, handler: { (action) in
                // 设置密码
                let setPwdVC = PMPwdController()
                setPwdVC.pwdType = PMPwdType.Verify
                setPwdVC.firstPwd = self.note!.pwd
                setPwdVC.finishComplete = { password in
                    LefeDB.write({
                        self.note?.pwd = ""
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
                        self.note?.pwd = password
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
                        self.note?.pwd = pwd
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
    
    // MARK: UI
    private func createUI() {
        
        func createTextView(placeHolder: String) -> PMTextView{
            let textView  = PMTextView()
            textView.placeHolderText = placeHolder
            textView.textColor = UIColor.blackColor()
            textView.editable = false
            return textView
        }
        
        // Subject
        subjectLabel = UILabel()
        subjectLabel.numberOfLines = 1
        subjectLabel.textAlignment = .Center
        subjectLabel.font = PMUIContraint.fontWithNameSize(PMUIContraint.kFontHWFangsong, size: 24.0)
        view.addSubview(subjectLabel)
        subjectLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(10.0)
            make.trailing.equalTo(-10)
            make.top.equalTo(0)
            make.height.equalTo(44)
        }
        
        // Content
        contentTextView = createTextView("")
        contentTextView.font = PMUIContraint.fontWithNameSize(PMUIContraint.kFontHWFangsong, size: 20.0)
        contentTextView.textColor = PMUIContraint.grayColor()
        view.addSubview(contentTextView)
        contentTextView.snp_makeConstraints { (make) in
            make.leading.equalTo(subjectLabel)
            make.trailing.equalTo(subjectLabel)
            make.top.equalTo(subjectLabel.snp_bottom)
            make.bottom.equalTo(view)
        }
        
        
    }

}
