//
//  PMTabBarController.swift
//  PMLefe
//
//  Created by wsy on 16/3/6.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RxCocoa

class PMTabBarController: UITabBarController {
    
    private struct TabItem {
        var title: String
        var commonImage: String
        var selectedImage: String
    }
    
    private enum TabBarType: Int {
        case Recent
        case AddMore
        case My
        
        var tabItem: TabItem {
            switch self{
            case .Recent:
                return TabItem(title: NSLocalizedString("se_lastest", comment: ""), commonImage: "home_last_un", selectedImage: "home_last")
            case .AddMore:
                return TabItem(title: "", commonImage: "add_more", selectedImage: "add_more")
            case .My:
                return TabItem(title: NSLocalizedString("se_me", comment: ""), commonImage: "home_me_un", selectedImage: "home_me")
            }
        }
    }
    
    var popMenuView: PMPopMenuView!
    
    override func awakeFromNib() {
        self.tabBar.translucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = PMUIContraint.defaultTextColor()
        view.backgroundColor = UIColor.whiteColor()
        
        changeSelectedImage()
        addMinddleView()
        
        createPopMenuView()

        self.registeNotification()
    }
    
    
   private func changeSelectedImage(){
        if let items = tabBar.items{
            for i in 0..<items.count{
                let item = items[i]
                let itemData = TabBarType(rawValue: i)
                item.selectedImage = UIImage(named: (itemData?.tabItem.selectedImage)!)?.imageWithRenderingMode(.AlwaysOriginal)
                if i == 1{
                    item.enabled = false
                }
            }
        }
    }
    
    private func addMinddleView(){
        let view = UIButton(type: .Custom)
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        view.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: 25)
        view.setImage(UIImage(named: "home_add"), forState: .Normal)
        view.addTarget(self, action: #selector(PMTabBarController.addMoreViewClick), forControlEvents: .TouchUpInside)
        tabBar.addSubview(view)
    }
    
    private func createPopMenuView(){
        
        popMenuView = PMPopMenuView(frame: UIScreen.mainScreen().bounds)
        popMenuView.delegate = self
        self.view.addSubview(popMenuView)
    }
    
    
    func addMoreViewClick(){
        print("add more")
        self.view.bringSubviewToFront(popMenuView)
        popMenuView.showPopMenuView()

    }
    
    private func getViewControllerFromStoryboardWithIndentifier(indentifier: String, storyBoardType: String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyBoardType, bundle: NSBundle.mainBundle())
        let viewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier(indentifier)
        return viewController
    }
}

extension PMTabBarController: PMPopMenuViewDelgate{
    func popMenuViewCickedWithIndex(index: Int, popView: PMPopMenuView) {
        // 相册
        if index == 0{
            let photoVC = getViewControllerFromStoryboardWithIndentifier("PMAlbumController", storyBoardType: PMUIContraint.kPhotoStoryboard)
            let nav = PMBaseNavController(rootViewController: photoVC)
            self.presentViewController(nav, animated: true, completion: nil)
        }
        // 视频
        else if index == 1
        {
            let imagePickerVC = PMVideoPickerController()
            let nav = PMBaseNavController(rootViewController: imagePickerVC)
            self.presentViewController(nav, animated: true, completion: nil)
        }
        // 笔记
        else if index == 2
        {
            let addNoteVC = PMAddNoteController()
            let nav = PMBaseNavController(rootViewController: addNoteVC)
            self.presentViewController(nav, animated: true, completion: nil)
        }
        // Audio
        else if index == 3
        {
            let audioVC = getViewControllerFromStoryboardWithIndentifier("PMAudioRecordController", storyBoardType: PMUIContraint.kMainStoryboard)
            audioVC.title = popView.titles[index]
            let nav = PMBaseNavController(rootViewController: audioVC)
            self.presentViewController(nav, animated: true, completion: nil)

        }
        // Collection
        else if index == 4
        {
            let addCollectionVC = PMAddCollectionController()
            self.presentViewController(addCollectionVC, animated: true, completion: nil)
        }
        // Cammera
        else
        {
            let imagePickerVC = PMIMagePickerController()
            imagePickerVC.sourceType = .Camera
            self.presentViewController(imagePickerVC, animated: true, completion: nil)
            let _ = imagePickerVC.rx_didCancel.subscribeNext({ (_) in
                imagePickerVC.dismissViewControllerAnimated(true, completion: nil)
                print("Cammer cancel")
            })
            
            let _ = imagePickerVC.rx_didFinishPickingMediaWithInfo.subscribeNext({ (info) in
                imagePickerVC.dismissViewControllerAnimated(true, completion: nil)
                print("Cammer finish \(info)")
            })
        }
       
    }
}

extension PMTabBarController{
    func registeNotification(){
        NSNotificationCenter.defaultCenter().addObserverForName(PMConstant.kNotificationFontChange, object: nil, queue: nil) {[weak self] (_) -> Void in
            self?.popMenuView.changeTitleFont()
        }
    }
}