//
//  PMPwdView.swift
//  PMLefe
//
//  Created by wsy on 16/6/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let kMaxPwd = 4
private let kItemWidth: CGFloat = 40
private let kPwdViewTagOffset = 222

class PMPwdView: UIView, UIKeyInput {

    var textStr = ""
    
    var finishAction: ((password: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        
        becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        for i in 0..<kMaxPwd{
            let button = UIButton(type: .Custom)
            button.frame = CGRect(x: (screenWidth - CGFloat(kMaxPwd) * kItemWidth ) / 2.0 + CGFloat(i)*kItemWidth, y: 0, width: kItemWidth, height: self.height)
            button.setImage(UIImage(named: "pm_pwd_line"), forState: .Normal)
            button.setImage(UIImage(named: "pm_pwd_point"), forState: .Selected)
            button.tag = i + kPwdViewTagOffset
            addSubview(button)
        }
    }
    
    func reset() {
        for _ in 0..<kMaxPwd{
           deleteBackward()
        }
    }
    
    var keyboardType: UIKeyboardType = .NumberPad
    
    // MARK: UIKeyInput
    func hasText() -> Bool {
        return true
    }
    
    func insertText(text: String) {
        if let button = viewWithTag(textStr.pm_length + kPwdViewTagOffset) as? UIButton{
            button.selected = true
        }
        
        if textStr.pm_length <= kMaxPwd{
            textStr = textStr.stringByAppendingString(text)
        }
        
        
        if textStr.pm_length == kMaxPwd{
            PMLefe.pm_dispatchAfter(0.2, block: { [weak self] in
                self?.finishAction?(password: (self?.textStr)!)
            })
        }
        
    }
    
    func deleteBackward() {
        if textStr.isEmpty {
            return
        }
        else if textStr.pm_length == 1 {
            textStr = ""
        }
        else{
            textStr = textStr[0...(textStr.pm_length - 2)]
        }
        
        if let button = viewWithTag(textStr.pm_length + kPwdViewTagOffset) as? UIButton{
            button.selected = false
        }
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

}
