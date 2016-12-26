//
//  PMCustomerController.swift
//  PMLefe
//
//  Created by wsy on 16/8/13.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit

private let kChatTextIdentifier = "chatTextID"
private let kBottomHeight: CGFloat = 49.0

class PMCustomerController: PMBaseController {
    
    var tableView: UITableView!
    var chatView: PMChatView!
    
    var bottomContraint: Constraint!
    var textHeightContraint: Constraint!

    
//    var messages: Results<Message>!
    let realm = try! Realm()
    
    var systemMsgs: Array<MsgLayout> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        title = NSLocalizedString("cu_customer", comment: "")
        
        makeUI()
        
        loadData()
        
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        addNotification()

    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Load data
    private func loadData() {
        
        let msg = Message()
        msg.body = NSLocalizedString("cu_first_msg", comment: "")
        let msgLayout = MsgLayout(msg: msg)
        
        let bornMsg = Message()
        bornMsg.body = NSLocalizedString("cu_story_msg", comment: "")
        let bornLayout = MsgLayout(msg:bornMsg)
        
        systemMsgs.append(msgLayout)
        systemMsgs.append(bornLayout)
    }
    
    // MARK: Notification
    func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textViewTextChange), name: UITextViewTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo{
            if let endRect = userInfo["UIKeyboardBoundsUserInfoKey"]?.CGRectValue(){
                bottomContraint.updateOffset(-endRect.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHidden(notification: NSNotification) {
        bottomContraint.updateOffset(0)
        self.view.layoutIfNeeded()
    }
    
    
    func textViewTextChange() {
        let textHeight = chatView.textView.text.heightWithFont(chatView.textView.font!, width: chatView.textView.width)
        print(textHeight)
        if textHeight > kBottomHeight - 20 && textHeight < 60{
            UIView.animateWithDuration(0.25, animations: { 
                self.textHeightContraint.updateOffset(textHeight + 20)
                self.view.layoutIfNeeded()
            })

        }
    }
    

    
    // MARK: CrateUI
    private func makeUI(){
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(PMChatTextCell.self, forCellReuseIdentifier: kChatTextIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.keyboardDismissMode = .OnDrag
        view.addSubview(tableView)
        
        
        chatView = PMChatView(frame: CGRectMake(0, 0, PMUIContraint.kScreenWidth, kBottomHeight))
        view.addSubview(chatView)
        chatView.sendTextAction = { text in
            let msg = Message()
            msg.body = text
            let msgLayout = MsgLayout(msg: msg)
            self.systemMsgs.append(msgLayout)
            
            self.tableView.reloadData()
            self.chatView.textView.text = ""
            
            UIView.animateWithDuration(0.25, animations: {
                self.textHeightContraint.updateOffset(kBottomHeight)
                self.view.layoutIfNeeded()
            })
        }
        chatView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            bottomContraint = make.bottom.equalTo(0).constraint
            textHeightContraint = make.height.equalTo(kBottomHeight).constraint
        }
        
        tableView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(chatView.snp_top)
            make.top.equalTo(0)
        }
    }
}


extension PMCustomerController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let msgLayout = systemMsgs[indexPath.row]
        return msgLayout.cellHeight + kTopPadding
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension PMCustomerController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return systemMsgs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kChatTextIdentifier, forIndexPath: indexPath) as! PMChatBaseCell
        cell.configureDataWithMessage(systemMsgs[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
}

