//
//  PMInputView.swift
//  PMLefe
//
//  Created by wsy on 16/7/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let itemWidth: CGFloat = 50
private let kTagOffset: Int = 500

class PMInputView: UIView {
    
    var inputAction:((index: Int) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
        let imageNames = ["cl_pwd", "cl_text", "cl_ok"]
        
        for index in 0...(imageNames.count - 1){
            let button = createButton()
            if index == imageNames.count - 1{
                button.frame = CGRect(x: 10 + self.width - itemWidth - 10, y: 0, width: itemWidth, height: self.height)

            }else{
                button.frame = CGRect(x: 10 + itemWidth * CGFloat(index), y: 0, width: itemWidth, height: self.height)
            }
            button.setImage(UIImage(named: imageNames[index]), forState: .Normal)
            button.tag = index + kTagOffset
            addSubview(button)
        }

    }
    
    func createButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.addTarget(self, action: #selector(PMInputView.buttonClick(_:)), forControlEvents: .TouchUpInside)
        return button
    }
    
    
    func buttonClick(button: UIButton) {
        inputAction?(index: button.tag - kTagOffset)
    }

}
