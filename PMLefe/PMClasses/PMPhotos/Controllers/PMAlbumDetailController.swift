//
//  PMAlbumDetailController.swift
//  PMLefe
//
//  Created by wsy on 16/6/4.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RxCocoa
import Photos

private let kAlbumDetailIdentifier = "kAlbumDetailIdentifier"

private enum AlbumSectionType: Int {
    case SetPwd = 0
    case AllOutput = 1
    case CustomOutput = 2
    case Add = 3
    case Delete = 4
    case SaveToCloud = 5
    case Detail = 6
    

    var sectionName: String {
        switch self {
        case .SetPwd: return NSLocalizedString("pa_pwd", comment: "")
        
        case .AllOutput: return NSLocalizedString("ph_all_output", comment: "")
        case .CustomOutput: return NSLocalizedString("ph_custom_output", comment: "")
            
        case .Add: return NSLocalizedString("ph_add", comment: "")
        case .Delete: return NSLocalizedString("ph_delete", comment: "")
            
        case .SaveToCloud: return NSLocalizedString("ph_save_to_cloud", comment: "")
        case .Detail: return NSLocalizedString("ph_detail", comment: "")
            
        }
    }
    
    static func cellTyoe(indexPath: NSIndexPath) -> AlbumSectionType {
        
        if indexPath.section == 0 && indexPath.row == 0
        {
            return AlbumSectionType.SetPwd
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                return AlbumSectionType.AllOutput
            }
            else if indexPath.row == 1
            {
                return AlbumSectionType.CustomOutput

            }
            else if indexPath.row == 2
            {
                return AlbumSectionType.Add
            }
            else
            {
                return AlbumSectionType.Delete
            }
        }
        else if indexPath.section == 2
        {
             return AlbumSectionType.SaveToCloud
        }
        else
        {
            return AlbumSectionType.Detail
        }
    }
}

class PMAlbumDetailController: PMBaseController {

    var tableView: UITableView!
    
    internal var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ph_detail", comment: "")
        
        makeUI()
    }
    
    // MARK: CrateUI
    private func makeUI(){
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = PMUIContraint.defaultTableColor()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kAlbumDetailIdentifier)
        
        view.addSubview(tableView)
        
        createFooterView()
    }
    
    private func createFooterView(){
        let headerHeight: CGFloat = 100.0
        let bgView = UIView(frame: CGRectMake(0, 0, view.width, headerHeight))
        
        let deleteButton = UIButton(type: .Custom)
        deleteButton.frame = CGRectMake(30, (headerHeight - 40) / 2.0, view.width - 60, 40)
        deleteButton.titleLabel?.font = PMUIContraint.fontWithName(16)
        deleteButton.setTitle(NSLocalizedString("ph_delete_album", comment: ""), forState: .Normal)
        deleteButton.setBackgroundImage(UIImage(named: "ph_delete_redbg"), forState: .Normal)
        let _ = deleteButton.rx_tap.subscribeNext({ (_) in
            
            // Alert
           let alert = UIAlertController.pm_showWithMessage(NSLocalizedString("ph_delete_album_alert", comment: ""), completion: { (index) -> (Void) in
                if index == 1{
                    // Delete album
                }
            })
            self.presentViewController(alert, animated: true, completion: nil)
        })
        bgView.addSubview(deleteButton)
        
        tableView.tableFooterView = bgView
        
    }

}

extension PMAlbumDetailController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 4
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kAlbumDetailIdentifier)
        cell?.accessoryType = .DisclosureIndicator
        
        let cellType = AlbumSectionType.cellTyoe(indexPath)
        cell?.textLabel?.text = cellType.sectionName
        cell?.textLabel?.font = PMUIContraint.kFont
        return cell!
    }
    
}

