//
//  PMChatTextCell.swift
//  PMLefe
//
//  Created by wsy on 16/8/14.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

class PMChatTextCell: PMChatBaseCell {
    
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var chatImageView: UIImageView!
    
    var heightContraint: Constraint!
    var widthContraint: Constraint!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createUI(){
        
        // Icon
        iconImageView = UIImageView()
        iconImageView.userInteractionEnabled = true
        contentView.addSubview(iconImageView)
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(kLeftPadding)
            make.height.equalTo(kIconWidth)
            make.width.equalTo(kIconWidth)
            make.bottom.equalTo(kChatItemPadding)
            
        }
        
        // Bubble
        chatImageView = UIImageView()
        chatImageView.userInteractionEnabled = true
        chatImageView.image = UIImage(named: "ch_bubble_left_gray")!.stretchableImageWithLeftCapWidth(10, topCapHeight: 10)
        contentView.addSubview(chatImageView)
        chatImageView.snp_makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(kChatItemPadding)
            make.top.equalTo(kTopPadding)
            widthContraint = make.width.equalTo(100).constraint
            heightContraint = make.height.equalTo(40).constraint
        }
        
        // Text
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.textColor = PMUIContraint.defaultBubbleTextColor()
        chatImageView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(2*kChatItemPadding)
            make.right.equalTo(-kChatItemPadding)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }


    override func configureDataWithMessage(msgLayout: MsgLayout) {
        super.configureDataWithMessage(msgLayout)
        
        titleLabel.text = msgLayout.msg.showText
        iconImageView.image = UIImage(named: "customer")
        
        widthContraint.updateOffset(msgLayout.cellWidth)
        heightContraint.updateOffset(msgLayout.cellHeight)
        
        layoutIfNeeded()
    }
}
