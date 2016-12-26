//
//  PMProcgressView.swift
//  PMLefe
//
//  Created by wsy on 16/7/3.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let kPadding: CGFloat = 4.0
private let kTimeWidth: CGFloat = 40.0
private let kPlayWidth: CGFloat = 30.0
private let kAllScreenWidth: CGFloat = 30.0


private let kminValue = "minValue"
private let kmaxValue = "maxValue"
private let kprogress = "progress"

private var PMProcgressViewContext = 0


public class PMProcgressView: UIView {

    dynamic public var minValue: Float = 0 // 秒
    dynamic public var maxValue: Float = 0
    dynamic public var progress: Float = 0
    
    var playAction: (() -> ())?
    var sliderAction: ((value: Float) -> ())?
    
    let KVOKeys = [kminValue, kmaxValue, kprogress]
    
    func hiddenPlayButton() {
        self.playButton.hidden = true
    }
    
    // 播放按钮
    lazy var playButton: UIButton = {
        let playButton = UIButton(type: .Custom)
        playButton.setImage(UIImage(named: "ls_play_small"), forState: .Normal)
        playButton.setImage(UIImage(named: "ls_play_small"), forState: .Selected)
        playButton.addTarget(self, action: #selector(PMProcgressView._playButtonClick(_:)), forControlEvents: .TouchUpInside)
        return playButton
    }()
    
    // 左边时间
    lazy var minLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFontOfSize(10)
        label.textAlignment = .Center
        label.textColor = PMUIContraint.grayColor()
        return label
    }()
    
    
    // 右边时间
    lazy var maxLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFontOfSize(10)
        label.text = "00:00"
        label.textAlignment = .Center
        label.textColor = PMUIContraint.grayColor()
        return label
    }()
    
    // 进度条
    lazy var progressView: UISlider = {
        let view = UISlider()
        view.thumbTintColor = PMUIContraint.defaultLefeMainColor()
        view.minimumTrackTintColor = PMUIContraint.defaultLefeMainColor()
        view.maximumTrackTintColor = PMUIContraint.darkGrayColor()
        view.minimumValue = 0
        view.setThumbImage(UIImage(named: "ls_point"), forState: UIControlState.Normal)
        view.addTarget(self, action: #selector(PMProcgressView._sliderChangeClick(_:)), forControlEvents: .ValueChanged)
        return view
    }()
    
    // 全屏按钮
    lazy var allButton: UIButton = {
        let playButton = UIButton(type: .Custom)
//        playButton.setImage(UIImage(named: "ls_play_small"), forState: .Normal)
        playButton.addTarget(self, action: #selector(PMProcgressView._playButtonClick(_:)), forControlEvents: .TouchUpInside)
        return playButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playButton)
        addSubview(minLabel)
        addSubview(maxLabel)
        addSubview(progressView)
        addSubview(allButton)
        
        for key in KVOKeys {
            addObserver(self, forKeyPath: key, options: [.New], context: &PMProcgressViewContext)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        playButton.frame = CGRectMake(kPadding, 0, kPlayWidth, frame.height)
        minLabel.frame = CGRectMake(CGRectGetMaxX(playButton.frame) + kPadding, 0, kTimeWidth, frame.height)
        progressView.frame = CGRectMake(CGRectGetMaxX(minLabel.frame) + kPadding, 0, frame.width - 2*kTimeWidth - kPlayWidth - kAllScreenWidth - 6*kPadding, frame.height)
        maxLabel.frame = CGRectMake(CGRectGetMaxX(progressView.frame) + kPadding, 0, kTimeWidth, frame.height)
        allButton.frame = CGRectMake(CGRectGetMaxX(maxLabel.frame) + kPadding, 0, kAllScreenWidth, frame.height)
    }
    
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &PMProcgressViewContext else{
            return
        }
        
        if let aKeypath = keyPath{
            print("KVO " + aKeypath)
            if  aKeypath == kminValue {
                minLabel.text = timeWithSecond(minValue)
                
                
            }else if aKeypath == kmaxValue{
                progressView.maximumValue = maxValue
                maxLabel.text = timeWithSecond(maxValue)
                
            }else if aKeypath == kprogress{
                progressView.setValue(progress, animated: true)
                minLabel.text = timeWithSecond(progress)
            }
            
        }
        
    }
    
    func timeWithSecond(seconds: Float) -> String {
       return String(format:"%02d:%02d", Int(seconds / 60), Int(seconds % 60))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    func _playButtonClick(button: UIButton) {
        playAction?()
    }
    
    func _sliderChangeClick(button: UISlider) {
        playAction?()
    }
    
    deinit{
        for key in KVOKeys {
            removeObserver(self, forKeyPath: key)
        }
    }

}
