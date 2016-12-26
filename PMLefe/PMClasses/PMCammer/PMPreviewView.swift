//
//  PMPreviewView.swift
//  PMLefe
//
//  Created by wsy on 16/3/11.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation


class PMPreviewView: UIView {

    // 视频会话
    var session: AVCaptureSession?{
        get{
            return previewLayer.session
        }
        set{
            previewLayer.session = newValue
        }
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    
    // 重写这个方法可以在创建视图实例时自定义图层类型
    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

}
