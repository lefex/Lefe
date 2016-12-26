//
//  PMMeController.swift
//  PMLefe
//
//  Created by wsy on 16/3/6.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let indentifier = "PMProfileCell"

public struct DataMessage {
    var icon: String
    var name: String
}

class PMMeController: PMBaseController {
    
    @IBOutlet weak var tableView: UITableView!

    var firstSection: [DataMessage] = []
    var secondSection: [DataMessage] = []
    var controllers: [String] = ["PMSettingController"]

    // 设置

    func loadData(){
        let data0 = DataMessage(icon: "me_video", name: NSLocalizedString("pm_videos", comment: ""))
        firstSection.append(data0)
        let data1 = DataMessage(icon: "me_voice", name: NSLocalizedString("pm_audio", comment: ""))
        firstSection.append(data1)
        let data2 = DataMessage(icon: "me_book", name: NSLocalizedString("pm_note", comment: ""))
        firstSection.append(data2)
        let data3 = DataMessage(icon: "me_photo", name: NSLocalizedString("pm_photos", comment: ""))
        firstSection.append(data3)
        let data4 = DataMessage(icon: "me_privacy", name: NSLocalizedString("pm_password", comment: ""))
        firstSection.append(data4)
        
        let data5 = DataMessage(icon: "me_setting", name: NSLocalizedString("se_setting", comment: ""))
        secondSection.append(data5)
        let data6 = DataMessage(icon: "me_about", name: NSLocalizedString("se_about", comment: ""))
        secondSection.append(data6)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(PMProfileCell.self, forCellReuseIdentifier: indentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = PMUIContraint.defaultTableColor()
        title = NSLocalizedString("se_me", comment: "")
        loadData()
        
        registeNotification()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hidesBottomBarWhenPushed = false
    }
    
    func registeNotification(){
        NSNotificationCenter.defaultCenter().addObserverForName(PMConstant.kNotificationFontChange, object: nil, queue: nil) {[weak self] (_) -> Void in
            self?.tableView.reloadData()
        }
    }

}

extension PMMeController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return firstSection.count
        }else{
            return secondSection.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PMProfileCell = tableView.dequeueReusableCellWithIdentifier(indentifier) as! PMProfileCell
        if indexPath.section == 0{
            cell.configureData(firstSection[indexPath.row], indexPath: indexPath)
        }else{
            cell.configureData(secondSection[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Setting
        if indexPath.row == 0 && indexPath.section == 1
        {
            let settingVC = self.getViewControllerFromStoryboardWithIndentifier("PMSettingController", storyBoardType: PMUIContraint.kSettingStoryboard)
            settingVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(settingVC, animated: true)
        }
        // About
        else if indexPath.row == 1 && indexPath.section == 1
        {
            let aboutVC = PMAboutController()
            aboutVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(aboutVC, animated: true)
        }
        // 相册
        else if indexPath.row == 3 && indexPath.section == 0{
            let photoVC = getViewControllerFromStoryboardWithIndentifier("PMAlbumController", storyBoardType: PMUIContraint.kPhotoStoryboard) as! PMAlbumController
            photoVC.hidesBottomBarWhenPushed = true
            photoVC.jumpType = AlbumJumpType.List
            navigationController?.pushViewController(photoVC, animated: true)
        }
        // 视频
        else if indexPath.row == 0 && indexPath.section == 0
        {
            let videoListVC = PMVideoListViewController()
            videoListVC.hidesBottomBarWhenPushed = true
            videoListVC.jumpType = VideoJumpType.List
            navigationController?.pushViewController(videoListVC, animated: true)
        }
        // 笔记
        else if indexPath.row == 2 && indexPath.section == 0
        {
            let noteVC = PMNoteController()
            noteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(noteVC, animated: true)
        }
        // Audio
        else if indexPath.row == 1 && indexPath.section == 0
        {
            let audioListVC = self.getViewControllerFromStoryboardWithIndentifier("PMAudioController", storyBoardType: PMUIContraint.kMainStoryboard)
            audioListVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(audioListVC, animated: true)
            
        }
        // Collection
        else if indexPath.row == 4 && indexPath.section == 0
        {
            let addCollectionVC = PMCollectionListController()
            addCollectionVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(addCollectionVC, animated: true)
        }


    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

