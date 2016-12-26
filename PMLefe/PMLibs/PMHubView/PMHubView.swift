//
//  PMHubView.swift
//  PMHudViewDemo
//
//  Created by WangSuyan on 16/7/1.
//  Copyright © 2016年 WangSuyan. All rights reserved.
//

import UIKit

public enum PMHudViewType {
    case Loading
    case Text
    case Progress
}

// UI
private let kActivityIndicatorViewWidth: CGFloat = 44.0
private let kProgressWidth: CGFloat = 60.0
private let kHudBackgroundWidth: CGFloat = 80.0
private let kHudBackgroundHeight: CGFloat = 80.0
private let kTextEdgePadding: CGFloat = 50.0


// KVO
private let kHudColor = "hudColor"
private let kIndicatorColor = "indicatorColor"
private let kProgress = "progress"
private let kLabelFont = "labelFont"
private let kLabelText = "labelText"

private var PMHudViewContext = 0

public class PMHubView: UIView {
    
    // MARK: - Properties
    dynamic public var hudColor: UIColor = UIColor.blackColor()
    dynamic public var indicatorColor: UIColor = UIColor.whiteColor()
    dynamic public var progress: CGFloat = 0
    dynamic public var labelFont: UIFont = UIFont.systemFontOfSize(15)
    dynamic public var labelText: String = ""


    private var keypaths: Array<String>{
        get{
            return [kHudColor, kIndicatorColor, kProgress, kLabelFont, kLabelText]
        }
    }
    
    public var hudType: PMHudViewType!
    
    private var hiddenTimer: NSTimer?

    // MARK: - View
    // Main background view
    lazy var mainBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    // Hud background view
    lazy var hudBackGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        return view
    }()
    
    // Loading view
    lazy var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        view.hidesWhenStopped = true
        
        return view
    }()
    
    // Progress layer
    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.cornerRadius = kProgressWidth / 2.0
        layer.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0).CGColor
        let path = UIBezierPath(roundedRect: CGRectInset(CGRectMake(0, 0, kProgressWidth, kProgressWidth), 7, 7), cornerRadius: kProgressWidth / 2.0 - 7.0)
        layer.path = path.CGPath
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.lineWidth = 4.0
        layer.lineCap = kCALineCapRound
        layer.strokeStart = 0
        layer.strokeEnd = 0
        return layer
    }()
    
    // Text label
    lazy var textLabe: UILabel = {
       let label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        label.font = PMUIContraint.fontWithName(18)
        return label
    }()
    
    // MARK: - Init
    init(frame: CGRect, type: PMHudViewType) {
        super.init(frame: frame)
        self.hudType = type
        commontInit()
    }
    
    private func commontInit() {
        mainBackgroundView.frame = frame
        self.addSubview(mainBackgroundView)
        
        configureLoadingView()
        
        configureKVO()
    }
    
    private func configureLoadingView(){
        
        if hudType == .Loading {
            // Loading type
            hudBackGroundView.frame = CGRectMake((frame.width - kHudBackgroundWidth) / 2.0, (frame.height - kHudBackgroundWidth) / 2.0, kHudBackgroundWidth, kHudBackgroundHeight)
            hudBackGroundView.backgroundColor = hudColor
            mainBackgroundView.addSubview(hudBackGroundView)
            
            activityView.frame = CGRectMake((kHudBackgroundWidth - kActivityIndicatorViewWidth) / 2.0, (kHudBackgroundHeight - kActivityIndicatorViewWidth) / 2.0, kActivityIndicatorViewWidth, kActivityIndicatorViewWidth)
            activityView.startAnimating()
            hudBackGroundView.addSubview(activityView)
            
        }else if hudType == .Progress{
            // Progress type
            progressLayer.frame = CGRectMake((frame.width - kProgressWidth) / 2.0, (frame.height - kProgressWidth) / 2.0, kProgressWidth, kProgressWidth)
            mainBackgroundView.layer.addSublayer(progressLayer)
            
        }else if hudType == .Text{
            // Text type
            textLabe.font = labelFont
            mainBackgroundView.addSubview(textLabe)
        }
    }
    
    private func configureKVO(){
        for keypath in keypaths {
            addObserver(self, forKeyPath: keypath, options: [.New], context: &PMHudViewContext)
        }

    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &PMHudViewContext else{
            return
        }
        
        if let aKeypath = keyPath{
            print("KVO " + aKeypath)
            if  aKeypath == kHudColor {
                hudBackGroundView.backgroundColor = hudColor
                
            }else if aKeypath == kIndicatorColor{
                activityView.color = indicatorColor
                
            }else if aKeypath == kProgress{
                progressLayer.strokeEnd = progress
                
            }else if aKeypath == kLabelFont{
                textLabe.font = labelFont
                
            }else if aKeypath == kLabelText{
                textLabe.text = labelText
                let width = frame.width - kTextEdgePadding
                let textRect = labelText.heightOfText(CGSizeMake(width, 200), font: labelFont)
                let height = textRect.height + 20 > 50 ? textRect.height + 20 : 50
                let textWidth = textRect.width > 100 ? textRect.width + 20 : 100;
                textLabe.frame = CGRectMake((frame.width - textWidth) / 2.0, (frame.height - height) / 2.0, textWidth, height)
            }

        }

    }
    
    // MARK: - Public methods
    class func showInView(view: UIView) -> PMHubView{
        return showInView(view, type: .Loading)
    }
    
    class func showInView(view: UIView, type: PMHudViewType) -> PMHubView{
        let hud = PMHubView(frame: view.bounds, type: type)
        view.addSubview(hud.mainBackgroundView)
        return hud
    }
    
    func showInView(view: UIView){
        view.addSubview(self.mainBackgroundView)
    }
    
    func hidHudView() {
        if hudType == .Loading{
            activityView.stopAnimating()
            hudBackGroundView.removeFromSuperview()
        }
        
        hidHudViewWithAnimated(true)
    }
    
    func hidHudViewWithAnimated(animated: Bool) {
        if hudType == .Loading
        {
            activityView.stopAnimating()
            hudBackGroundView.removeFromSuperview()
        }
        else if hudType == .Text
        {
            if animated {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    
                    }, completion: { (isFinish) in
                        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                            self.textLabe.transform = CGAffineTransformMakeScale(0.1, 0.1)
                            }, completion: { (isFinish) in
                                self.mainBackgroundView.removeFromSuperview()
                        })
                })
                
            }else{
                self.mainBackgroundView.removeFromSuperview()
            }
            
        }
        else if hudType == .Progress
        {
            self.mainBackgroundView.removeFromSuperview()
        }
        
    }
    
    func hidHudViewAfterDelay(delay: NSTimeInterval, animated: Bool) {
        if hiddenTimer != nil{
            hiddenTimer?.invalidate()
            hiddenTimer = nil
        }
        
        hiddenTimer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(PMHubView.hidHudView), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(hiddenTimer!, forMode: NSRunLoopCommonModes)
    }
    
    // MARK: - CreateUI
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit{
        for keypath in keypaths {
            removeObserver(self, forKeyPath: keypath)
        }
        
    }
}


extension String{
    func heightOfText(size: CGSize, font: UIFont) -> CGRect {
       let rect = (self as NSString).boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return rect
    }
}
