//
//  PMArray.swift
//  PMLefe
//
//  Created by wsy on 16/2/28.
//  Copyright © 2016年 WSY. All rights reserved.
//

extension Array{
    subscript (safe index: Int) -> Element?{
        return index >= 0 && index < count ? self[index] : nil
    }
}
