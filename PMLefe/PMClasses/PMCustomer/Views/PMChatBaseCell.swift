//
//  PMChatBaseCell.swift
//  PMLefe
//
//  Created by wsy on 16/8/14.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMChatBaseCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDataWithMessage(msg: MsgLayout) {
        
    }
}
