//
//  LefeStudy.h
//  PMLefe
//
//  Created by wsy on 16/7/22.
//  Copyright © 2016年 WSY. All rights reserved.
//

/*

1.swift中使用OC
 创建OC文件，然后在PMLefe-Bridging-Header.h文件中添加你需要的OC头文件即可
 
2.更新约束
 var bottomContraint: Constraint!
 bottomContraint.updateOffset(-endRect.height)
 contentTextView.layoutIfNeeded()
 
 3.使用Pod时候如果某些库不支持BitCode
 需要在原项目和pod项目中都要设置BitCode为NO


*/
