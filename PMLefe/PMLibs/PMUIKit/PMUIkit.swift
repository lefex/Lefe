//
//  PMUIkit.swift
//  PMLefe
//
//  Created by wsy on 16/1/22.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import UIKit

class PMUIKit {
    
    /**
     create section view
     
     - parameter title: section view title
     
     - returns: sectionView
     */
    class func createSectionView(title: String) -> UIView{
        let bgView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: PMUIContraint.kScreenWidth, height: 30))
        bgView.backgroundColor = UIColor.groupTableViewBackgroundColor()

        let label: UILabel = UILabel(frame: CGRect(x: PMUIContraint.kLeftEdge, y: 5, width: PMUIContraint.kScreenWidth-PMUIContraint.kLeftEdge*2, height: 20))
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.text = title
        bgView.addSubview(label)
        return bgView
    }
    
    
}