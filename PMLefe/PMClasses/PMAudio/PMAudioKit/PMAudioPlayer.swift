//
//  PMAudioPlayer.swift
//  PMLefe
//
//  Created by wsy on 16/1/12.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation

class PMAudioPlayer: NSObject {
    
    static let sharePlayer = PMAudioPlayer()
    
    var finishAction: (()->())?
    
    // MARK: Properties
    var player: AVAudioPlayer?
    var audioPath: String?
    
    /// the audio duration
    var duration: NSTimeInterval{
        get{
            if let aPlayer = player{
                return aPlayer.duration
            }
            return 0
        }
    }
    
    var currentTime: NSTimeInterval{
        get{
            if let aPlayer = player{
                return aPlayer.currentTime
            }
            return 0
        }
    }
    
    func preparePlay(filePath: String) {
        
        if filePath.isEmpty{
            fatalError("You should specify a audioPath for the [PMAudioPlayer].")
        }
        self.audioPath = filePath
        
        // 切换权限
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error {
            print_pm("playAudioWithMessage setCategory failed: \(error)")
        }
        
        do
        {
            let aPLayer = try  AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: filePath))
            aPLayer.delegate = self
            aPLayer.prepareToPlay()
            self.player = aPLayer
            print_pm("aPLayer.duration = \(aPLayer.duration)")
        }
        catch let error as NSError
        {
            self.player = nil
            print_pm("init player error: " + error.localizedDescription)
        }
        
    }
    
    // MARK: Play action
    func play(){
        if let aPlayer = self.player{
            aPlayer.play()
        }
    }
    
    func stop(){
        if let aPlayer = self.player{
            aPlayer.stop()
        }
    }
    
    func pause(){
        if let aPlayer = self.player{
            aPlayer.pause()
        }
    }
   
}

// MARK: - AVAudioPlayerDelegate
extension PMAudioPlayer: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finish playing")
        self.finishAction?()
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("error happen when playing, error: " + (error?.localizedDescription)!)
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        pause()
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        play()
    }
}

// MARK: - Register audio session
extension PMAudioPlayer{
    class func regisetrAudio(category: String) -> Bool{
        var isSuccess = true
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(category)
        }
        catch let error as NSError
        {
            print_pm("set category error: " + error.localizedDescription)
            isSuccess = false
        }
        
        do
        {
            try audioSession.setActive(true)
        }
        catch let error as NSError
        {
            print_pm("set active error: " + error.localizedDescription)
            isSuccess = false
        }
        return isSuccess
    }

}

