//
//  PMPlayVideoViewController.swift
//  PMLefe
//
//  Created by wsy on 16/1/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

private var playerViewControllerKVOContext = 0

class PMPlayVideoViewController: PMBaseController {

    var player: AVPlayer!
    var playerView: PMPalyerView!
    var playerLayer: AVPlayerLayer!
    var bottomStateView: PMVideoStateView!
    var isShowBottomView: Bool = false
    var bottomContraint: NSLayoutConstraint!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let assetUrl: NSURL = NSBundle.mainBundle().URLForResource("templateYouMeng", withExtension: "mp4")!

        print("Video url \(assetUrl)")
        
        let asset = AVAsset(URL: assetUrl)
        let assetItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: assetItem)
        
        playerView = PMPalyerView()
        playerView.playerLayer.player = self.player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playerView)
        configPlayViewData()
        createUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.player.play()
        
        addObserver(self, forKeyPath: "navigationController.navigationBarHidden", options: [.New, .Initial], context: &playerViewControllerKVOContext)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
        self.player.pause()
        removeObserver(self, forKeyPath: "navigationController.navigationBarHidden", context: &playerViewControllerKVOContext)
    }
    
    // MARK: - configure
    func configPlayViewData(){
        self.title = "视频"
        self.playerView.pmautoPinEdgeToSuperViewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.hidesBarsOnTap = true
    }
    
    // MARK: - delegate
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        isShowBottomView = !isShowBottomView
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            if self.bottomContraint != nil{
                if self.isShowBottomView{
                    self.bottomContraint.constant = 44
                }else{
                    self.bottomContraint.constant = 0
                }
            }
            self.view.layoutIfNeeded()
        })

    }
    
    // MARK: - createUI
    func createUI(){
//        createBottonView()
    }
    
    func createBottonView(){
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        bottomStateView = PMVideoStateView(frame: rect)
        bottomStateView.leftTime = "0:00"
        bottomStateView.rightTime = "01:30"
        self.view.addSubview(bottomStateView)
        bottomStateView.pmautoPinExcludeEdgeToSuperViewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludeEdge: NSLayoutAttribute.Top)
        bottomContraint = bottomStateView.pmautoSetSize(NSLayoutAttribute.Height, withSize: 0)

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("kvo\(keyPath)")
    }
    
}
