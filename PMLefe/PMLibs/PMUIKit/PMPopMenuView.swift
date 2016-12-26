//
//  PMPopMenuView.swift
//  PMLefe
//
//  Created by wsy on 16/3/30.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let kItemPadding: CGFloat = 16
private let kTagOffset = 10232
private let kTimeInterval: NSTimeInterval = 0.8
private let kClickTimeInterval: NSTimeInterval = 0.6
private let kDefaultCenterHeight: CGFloat = 200.0
private let kRows = 3
private let kItemEdgeX: CGFloat = 20.0
private let kItemEdgeY: CGFloat = 20.0

protocol PMPopMenuViewDelgate: class{
    func popMenuViewCickedWithIndex(index : Int, popView: PMPopMenuView)
}


class PMPopMenuView: UIView {


    let titles = ["pm_photos", "pm_videos", "pm_note", "pm_audio", "pm_password", "pm_cammera"]
    let imageNames = ["home_photo", "home_video", "home_text", "home_voice", "home_pwd", "home_cammer"]
    
    var items: [UIButton] = []
    var centers: [CGPoint] = []
    var isAnimating = false
    
    weak var delegate: PMPopMenuViewDelgate?
    
    var _itemWidth: CGFloat{
        get {return (width - CGFloat(kRows+1)*kItemEdgeX) / CGFloat(kRows)}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Change font
    func changeTitleFont(){
        for button in items{
            button.titleLabel?.font = PMUIContraint.kFont
        }
    }
    
    private func createUI(){

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PMPopMenuView.hiddenPopMenuView))
        self.addGestureRecognizer(tapGesture)

        // blur
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        self.addSubview(blurView)
        
        // buttons
        let max = titles.count
        for i in 0 ..< max {
            let button = createButton(titles[i], imageName: imageNames[i], heighLightImageName: nil)
            button.tag = kTagOffset + i
            items.append(button)
        }
        hidden = true
    }
    
    private func createButton(title: String, imageName: String, heighLightImageName: String?) -> UIButton{
        let button = UIButton(type: .Custom)
        let itemWidth = _itemWidth
        button.size = CGSize(width: itemWidth, height: itemWidth)
        button.setTitle(NSLocalizedString(title, comment: ""), forState: .Normal)
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.titleLabel?.font = PMUIContraint.kFont
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: kItemPadding, bottom: 2*kItemPadding, right: kItemPadding)
        button.titleEdgeInsets = UIEdgeInsets(top: (itemWidth-kItemPadding*2), left: -(itemWidth/2+10), bottom: 0, right: kItemPadding)
        button.addTarget(self, action: #selector(PMPopMenuView.buttonClickAction(_:)), forControlEvents: .TouchUpInside)
        button.addTarget(self, action: #selector(PMPopMenuView.buttonCancel(_:)), forControlEvents: .TouchCancel)
        button.addTarget(self, action: #selector(PMPopMenuView.buttonCancel(_:)), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: #selector(PMPopMenuView.buttonClickDown(_:)), forControlEvents: .TouchDown)

        addSubview(button)
        return button
    }
    
    func showPopMenuView(){
        if isAnimating{
            return
        }
        isAnimating = true
        
        hidden = false
        alpha = 1.0
        let itemWidth = _itemWidth
        let itemCenteY = height - kDefaultCenterHeight
        let max = items.count
        for i in 0  ..< max{
            let button = items[i]
            let centerPoint = CGPoint(x: itemWidth / 2.0 + CGFloat(i%kRows)*itemWidth + kItemEdgeX*(CGFloat(i%kRows)+1.0), y: itemCenteY)
            let centerY = (height - itemWidth*2.0 - kItemEdgeY) / 2.0 + itemWidth/2.0*CGFloat(i<kRows ? 1 : 3) + kItemEdgeY*CGFloat(i<kRows ? 0 : 1)
            button.center = centerPoint
            let showCenter = CGPoint(x: centerPoint.x, y: centerY)
            centers.append(showCenter)
            showAnimation(Double(i)*0.1, center: showCenter, button: button, isShow: true)
        }
    }
    
    func buttonClickAction(button: UIButton){

        for aButton in items{
            if aButton.tag == button.tag{
                scalAnimation(aButton, isScal: true, scal: 2.0)
            }else{
                scalAnimation(aButton, isScal: true, scal: 0.2)
            }
        }
        
        UIView.animateWithDuration(kClickTimeInterval, animations: { [weak self]() -> Void in
            self?.alpha = 0
            }) { [weak self](isFinsh) -> Void in
                self?.hidden = true
                self?.delegate?.popMenuViewCickedWithIndex(button.tag - kTagOffset, popView: self!)
        }

    }
    
    func buttonClickDown(button : UIButton){
        scalAnimation(button, isScal: true, scal: 1.2)
    }
    
    func buttonCancel(button : UIButton){
        scalAnimation(button, isScal: false, scal: 1.0)

    }
    
    private func scalAnimation(button: UIButton, isScal: Bool, scal: CGFloat){
        UIView.animateWithDuration(kClickTimeInterval) { () -> Void in
            if isScal{
                button.transform = CGAffineTransformMakeScale(scal, scal)
                button.alpha = 1.0
            }else{
                button.transform = CGAffineTransformIdentity
                button.alpha = 1.0
            }
        }
    }
    
    func hiddenPopMenuView(){
        if isAnimating{
            return
        }
        isAnimating = true
        
        let max = items.count
        for var i = max-1; i >= 0; i -= 1{
            let button = items[i]
            let hidenCenter = CGPoint(x: centers[i].x, y: height)
            showAnimation(Double(max-i-1)*0.1, center: hidenCenter, button: button, isShow: false)
        }
    }
    
    private func showAnimation(delay: NSTimeInterval, center: CGPoint, button: UIButton, isShow: Bool){
        button.alpha = isShow ? 0 : 1.0
        button.transform = CGAffineTransformIdentity

        UIView.animateWithDuration(kTimeInterval, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
            button.center = center
            button.alpha = isShow ? 1.0 : 0
            }) {[weak self] (isFinsh) -> Void in
                if isShow{
                    if isFinsh{
                        if button.tag - kTagOffset == (self?.items.count)! - 1{
                            self?.isAnimating = false
                        }
                    }
                }else{
                    if isFinsh{
                        self?.hidden = true
                        self?.isAnimating = false
                    }
                }
        }
        
        
    }
}
