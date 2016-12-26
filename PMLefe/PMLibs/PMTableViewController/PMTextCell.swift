//
//  PMTableVIewCell.swift
//  PMLefe
//
//  Created by wsy on 16/4/17.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMTextCell: UITableViewCell {

    var textLable: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createTextCellUI()
    }
    
    private func createTextCellUI(){
        // Text
        textLable = UILabel()
        textLable.backgroundColor = UIColor.whiteColor()
        textLable.numberOfLines = 1
        contentView.addSubview(textLable)
        textLable.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(PMUIContraint.kLeftEdge)
            make.right.equalTo(PMUIContraint.kRightEdge)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(delegate: PMTextDelegate){
        textLable.font = delegate.textFont
        textLable.textColor = delegate.textColor
        textLable.text = delegate.text
    }
}
