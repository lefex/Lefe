//
//  CLPwdView.swift
//  PMLefe
//
//  Created by wsy on 16/7/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let kEdge: CGFloat = 20
private let kPadding: CGFloat = 1
private let kHeight: CGFloat = 44

class CLPwdView: UIImageView {
    
    var titleTextField: UITextField!
    var accountTextField: UITextField!
    var pwdTextField: UITextField!
    var topLineImageVIew: UIImageView!
    var bottomLineImageVIew: UIImageView!
    
    var isAllValid: Bool{
        get{
            if titleTextField.text?.pm_length > 0 && accountTextField.text?.pm_length > 0 && pwdTextField.text?.pm_length > 0{
                return true
            }
            else{
                return false
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        self.image = UIImage(named: "cl_pwd_bg")
        self.userInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        titleTextField = createTextField(NSLocalizedString("no_input_subject", comment: ""))
        addSubview(titleTextField)
        
        accountTextField = createTextField(NSLocalizedString("cl_input_account", comment: ""))
        accountTextField.keyboardType = UIKeyboardType.Alphabet
        addSubview(accountTextField)
        
        pwdTextField = createTextField(NSLocalizedString("cl_input_password", comment: ""))
        pwdTextField.keyboardType = .ASCIICapable
        addSubview(pwdTextField)
        
        topLineImageVIew = createLine()
        addSubview(topLineImageVIew)
        
        bottomLineImageVIew = createLine()
        addSubview(bottomLineImageVIew)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleTextField.frame = CGRect(x: kEdge, y: 6, width: self.width - 2*kEdge, height: kHeight)
        topLineImageVIew.frame = CGRect(x: kEdge + kPadding, y: titleTextField.frame.maxY, width: self.width - 2*kEdge - 2*kPadding, height: 0.5)
        accountTextField.frame = CGRect(x: kEdge, y: topLineImageVIew.frame.maxY + kPadding, width: self.width - 2*kEdge, height: kHeight)
        bottomLineImageVIew.frame = CGRect(x: kEdge + kPadding, y: accountTextField.frame.maxY, width: self.width - 2*kEdge - 2*kPadding, height: 0.5)

        pwdTextField.frame = CGRect(x: kEdge, y: bottomLineImageVIew.frame.maxY + 2*kPadding, width: self.width - 2*kEdge, height: kHeight)
    }
    
    func createTextField(placeHolder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.font = UIFont.systemFontOfSize(16.0)
        textField.clearButtonMode = .WhileEditing
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        return textField
    }
    
    func createLine() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "cl_line")
        return view
    }
    

}
