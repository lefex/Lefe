//
//  PMAddNoteController.swift
//  PMLefe
//
//  Created by wsy on 16/6/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class PMAddNoteController: PMBaseController {
    
    var subjectTextView: PMTextView!
    var contentTextView: PMTextView!
    
    var bottomContraint: Constraint!
    
    var timer: NSTimer?
    var note: Note?
    let realm = try! Realm()
    

    // Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNoteVC()
        
        createUI()
        
        addNotification()
    }
    
    deinit{
        if let aTimer = timer{
            aTimer.invalidate()
            timer = nil
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func configureNoteVC(){
        title = NSLocalizedString("no_add_note", comment: "")
        setLeftItemImage("pm_cancel")
        setRightItemImage("pm_ok")
    }
    
    // MARK: -  Notification
    func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PMAddNoteController.textViewTextChange), name: UITextViewTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo{
            if let endRect = userInfo["UIKeyboardBoundsUserInfoKey"]?.CGRectValue(){
                
                bottomContraint.updateOffset(-endRect.height)
                contentTextView.layoutIfNeeded()
            }
        }
    }

    
    func textViewTextChange() {
        startTimer()
    }
    
    // MARK: -Action
    override func didClickLeftItem() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didClickRightItem() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func timerAction() {
            
        LefeDB.write({ [weak self] in
            if let _ = self?.note{
                
            }else{
                self?.note = Note()
                self?.realm.add((self?.note)!)
            }
            
            
            if let title = self?.subjectTextView.text{
                self?.note?.title = title
            }
            
            if let content = self?.contentTextView.text{
                self?.note?.content = content
            }
            
            })
    }
    
    // MARK: -Helper
    private func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(PMAddNoteController.timerAction), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    // MARK: UI
    private func createUI() {
        
        func createTextView(placeHolder: String) -> PMTextView{
            let textView  = PMTextView()
            textView.placeHolderText = placeHolder
            textView.textColor = UIColor.blackColor()
            return textView
        }
        
        // Subject
        subjectTextView = createTextView(NSLocalizedString("no_input_subject", comment: ""))
        subjectTextView.font = UIFont.systemFontOfSize(20)
        subjectTextView.becomeFirstResponder()
        view.addSubview(subjectTextView)
        subjectTextView.snp_makeConstraints { (make) in
            make.leading.equalTo(10.0)
            make.trailing.equalTo(-10)
            make.top.equalTo(0)
            make.height.equalTo(46)
        }
        
        // Line
        let lineImageView = UIImageView()
        lineImageView.image = UIImage(named: "no_line")
        view.addSubview(lineImageView)
        lineImageView.snp_makeConstraints { (make) in
            make.leading.equalTo(subjectTextView)
            make.height.equalTo(0.5)
            make.trailing.equalTo(subjectTextView)
            make.top.equalTo(subjectTextView.snp_bottom)
        }
        
        // Content
        contentTextView = createTextView(NSLocalizedString("no_input_content", comment: ""))
        contentTextView.font = UIFont.systemFontOfSize(18)
        view.addSubview(contentTextView)
        contentTextView.snp_makeConstraints { (make) in
            make.leading.equalTo(subjectTextView)
            make.trailing.equalTo(subjectTextView)
            make.top.equalTo(lineImageView.snp_bottom)
            self.bottomContraint = make.bottom.equalTo(0).constraint
        }
        

    }
}

