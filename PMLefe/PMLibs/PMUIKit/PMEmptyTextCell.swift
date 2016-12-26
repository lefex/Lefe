//
//  PMEmptyTextCell.swift
//  PMLefe
//
//  Created by wsy on 16/7/16.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

private let kEdge: CGFloat = 30
private let kYOffset: CGFloat = 30

class PMEmptyTextView: UIView {
    
    var topYContraint: Constraint!

    var textLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = PMUIContraint.defaultTableColor()
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = .Center
        label.font = PMUIContraint.fontWithName(18)
        label.numberOfLines = 1
        return label
    }()
    
    var contentLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = PMUIContraint.defaultTableColor()
        label.font = PMUIContraint.fontWithName(16)
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTextCellUI()
    }
    
    private func createTextCellUI(){
        // Text
        addSubview(textLable)
        textLable.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(kEdge)
            make.trailing.equalTo(-kEdge)
            topYContraint = make.top.equalTo(0).constraint
            make.height.equalTo(40)
        }
        
        // Content
        addSubview(contentLable)
        contentLable.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(textLable.snp_leading)
            make.trailing.equalTo(textLable.snp_trailing)
            make.top.equalTo(textLable.snp_bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEmptyView(text: String?, contentText: String?){
        
        
        if let text = text{
            textLable.hidden = false
            textLable.text = text
        }else{
            textLable.hidden = true
        }
        
        if let content = contentText{
            contentLable.text = content
            contentLable.hidden = false
            let height = content.heightWithFont(PMUIContraint.fontWithName(16), width: frame.width - kEdge)
            topYContraint.updateOffset( (frame.height - 40 - height) / 2.0 - kYOffset)

        }else{
            contentLable.hidden = true
            topYContraint.updateOffset( (frame.height - 40) / 2.0 - kYOffset)
        }
    }


}
