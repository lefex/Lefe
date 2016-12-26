//
//  PMIconTextCell.swift
//  PMLefe
//
//  Created by wsy on 16/4/17.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

class PMIconTextCell: UITableViewCell {

    var textLable: UILabel!
    var iconImageView: UIImageView!
    
    var iconWidthContraint: Constraint!
    var iconHeightContraint: Constraint!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createTextCellUI()
    }
    
    private func createTextCellUI(){
        // Image
        iconImageView = UIImageView()
        iconImageView.userInteractionEnabled = true
        contentView.addSubview(iconImageView)
        iconImageView.snp_makeConstraints {[weak self] (make) -> Void in
            make.left.equalTo(PMUIContraint.kLeftEdge)
            self?.iconHeightContraint = make.height.equalTo(24).constraint
            self?.iconWidthContraint = make.width.equalTo(24).constraint
            make.centerY.equalTo((self?.contentView)!)
            
        }

        // Text
        textLable = UILabel()
        textLable.backgroundColor = UIColor.whiteColor()
        textLable.numberOfLines = 1
        contentView.addSubview(textLable)
        textLable.snp_makeConstraints {(make) -> Void in
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.right.equalTo(PMUIContraint.kRightEdge)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(delegate: PMTextImageDelegate){
        textLable.font = delegate.textFont
        textLable.textColor = delegate.textColor
        textLable.text = delegate.text
        
        iconImageView.image = UIImage(named: delegate.imageName)
        iconWidthContraint.updateOffset(delegate.imageWidth)
        iconHeightContraint.updateOffset(delegate.imageHeight)
        
        self.layoutIfNeeded()
    }

}
