//
//  PMVideoController.swift
//  PMLefe
//
//  Created by wsy on 16/1/2.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

// KVO context
private var playerViewControllerKVOContext = 0

class PMVideoController: PMBaseController {
    let playerView: PMPalyerView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.playerView = PMPalyerView(frame: CGRectMake(0, 0, 300, 400))
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let assetKeysRequiredToPaly = ["playable", "hasProtectedContent"]
    let player = AVPlayer()
    var currentTime: Double{
        get{
            return CMTimeGetSeconds(player.currentTime())
        }
        set{
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seekToTime(newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var dureation: Double{
        guard let currentItem = player.currentItem else{return 0.0}
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var rate: Float{
        get{
            return player.rate
        }
        set{
            player.rate = newValue
        }
    }
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else{ return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    
    private var playerlayer: AVPlayerLayer? {
        return playerView!.playerLayer
    }
    
    private var timeObserverToken: AnyObject?
    private var playerItem: AVPlayerItem? = nil{
        didSet{
            player.replaceCurrentItemWithPlayerItem(self.playerItem)
        }
    }
    
    // MARK: - view controller life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        addObserver(self, forKeyPath: "player.currentItem.duration", options: [.New, .Initial], context: &playerViewControllerKVOContext)
//        addObserver(self, forKeyPath: "player.rate", options: [.New, .Initial], context: &playerViewControllerKVOContext)
//        addObserver(self, forKeyPath: "player.currentItem.status", options: [.New, .Initial], context: &playerViewControllerKVOContext)
        
        playerView!.playerLayer.player = player
        
        let movieURL = NSBundle.mainBundle().URLForResource("yuanfenVideo", withExtension: "mp4")!
        asset = AVURLAsset(URL: movieURL, options: nil)
        
        let interval = CMTimeMake(1, 1)
        timeObserverToken = player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) {
            [weak self] time in
//            self?.timeSlider.value = Float(CMTimeGetSeconds(time))
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let timeObserverToken = timeObserverToken{
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        player.pause()
        
//        removeObserver(self, forKeyPath: "player.currentItem.duration", context: &playerViewControllerKVOContext)
//        removeObserver(self, forKeyPath: "player.rate", context: &playerViewControllerKVOContext)
//        removeObserver(self, forKeyPath: "player.currentItem.status", context: &playerViewControllerKVOContext)
    }
    
    func asynchronouslyLoadURLAsset(newAsset: AVURLAsset){
        newAsset.loadValuesAsynchronouslyForKeys(PMVideoController.assetKeysRequiredToPaly) { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard newAsset == self.asset else {return}
                
                for key in PMVideoController.assetKeysRequiredToPaly{
                    var error: NSError?
                    if newAsset.statusOfValueForKey(key, error: &error) == .Failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        
                        self.handleErrorWithMessage(message, error: error)
                        
                        return
                    }

                }
                
                // We can't play this asset.
                if !newAsset.playable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    
                    self.handleErrorWithMessage(message)
                    
                    return
                }
                self.playerItem = AVPlayerItem(asset: newAsset)
            })
        }
    }
    
    // MARK: - KVO Observation
    
    // Update our UI when player or `player.currentItem` changes.
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        if keyPath == "player.currentItem.duration" {
            // Update timeSlider and enable/disable controls when duration > 0.0
            
            /*
            Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
            `player.currentItem` is nil.
            */
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeNewKey] as? NSValue {
                newDuration = newDurationAsValue.CMTimeValue
            }
            else {
                newDuration = kCMTimeZero
            }
            
            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            
//            timeSlider.maximumValue = Float(newDurationSeconds)
            
//            timeSlider.value = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0
            
//            rewindButton.enabled = hasValidDuration
//            
//            playPauseButton.enabled = hasValidDuration
//            
//            fastForwardButton.enabled = hasValidDuration
//            
//            timeSlider.enabled = hasValidDuration
//            
//            startTimeLabel.enabled = hasValidDuration
//            
//            durationLabel.enabled = hasValidDuration
//            
//            // FIXME: Should use NSDateFormatter?
//            let wholeMinutes = Int(trunc(newDurationSeconds / 60))
//            
//            durationLabel.text = String(format:"%d:%02d", wholeMinutes, Int(trunc(newDurationSeconds)) - wholeMinutes * 60)
        }
        else if keyPath == "player.rate" {
            // Update `playPauseButton` image.
            
            let newRate = (change?[NSKeyValueChangeNewKey] as! NSNumber).doubleValue
            
            let buttonImageName = newRate == 1.0 ? "PauseButton" : "PlayButton"
            
            let buttonImage = UIImage(named: buttonImageName)
            
//            playPauseButton.setImage(buttonImage, forState: .Normal)
        }
        else if keyPath == "player.currentItem.status" {
            // Display an error if status becomes `.Failed`.
            
            /*
            Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
            `player.currentItem` is nil.
            */
            let newStatus: AVPlayerItemStatus
            
            if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
            }
            else {
                newStatus = .Unknown
            }
            
            if newStatus == .Failed {
                handleErrorWithMessage(player.currentItem?.error?.localizedDescription, error:player.currentItem?.error)
            }
        }
    }
    
    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
    override class func keyPathsForValuesAffectingValueForKey(key: String) -> Set<String> {
        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
            "duration":     ["player.currentItem.duration"],
            "currentTime":  ["player.currentItem.currentTime"],
            "rate":         ["player.rate"]
        ]
        
        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValueForKey(key)
    }
    
    // MARK: - Error Handling
    func handleErrorWithMessage(message: String?, error: NSError? = nil) {
        NSLog("Error occured with message: \(message), error: \(error).")
        
        let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")
        let defaultAlertMessage = NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")
        
        let alert = UIAlertController(title: alertTitle, message: message == nil ? defaultAlertMessage : message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")
        
        let alertAction = UIAlertAction(title: alertActionTitle, style: .Default, handler: nil)
        
        alert.addAction(alertAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
