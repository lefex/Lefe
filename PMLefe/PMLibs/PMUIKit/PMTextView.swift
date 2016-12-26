//
//  PMTextView.swift
//  PlayerDemo2
//
//  Created by WangSuyan on 16/7/5.
//  Copyright © 2016年 WangSuyan. All rights reserved.
//
/*
 When you set PMTextView font, palceHolder

 */

import UIKit

class PMTextView: UITextView {

    /**
     Hello
     */
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.numberOfLines = 0
        return label
    }()

    /// 设置文本框的 **placeHolder**
    var placeHolderText: String = ""{
        didSet{
            placeHolderLabel.text = placeHolderText
        }
    }
    
    override var font: UIFont?{
        didSet{
            placeHolderLabel.font = font
        }
    }
    
    func commonInit() {
        addSubview(placeHolderLabel)
        placeHolderLabel.font = self.font
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PMTextView.textChangeAction), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    func textChangeAction() {
        if self.text.characters.count == 0 {
            placeHolderLabel.hidden = false
        }else{
            placeHolderLabel.hidden = true
        }
    }
    
    init(){
        super.init(frame: CGRectZero, textContainer: nil)
        self.commonInit()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        self.commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeHolderLabel.sizeToFit()
        let padding: CGFloat = 6
        placeHolderLabel.frame = CGRectMake(padding, padding, self.frame.width - padding, placeHolderLabel.frame.height + 10 - padding)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
