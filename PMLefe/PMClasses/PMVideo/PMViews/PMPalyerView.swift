//
//  PMPalyerView.swift
//  PMLefe
//
//  Created by wsy on 16/1/2.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation

class PMPalyerView: UIView {
    
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
