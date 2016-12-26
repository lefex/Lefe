//
//  PMNoteListCell.swift
//  PMLefe
//
//  Created by wsy on 16/7/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

private let kEdge: CGFloat = 10
private let kPadding: CGFloat = 5
private let kTimeWidth: CGFloat = 60

class PMNoteListCell: UITableViewCell {

    // 背景
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_note_bg")
        return imageView
    }()
    
    // 标题
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PMUIContraint.fontWithNameSize(PMUIContraint.kFontHWFangsong, size: 24)
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    // 内容
    var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = PMUIContraint.fontWithNameSize(PMUIContraint.kFontHWFangsong, size: 18.0)
        label.textColor = PMUIContraint.defaultNoteTextColor()
        return label
    }()
    
    // 时间
    var timeLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PMUIContraint.fontWithName(12.0)
        label.textColor = PMUIContraint.grayColor()
        label.textAlignment = .Right
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
            make.leading.equalTo(kEdge)
            make.top.equalTo(kPadding)
            make.trailing.equalTo(-(kTimeWidth + kEdge))
            make.height.equalTo(40)
        }
        
        bgImageView.addSubview(timeLable)
        timeLable.snp_makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp_trailing)
            make.top.equalTo(titleLabel)
            make.trailing.equalTo(-kEdge)
        }
        
        bgImageView.addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(kEdge)
            make.top.equalTo(titleLabel.snp_bottom)
            make.trailing.equalTo(-kEdge)
        }
    }
    
    func configureNote(note: Note) {
        titleLabel.text = note.title
        contentLabel.attributedText = note.contetnAtt
        timeLable.text = note.date.pm_showTime
    }

}
