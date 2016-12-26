//
//  PMCammerManager.swift
//  PMLefe
//
//  Created by wsy on 16/3/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation

class PMCammerManager {
    
    var captureSession: AVCaptureSession!
    var activeVideoInput: AVCaptureDeviceInput!
    var imageOutput: AVCaptureStillImageOutput!
    var movieOutput: AVCaptureMovieFileOutput!
    
    

    func setUpSession() -> Bool{
        
        // 创建会话
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        // 设置视频输入设备
        let videoDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let videoInput: AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoInput){
                captureSession.addInput(videoInput)
            }else{
                print("Can not add AVMediaTypeVideo｀")
                return false
            }

            
        }catch let error as NSError{
            print(error.localizedDescription)
            return false
        }
        
        
        // 设置音频输入设备
        let audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        do{
            let audioInput: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput){
                captureSession.addInput(audioInput)
            }else{
                print("Can not add AVMediaTypeAudio")
                return false;
            }
            
        }catch let error as NSError{
            print(error.localizedDescription)
            return false
        }
        
        // 用于从摄像头捕获静态图片
        imageOutput = AVCaptureStillImageOutput()
        if captureSession.canAddOutput(imageOutput){
            captureSession.addOutput(imageOutput)
            imageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG];
        }else{
            print("Can not add AVCaptureStillImageOutput")
            return false
        }
        
        // 用于将QuickTime电影录制到文件系统
        movieOutput = AVCaptureMovieFileOutput()
        if captureSession.canAddOutput(movieOutput){
            captureSession.addOutput(movieOutput)
        }else{
            print("Can not add AVCaptureMovieFileOutput")
            return false;
        }
        
        return true
    }
    
    func startSession(){
        if !captureSession.running{
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                self.captureSession.startRunning()
            })
        }
    }
    

    func stopSession(){
        if captureSession.running{
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                self.captureSession.stopRunning()
            })
        }
    }
}
