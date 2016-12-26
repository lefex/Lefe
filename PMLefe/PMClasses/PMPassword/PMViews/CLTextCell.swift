//
//  CLTextCell.swift
//  PMLefe
//
//  Created by wsy on 16/7/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit


private let kEdge: CGFloat = 10
private let kPadding: CGFloat = 5

class CLTextCell: UITableViewCell {

    // 背景
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        var image = UIImage(named: "no_note_bg")!
        image = image.stretchableImageWithLeftCapWidth(20, topCapHeight: 30)
        imageView.image = image
        return imageView
    }()
    
    // 标题
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = PMUIContraint.fontWithNameSize(PMUIContraint.kFontHWFangsong, size: 20.0)
        label.textColor = PMUIContraint.defaultNoteTextColor()
        label.layer.masksToBounds = true
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
        contentView.addSubview(bgImageView)
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: kEdge, left: kEdge, bottom: 0, right: -kEdge))
        }
        
        bgImageView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(kPadding)
            make.top.equalTo(kPadding)
            make.trailing.equalTo(-kPadding)
            make.bottom.equalTo(-kPadding)
        }
        
    }
    
    func configureNote(text: String) {
        titleLabel.text = text
    }


}
