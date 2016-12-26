//
//  PMProfileCell.swift
//  PMLefe
//
//  Created by wsy on 16/3/24.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

class PMProfileCell: PMHomeBaseCell {

    var iconImageView: UIImageView!
    var titleLabel: UILabel!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
        self.createUI()
    }

    func createUI(){
        
        iconImageView = UIImageView()
        iconImageView.userInteractionEnabled = true
        contentView.addSubview(iconImageView)
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(PMUIContraint.kLeftEdge)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.centerY.equalTo(self)
            
        }
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconImageView.snp_right).offset(20)
            make.right.equalTo(PMUIContraint.kRightEdge)
            make.centerY.equalTo(iconImageView)
        }
        
        layoutIfNeeded()
    }
    
    func configureData(dataItem: DataMessage, indexPath: NSIndexPath){
        iconImageView.image = UIImage(named: dataItem.icon)
        titleLabel.text = dataItem.name
        titleLabel.font = PMUIContraint.kFont
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
