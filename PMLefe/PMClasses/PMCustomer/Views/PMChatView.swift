//
//  PMChatView.swift
//  PMLefe
//
//  Created by wsy on 16/8/14.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

private let kMaxHeight: CGFloat = 80.0

class PMChatView: UIView , UITextViewDelegate{

    var textView: UITextView!
    var heightContraint: Constraint!
    
    var sendTextAction: ((text: String)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = PMUIContraint.defaultBubbleGrayColor()
        self.crateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func crateUI() {
        textView = UITextView()
        textView.font = UIFont.systemFontOfSize(15)
        textView.textColor = PMUIContraint.defaultBubbleTextColor()
        textView.returnKeyType = .Send
        textView.enablesReturnKeyAutomatically = true
        textView.autocapitalizationType = .None
        textView.delegate = self
        
        addSubview(textView)
        textView.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(10)

        }
        
    }
    
    // MARK: UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.sendTextAction?(text: textView.text)
            return false
        }
        
        return true
    }
    

}
