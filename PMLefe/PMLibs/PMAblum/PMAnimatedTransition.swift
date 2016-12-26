//
//  PMAnimatedTransition.swift
//  PMLefe
//
//  Created by wsy on 16/5/22.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import Photos


private let kTimeInterval: NSTimeInterval = 0.25

class PMAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresent: Bool
    let photoItems: [PMPhotoItem]
    
    init(isPresent: Bool, photoItems: [PMPhotoItem]){
        self.isPresent = isPresent
        self.photoItems = photoItems
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kTimeInterval
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Contain view
        guard let containView: UIView = transitionContext.containerView() else {
            return
        }
        
        guard let toVC: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else{
            return
        }
        
        var fromItem: PMPhotoItem = PMPhotoItem(image: nil, thumbView: nil, isSelectedItem: false, asset: nil, filePath: nil)
        var fromItemFrame: CGRect = CGRectZero
        
        for item in self.photoItems {
            if item.isSelectedItem{
                fromItem = item
                break
            }
        }
        
        if let fromThumbView = fromItem.thumbView{
            fromItemFrame = fromThumbView.convertRect(fromThumbView.frame, toView: toVC.view)
        }

        
        if isPresent {
            guard let toVC: PMPhotoPreviewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? PMPhotoPreviewController else{
                return
            }
            
            guard let imageView: UIImageView = toVC.currentCell?.imageView else{
                return
            }
            
            let finalFrame = transitionContext.finalFrameForViewController(toVC)
            toVC.view.frame = finalFrame
            toVC.view.alpha = 0
            imageView.frame = fromItemFrame
            containView.addSubview(toVC.view)
            
            
            guard fromItem.image != nil else{
                return
            }
            
            let imageResultFrame = fromItem.image!.pm_imageFrameForScreen()
            imageView.frame = fromItemFrame
            
            let duration: NSTimeInterval = self.transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: { 
                toVC.view.backgroundColor = UIColor.blackColor()
                toVC.view.alpha = 1.0
                imageView.frame = imageResultFrame
                }, completion: { (isFinish) in
                    transitionContext.completeTransition(true)
            })
        }
        else
        {
            guard let fromVC: PMPhotoPreviewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? PMPhotoPreviewController else{
                return
            }
            
            
            containView.addSubview(toVC.view)
            containView.sendSubviewToBack(toVC.view)
            
            guard let imageView: UIImageView = fromVC.currentCell?.imageView else{
                return
            }
            
            let duration: NSTimeInterval = self.transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: {
                fromVC.view.backgroundColor = UIColor.clearColor()
                imageView.frame = fromItemFrame
                
                }, completion: { (isFinsh) in
                    transitionContext.completeTransition(true)
            })

        }
    }
    
}