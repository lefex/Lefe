//
//  PMPalyerLayerView.swift
//  PlayerDemo2
//
//  Created by WangSuyan on 16/7/4.
//  Copyright © 2016年 WangSuyan. All rights reserved.
//

import UIKit
import AVFoundation

private let kPlayWidth: CGFloat = 60
private let kProgressHeight: CGFloat = 60

private var kKvoContext = 0
private let kPlayerStats = "player.currentItem.status"
private let kPlayerDuration = "player.currentItem.duration"
private let kPlayerRate = "player.rate"

class PMPlayerView: UIView {
    
    lazy var playerView: PMPalyerLayerView = {
        let view = PMPalyerLayerView()
        return view
    }()
    
    lazy var playButton: UIButton = {
        let view = UIButton(type: UIButtonType.Custom)
        view.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        view.addTarget(self, action: #selector(PMPlayerView.palyClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return view
    }()
    
    lazy var progressView: PMProcgressView = {
        let view = PMProcgressView(frame: CGRectZero)
        return view
    }()
    
    // The loacl file url
    var player: AVPlayer!
    private var timeObserverToken: AnyObject?
    
    
    var fileUrl: NSURL!{
        
        didSet {
            let playerItem = AVPlayerItem(asset: AVAsset(URL: fileUrl))
            player = AVPlayer(playerItem: playerItem)
            playerView.playerLayer.player = player
            addTimeObserve()
            _addObserver()

        }
    }

    
    private let keyPaths: Array<String> = [kPlayerStats, kPlayerDuration, kPlayerRate]
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.blackColor()
        addSubview(playerView)
        addSubview(playButton)
        addSubview(progressView)
        
        progressView.playAction = {
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerView.frame = self.bounds
        playButton.frame = CGRectMake((CGRectGetWidth(playerView.frame) - kPlayWidth) / 2.0, (CGRectGetHeight(playerView.frame) - kPlayWidth) / 2.0, kPlayWidth, kPlayWidth)
        progressView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - kProgressHeight, CGRectGetWidth(playerView.frame), kProgressHeight)
    }
    
    // Public methods
    func play() {
        if let time = player.currentItem?.duration{
            progressView.maxValue = Float(CMTimeGetSeconds(time))
        }
        let newTime = CMTimeMakeWithSeconds(0, 1)
        player.seekToTime(newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player.play()
        playButton.hidden = true
    }
    
    func pause() {
        player.pause()
        playButton.hidden = false
    }
    
    // MARK: - Action
    func palyClick(button: UIButton) {
        play()
    }
    
    private func addTimeObserve(){
        let interval = CMTimeMake(1, 1)
        timeObserverToken = player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) { time in
            print("time = \(Float(CMTimeGetSeconds(time)))")
            self.progressView.progress = Float(CMTimeGetSeconds(time))
        }
    }
    
    // MARK: - KVO
    private func _addObserver() {
        for keyPath in keyPaths{
            addObserver(self, forKeyPath: keyPath, options: [.New, .Initial], context: &kKvoContext)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &kKvoContext else{
            return
        }
        
        // Status
        if let aKeyPath = keyPath{
            print("kvo = \(aKeyPath)")
            
            if aKeyPath == kPlayerStats {
                
                let newStatus: AVPlayerItemStatus
                
                if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
                    newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
                }
                else {
                    newStatus = .Unknown
                }
                
                if newStatus == .ReadyToPlay {
                    
                    
                }else if newStatus == .Failed{
                    print("Player Failed = \(player.status)")
                }
                

            }
            // Duration
            else if aKeyPath == kPlayerDuration{
                let newDuration: CMTime
                if let newDurationAsValue = change?[NSKeyValueChangeNewKey] as? NSValue {
                    newDuration = newDurationAsValue.CMTimeValue
                }
                else {
                    newDuration = kCMTimeZero
                }
                
                let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
                let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            
            }
            else if aKeyPath == kPlayerRate{
                let newRate = (change?[NSKeyValueChangeNewKey] as! NSNumber).doubleValue
                print("reate \(newRate)")
                if newRate == 0 {
                    // End play
                    playButton.hidden = false
                }

            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        for keyPath in keyPaths{
            removeObserver(self, forKeyPath: keyPath)
        }
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}


// MARK: - PMPalyerLayerView
class PMPalyerLayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }

}
