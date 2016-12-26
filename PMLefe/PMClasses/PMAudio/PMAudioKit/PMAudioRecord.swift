//
//  PMAudioRecord.swift
//  PMLefe
//
//  Created by wsy on 16/1/16.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation


public enum AudioFileExtenion: String{
    case M4A = "caf"
}

public typealias PMBoolComplete = ((isFinsh: Bool)->())

class PMAudioRecord: NSObject {

    static let sharedRecordManager = PMAudioRecord()

    var audioRecorder: AVAudioRecorder?
    var recorderUrl: NSURL?
    var stopCompleteHandle: PMBoolComplete?
    
    var currentTime: NSTimeInterval{
        get {
            if let recorder = audioRecorder{
                return recorder.currentTime
            }
            return 0
        }
    }
    
    func prepareAudio(fileUrl: NSURL, audioRecordDelegate: AVAudioRecorderDelegate){
         recorderUrl = fileUrl
        
        let settings: [String: AnyObject] = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC),AVSampleRateKey: NSNumber(float: 22050.0), AVNumberOfChannelsKey: NSNumber(int: 1)]
        
        do{
            let audioRecorder = try AVAudioRecorder(URL: fileUrl, settings: settings)
            audioRecorder.delegate = audioRecordDelegate
            audioRecorder.meteringEnabled = true
            self.audioRecorder = audioRecorder
        }
        catch let error as NSError
        {
            print("init PMAudioRecord error: " + error.localizedDescription)
            self.audioRecorder = nil
        }
    }
    
    
    func beginRecord(fileUrl: NSURL, audioRecordDelegate: AVAudioRecorderDelegate) {
        // 获取声音权限，如果不能录音查看是否请求了声音权限
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch let error {
            print("beginRecordWithFileURL setCategory failed: \(error)")
        }
        
        do
        {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError
        {
            print_pm("set active error: " + error.localizedDescription)
        }
        
        // 用户同意获取了声音权限
        if AVAudioSession.sharedInstance().recordPermission() == .Granted{
            
            self.prepareAudio(fileUrl, audioRecordDelegate: audioRecordDelegate)
            
            if let recorder = self.audioRecorder{
                recorder.prepareToRecord()

                if recorder.recording{
                    recorder.stop()
                }else{
                    recorder.record()
                }
            }
        }
        else{
            print("用户没用允许开启声音权限")
        }
    }
    
    func endRecod() {
        
        if let recorder = self.audioRecorder{
             recorder.stop()
            /*
             注释的写法会有一个很大的bug，如果录音暂停后，将不会走stop()，那么
             你所录的音就不能够播放，被坑了
             */
//            if recorder.recording{
//                recorder.stop()
//            }
        }
        
        // 关闭session
       _ = try? AVAudioSession.sharedInstance().setActive(false, withOptions: .NotifyOthersOnDeactivation)
    }
    
    func pauseRecod() {
        
        if let recorder = self.audioRecorder{
            if recorder.recording{
                recorder.pause()
            }
        }
    }
    
    
    
    func powerLeval() -> CGFloat {
        if let recorder = self.audioRecorder{
            if recorder.recording{
                recorder.updateMeters()
                return CGFloat(self._normalizedPowerLevelFromDecibels(recorder.averagePowerForChannel(0)))
            }else{
                return 0.0
            }

        }
        return 0.0
    }
    
    func _normalizedPowerLevelFromDecibels(decibels: Float) -> Float {
        print("averagePowerForChannel: \(decibels)")
        if (decibels < -60.0 || decibels == 0.0) {
            return 0.0
        }
        
        return powf((powf(10.0, 0.05 * decibels) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0);
    }
}

