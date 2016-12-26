//
//  PMAlbumCell.swift
//  PMLefe
//
//  Created by wsy on 16/4/7.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit

class PMAlbumCell: UITableViewCell {

    var countLabel: UILabel!
    var nameLabel: UILabel!
    var iconImageView: UIImageView!
    var timeLabel: UILabel!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        // Icon
        iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 6
        iconImageView.contentMode = .ScaleAspectFill
        iconImageView.layer.masksToBounds = true
        contentView.addSubview(iconImageView)
        iconImageView.snp_makeConstraints { (make) in
            make.width.equalTo(95)
            make.height.equalTo(73)
            make.leading.equalTo(10)
            make.centerY.equalTo(contentView)
        }
        
        // Name
        nameLabel = UILabel()
        nameLabel.font = PMUIContraint.fontWithName(18)
        nameLabel.textAlignment = .Left
        nameLabel.textColor = UIColor.blackColor()
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.top.equalTo(iconImageView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        // Count
        countLabel = UILabel()
        countLabel.font = UIFont.systemFontOfSize(10)
        countLabel.textAlignment = .Center
        countLabel.textColor = UIColor.whiteColor()
        countLabel.backgroundColor = PMUIContraint.defaultTextColor()
        contentView.addSubview(countLabel)
        countLabel.snp_makeConstraints { (make) in
            make.trailing.equalTo(iconImageView)
            make.bottom.equalTo(iconImageView)
        }
        
        // Time
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFontOfSize(13)
        timeLabel.textAlignment = .Left
        timeLabel.textColor = PMUIContraint.grayColor()
        contentView.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(iconImageView)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    func configureAlbumData(album: Album){
        if let coverImage = album.cover{
            iconImageView.image = UIImage(data: coverImage) ?? PMUIContraint.defaultAlbumCover()
        }else{
            iconImageView.image = PMUIContraint.defaultAlbumCover()
        }
        nameLabel.text = album.name
        countLabel.text = "\(album.photosCount)"
        timeLabel.text = album.date.pm_YMD
    }
}
