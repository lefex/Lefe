//
//  PMAlbumHelper.swift
//  PMLefe
//
//  Created by wsy on 16/6/3.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    func pm_imageFrameForScreen() -> CGRect {
        var rWidth: CGFloat = 0
        var rHeight: CGFloat = 0
        var rX: CGFloat = 0
        var rY: CGFloat = 0
        
        let screenBounds = UIScreen.mainScreen().bounds
        let imageW = self.size.width
        let imageH = self.size.height
        
        if imageW > screenBounds.width && imageH > screenBounds.height {
            // Image width and height more than screenBounds
            let imageWRation = imageH / screenBounds.width
            let imageHRation = imageH / screenBounds.height
            if imageWRation > imageHRation {
                rWidth = screenBounds.width
                rHeight = imageH / imageWRation
                rX = 0
                rY = (screenBounds.height - rHeight) / 2.0
            }
            else
            {
                rWidth = imageW / imageHRation
                rHeight = screenBounds.height
                rX = (screenBounds.width - imageW) / 2.0
                rY = 0
            }
        }
        else if imageW > screenBounds.width{
            // Image width more than screen width, but height not
            rWidth = screenBounds.width
            rHeight = imageH / (imageW / rWidth)
            rX = 0
            rY = (screenBounds.height - rHeight) / 2.0
            
        }
        else if imageH > screenBounds.height{
            // Image height more than screen height, but width not
            rHeight = screenBounds.height
            rWidth = imageW / (imageH / screenBounds.height)
            rX = (screenBounds.width - rWidth) / 2.0
            rY = 0
        }
        else{
            rWidth = imageW
            rHeight = imageH
            rX = (screenBounds.width - imageW) / 2.0
            rY = (screenBounds.height - imageH) / 2.0
        }
        
        return CGRect(x: rX, y: rY, width: rWidth, height: rHeight)
    }
}