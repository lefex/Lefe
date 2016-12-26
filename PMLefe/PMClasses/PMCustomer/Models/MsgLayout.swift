//
//  MsgLayout.swift
//  PMLefe
//
//  Created by wsy on 16/8/14.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation

public let kChatItemPadding: CGFloat = 5.0
public let kIconWidth: CGFloat = 34.0
//
public let kLeftPadding: CGFloat = 12.0
// Cell顶部的空隙
public let kTopPadding: CGFloat = 12.0


private let kRightPadding: CGFloat = 60.0

class MsgLayout {
    
    var msg: Message
    
    var cellHeight: CGFloat = 0
    var cellWidth: CGFloat = 0
    
    var maxWidth: CGFloat{
        return PMUIContraint.kScreenWidth - kRightPadding - kLeftPadding - kIconWidth
    }
    
    init(msg: Message){
        self.msg = msg
        
        if msg.type == MsgType.Text.rawValue{
            self.msg.showText = msg.body
           let cellSize = self.msg.showText.sizeWithFont(UIFont.systemFontOfSize(15), width: maxWidth)
            cellWidth = cellSize.height < 25 ? cellSize.width : maxWidth
            cellWidth += 3*kChatItemPadding
            cellHeight = cellSize.height + 2 * kChatItemPadding
        }
        

    }
}