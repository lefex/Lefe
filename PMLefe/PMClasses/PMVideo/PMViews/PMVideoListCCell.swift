//
//  PMVideoListCCell.swift
//  PMLefe
//
//  Created by wsy on 16/6/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

class PMVideoListCCell: UICollectionViewCell {
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "no_note_bg")!.stretchableImageWithLeftCapWidth(20, topCapHeight: 20)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PMUIContraint.fontWithName(12)
        label.textAlignment = .Right
        label.textColor = PMUIContraint.grayColor()
        return label
    }()
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bgImageView)
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        // Content
        imageView = UIImageView()
        imageView.image = PMUIContraint.defaultVideoImage()
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0))
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(0)
        }
    }
    
    func configureVideo(aVideo: Video) {
        timeLabel.text = aVideo.date.pm_showTime
        if let data = aVideo.cover{
            if let image = UIImage(data: data){
                imageView.image = image
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