extension PMAlbumDetailController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cellType = AlbumSectionType.cellTyoe(indexPath)
        switch cellType {
        case .SetPwd:
            
            let alert = UIAlertController(title: nil, message:  nil, preferredStyle: .ActionSheet)
            
            if self.album?.pwd.pm_length > 0 {
                let setAction = UIAlertAction(title: NSLocalizedString("se_close_pwd", comment: ""), style: .Destructive, handler: { (action) in
                    // 设置密码
                    let setPwdVC = PMPwdController()
                    setPwdVC.pwdType = PMPwdType.Verify
                    setPwdVC.firstPwd = self.album!.pwd
                    setPwdVC.finishComplete = { password in
                        LefeDB.write({
                            self.album?.pwd = ""
                        })
                        
                        setPwdVC.dismissViewControllerAnimated(true, completion: nil)
                    }
                    let nav = PMBaseNavController(rootViewController: setPwdVC)
                    self.presentViewController(nav, animated: true, completion: nil)
                    
                })
                alert.addAction(setAction)
            }
            else
            {
                let setAction = UIAlertAction(title: NSLocalizedString("ph_setPwd", comment: ""), style: .Destructive, handler: { (action) in
                    // 设置密码
                    let setPwdVC = PMPwdController()
                    setPwdVC.pwdType = PMPwdType.Setting
                    setPwdVC.finishComplete = { password in
                        LefeDB.write({
                            self.album?.pwd = password
                        })
                        
                        setPwdVC.dismissViewControllerAnimated(true, completion: nil)
                    }
                    let nav = PMBaseNavController(rootViewController: setPwdVC)
                    self.presentViewController(nav, animated: true, completion: nil)
                    
                })
                alert.addAction(setAction)
                
                if let pwd = PMUserDefault.pm_stringValueForKey(PMStartPwdKey){
                    // 使用启动密码
                    let setAction = UIAlertAction(title: NSLocalizedString("no_use_start_pwd", comment: ""), style: .Destructive, handler: { (action) in
                        
                        LefeDB.write({
                            self.album?.pwd = pwd
                        })
                    })
                    alert.addAction(setAction)
                }
            }
            
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: .Cancel, handler: { (action) in
                
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            /*
            let pwdVC = PMPwdController()
            if  album!.pwd.isEmpty{
                pwdVC.pwdType = PMPwdType.Setting
            }else{
                pwdVC.pwdType = PMPwdType.Change
                pwdVC.oldPwd = album!.pwd
            }
            pwdVC.finishComplete = { password in
                LefeDB.write({ [weak self] in
                    self?.album?.pwd = password
                })
                
                pwdVC.dismissViewControllerAnimated(true, completion: nil)
            }
            let nav = PMBaseNavController(rootViewController: pwdVC)
            self.presentViewController(nav, animated: true, completion: nil)
           */
            
        case .AllOutput:
            outPutToAlbum(nil)
            
        case .CustomOutput:
            
            let albumVC = PMAlbumListController()
            albumVC.isEditModel = true
            albumVC.okAction = { names in
                self.outPutToAlbum(names)
            }
            albumVC.album = self.album
            navigationController?.pushViewController(albumVC, animated: true)
            
        case .Add:
            let pickerPhotosVC = PMAlbumPickController()
            let nav = PMBaseNavController(rootViewController: pickerPhotosVC)
            pickerPhotosVC.okAction = { alasets in
                self.addPhotosToAlbum(alasets)
            }
            self.presentViewController(nav, animated: true, completion: nil)
            
        case .Delete:
            let albumVC = PMAlbumListController()
            albumVC.isEditModel = true
            albumVC.okAction = { names in
                self.deleteAlbum(names)
            }
            albumVC.album = self.album
            navigationController?.pushViewController(albumVC, animated: true)

            
        case .Detail:
            let albumContentVC = PMAlbumContentController()
            albumContentVC.album = self.album
            navigationController?.pushViewController(albumContentVC, animated: true)
            
        default: break
            
        }

    }
    
    // 删除照片
    func deleteAlbum(names: Array<String>) {
        let alert = UIAlertController.pm_showWithMessage(NSLocalizedString("ph_delete_photos", comment: "")) { (index) -> (Void) in
            if index == 1{
                let imageRootPath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(self.album!.name)
                let imageThumbRootPath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(PMUIContraint.kThumbName + self.album!.name)
                
                for fileName in names{
                    let imagePath = imageRootPath.stringByAppendingPathComponent(fileName)
                    let _ = try? NSFileManager.defaultManager().removeItemAtPath(imagePath)
                    
                    let thumbPath = imageThumbRootPath.stringByAppendingPathComponent(fileName)
                    let _ = try? NSFileManager.defaultManager().removeItemAtPath(thumbPath)
                }
                
                let hudView = PMHubView.showInView(self.view, type: PMHudViewType.Text)
                hudView.labelText = NSLocalizedString("ph_delete_success", comment: "")
                hudView.hidHudViewAfterDelay(1.0, animated: true)
                
                PMLefe.pm_lefeSafeMainThread({ 
                    NSNotificationCenter.defaultCenter().postNotificationName(PMConstant.kNotificationReloadAlbumList, object: nil)
                })
            }
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // 导出相片到手机相册
    func outPutToAlbum(names: Array<String>?)
    { //

        var msg: String = NSLocalizedString("ph_output_part_to_albums", comment: "")
        if names == nil{
            msg = NSLocalizedString("ph_output_all_to_albums", comment: "")
        }
        
        let alert = UIAlertController.pm_showWithMessage(msg) { (selectIndex) -> (Void) in
            if selectIndex == 1{
                
                let filePath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(self.album!.name)
                let hudView = PMHubView.showInView(self.view, type: PMHudViewType.Progress)
                var index = 0
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                    
                    do {
                        var dataArray: Array<String>
                        if names == nil{
                            dataArray = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(filePath)
                        }else{
                            dataArray = names!
                        }

                        for fileName in dataArray{
                            index += 1
                            let image = UIImage(contentsOfFile: filePath.stringByAppendingPathComponent(fileName))
                            if let aImage = image{
                                UIImageWriteToSavedPhotosAlbum(aImage, nil, nil, nil)
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                let count = dataArray.count
                                let progress: CGFloat = CGFloat(index) / CGFloat(count)
                                hudView.progress = progress
                                
                                if index == count{
                                    hudView.hidHudViewAfterDelay(1.0, animated: true)
                                }
                            })
                        }
                        
                    }catch let error as NSError{
                        print(error.localizedDescription)
                    }
                })

            }
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }//
    
    // 添加照片到相册中
    func addPhotosToAlbum(phasets: Array<PHAsset>) {
        var hudView: PMHubView!
        hudView = PMHubView.showInView(self.view, type: PMHudViewType.Progress)
        let imageRootPath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(self.album!.name)
        let imageThumbRootPath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(PMUIContraint.kThumbName + self.album!.name)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            // Create loacl image directory
            if !NSFileManager.defaultManager().fileExistsAtPath(imageRootPath) {
                let _ = try? NSFileManager.defaultManager().createDirectoryAtPath(imageRootPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Create loacl thumb image directory
            if !NSFileManager.defaultManager().fileExistsAtPath(imageThumbRootPath) {
                let _ = try? NSFileManager.defaultManager().createDirectoryAtPath(imageThumbRootPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Save photo to local
            let imageOption = PHImageRequestOptions()
            imageOption.synchronous = true
            imageOption.networkAccessAllowed = false
            
            var readCound = 0
            
            for aAset in phasets {
                readCound += 1
                // Thumb image`
                let _ = PHImageManager.defaultManager().requestImageForAsset(aAset, targetSize: PMUIContraint.kThumbSize, contentMode: PHImageContentMode.Default, options: imageOption) { (image, imageInfo) in
                    if let aImage = image{
                        let data = UIImageJPEGRepresentation(aImage, 1.0)
                        let filePath = imageThumbRootPath.stringByAppendingPathComponent(aAset.localIdentifier.PM_MD5 + ".jpg")
                        NSFileManager.defaultManager().createFileAtPath(filePath, contents: data, attributes: nil)
                    }
                }
                
                
                // Source image
                let _ = PHImageManager.defaultManager().requestImageForAsset(aAset, targetSize: PMUIContraint.kPhotoSize, contentMode: PHImageContentMode.Default, options: imageOption) { (image, imageInfo) in
                    if let aImage = image{
                        let data = UIImageJPEGRepresentation(aImage, 1.0)
                        let filePath = imageRootPath.stringByAppendingPathComponent(aAset.localIdentifier.PM_MD5 + ".jpg")
                        NSFileManager.defaultManager().createFileAtPath(filePath, contents: data, attributes: nil)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    let count = phasets.count
                    let porgress: CGFloat = CGFloat(readCound) / CGFloat(count)
                    hudView.progress = porgress
                    if readCound == count{
                        hudView.hidHudViewAfterDelay(1.0, animated: true)
                        
                         NSNotificationCenter.defaultCenter().postNotificationName(PMConstant.kNotificationReloadAlbumList, object: nil)
                    }
                })
                
            }

        }
        
    }

}
