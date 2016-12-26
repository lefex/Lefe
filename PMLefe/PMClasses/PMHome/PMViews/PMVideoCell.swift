//
//  PMVideoCell.swift
//  PMLefe
//
//  Created by wsy on 16/3/22.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol PMVideoCellDelegate{
    func playButtonClick(button: UIButton)
}

class PMVideoCell: PMHomeBaseCell {

    var bgImageView: UIImageView!
    var titleLabel: UILabel!
    var playButton: UIButton!
    
    var delegate: PMVideoCellDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.createUI()
    }

    
    func createUI(){
        
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "fy1")
        bgImageView.userInteractionEnabled = true
        contentView.addSubview(bgImageView)
        bgImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
        
        playButton = UIButton()
        playButton.setImage(UIImage(named: "play_transparent"), forState: .Normal)
        contentView.addSubview(playButton)
        playButton.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bgImageView)
            make.size.equalTo(CGSize(width: 51, height: 51))
        }
        playButton.addTarget(self, action: #selector(PMVideoCell.play), forControlEvents: .TouchUpInside)
        
        layoutIfNeeded()
    }

    func play(){
        print("play")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
