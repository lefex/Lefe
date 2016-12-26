//
//  PMVideoStateView.swift
//  PMLefe
//
//  Created by wsy on 16/1/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

protocol PMVideoStateViewDelegate{
    func videoStateViewPlayClick(videoStateView: PMVideoStateView, isPlay: Bool)
}

class PMVideoStateView: UIView {

    // MARK: - properties
    var progressSlider: UISlider!
    var playButton: UIButton!
    var leftTimeLabel: UILabel!
    var rightTimeLabel: UILabel!
    var delegate: PMVideoStateViewDelegate?
    var isPlay = true
    
    var leftTime: String {
        get {
            return leftTimeLabel.text!
        }
        set {
            leftTimeLabel.text = newValue
        }
    }
    
    var rightTime: String {
        get {
            return rightTimeLabel.text!
        }
        set {
            rightTimeLabel.text = newValue
        }
    }
    
    // MARK - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        
        playButton = UIButton(type: .Custom)
        playButton.frame = CGRectMake(10, (frame.size.height-30)/2.0, 30, 30)
        playButton.setBackgroundImage(UIImage(named: "play_transparent"), forState: .Normal)
        playButton.setBackgroundImage(UIImage(named: "pause"), forState: .Selected)
        playButton.addTarget(self, action: #selector(PMVideoStateView._playButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(playButton)
        
        leftTimeLabel = _createTimeLabel(CGRect(x: CGRectGetMaxX(playButton.frame)+10, y: 15, width: 30, height: 14))
        self.addSubview(leftTimeLabel)
        
        let silderHeight: CGFloat = 15
        let silderX = CGRectGetMaxX(leftTimeLabel.frame)+5
        let silderRect = CGRectMake(silderX, (frame.size.height - silderHeight)/2.0, frame.size.width - silderX - 55, silderHeight)
        progressSlider = UISlider(frame: silderRect)
        progressSlider.thumbTintColor = UIColor.whiteColor()
        self.addSubview(progressSlider)
        
        rightTimeLabel = _createTimeLabel(CGRect(x: CGRectGetMaxX(progressSlider.frame)+5, y: 15, width: 30, height: 14))
        self.addSubview(rightTimeLabel)
        
    }
    
    // MARK - private methods
    private func _createTimeLabel(labelFrame: CGRect) ->UILabel{
        let lable: UILabel = UILabel(frame: labelFrame)
        lable.textAlignment = .Center
        lable.textColor = UIColor.whiteColor()
        lable.font = UIFont.systemFontOfSize(8)
        return lable
    }
    
    func _playButtonClick(button: UIButton){
        button.selected = isPlay
        self.delegate?.videoStateViewPlayClick(self, isPlay: isPlay)
        isPlay = !isPlay
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
