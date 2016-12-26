//
//  PMAlbumController.swift
//  PMLefe
//
//  Created by wsy on 16/4/7.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Photos

private let indentifier = "PMAlbumCell"
private let kMaxTextNum = 20

enum AlbumJumpType: Int {
    case Add = 0
    case List = 1
}

class PMAlbumController: PMBaseController {

    @IBOutlet weak var tableView: UITableView!
    
    var albums: Results<Album>!
    
    let realm = try! Realm()
    
    var jumpType: AlbumJumpType = .Add
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load data
        loadAlbums()
        
        title = NSLocalizedString("ph_album", comment: "")
        tableView.backgroundColor = PMUIContraint.defaultTableColor()
        tableView.registerClass(PMAlbumCell.self, forCellReuseIdentifier: indentifier)
        
        if jumpType == .Add {
            setLeftItemImage("pm_cancel")
            setRightItemImage("pm_add_item")
        }
    }
    
    private func loadAlbums(){
        albums = realm.objects(Album).sorted("date", ascending: false)
        if albums.count == 0 {
            let rect = CGRect(x: 0, y: 0, width: view.width, height: view.height - 64.0)
            let emptyView = PMEmptyTextView(frame: rect)
            
            emptyView.configureEmptyView(NSLocalizedString("ph_no_photo", comment: ""), contentText: NSLocalizedString("ph_add_photo", comment: ""))
            tableView.tableFooterView = emptyView
            
        }else{
            tableView.tableFooterView = UIView()
        }
    }
    
    // Action
    override func didClickRightItem() {
        let placeHolder =  "\(NSLocalizedString("ph_max_album_name", comment: ""))\(kMaxTextNum) \(NSLocalizedString("ph_max_album_name2", comment: ""))"

        let alert = UIAlertController(title: nil, message: NSLocalizedString("ph_please_input_album_name", comment: ""), preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = placeHolder
            textField.clearButtonMode = .WhileEditing
            
            _ = textField.rx_text.subscribeNext({ (text) -> Void in
                if text.pm_length > kMaxTextNum{
                    let index = text.startIndex.advancedBy(kMaxTextNum)
                    textField.text = text.substringToIndex(index)
                    alert.message = placeHolder
                }
            })
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: {(_) -> Void in
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("pm_ok", comment: ""), style: UIAlertActionStyle.Destructive, handler: {(_) -> Void in
            
            func saveToAlbum(name: String){
                // Save to database
                if let aAlbum = self.realm.objects(Album).filter("name='\(name)'").first{
                    // Have exist
                    print("album have exist \(aAlbum)")
                }else{
                    LefeDB.write({[weak self] in
                        let aAlbum = Album()
                        aAlbum.name = name
                        self?.realm.add(aAlbum)
                        
                        self?.loadAlbums()
                        self?.tableView.reloadData()
                    })
                }
            }
            
            
            if let albumName = alert.textFields?.first?.text{
                if albumName.isEmpty{
                    
                }else{
                    saveToAlbum(albumName)
                }
            }else{
                
            }
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didClickLeftItem() {
        if jumpType == .Add {
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            navigationController?.popViewControllerAnimated(true)
        }
    }

}

extension PMAlbumController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(indentifier) as! PMAlbumCell
        cell.accessoryType = .DisclosureIndicator
        cell.configureAlbumData(albums[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let aAlbum = albums[indexPath.row]
        if aAlbum.photosCount == 0 {
            let pickerPhotosVC = PMAlbumPickController()
            let nav = PMBaseNavController(rootViewController: pickerPhotosVC)
            var coverData: NSData?
            
            autoreleasepool({
                
                dispatch_async(dispatch_get_global_queue(0, 0), {
                    

                    pickerPhotosVC.okAction = { phasets in
                        var hudView: PMHubView!

                        dispatch_async(dispatch_get_main_queue(), {
                            hudView = PMHubView.showInView(self.view, type: PMHudViewType.Progress)
                        })
                        
                        // Create loacl image directory
                        let imageRootPath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(aAlbum.name)
                        if !NSFileManager.defaultManager().fileExistsAtPath(imageRootPath) {
                            let _ = try? NSFileManager.defaultManager().createDirectoryAtPath(imageRootPath, withIntermediateDirectories: true, attributes: nil)
                        }
                        
                        // Create loacl thumb image directory
                        let imageThumbRootPath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(PMUIContraint.kThumbName + aAlbum.name)
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
                                    if coverData == nil{
                                        coverData = data
                                    }
                                    let filePath = imageRootPath.stringByAppendingPathComponent(aAset.localIdentifier.PM_MD5 + ".jpg")
                                    NSFileManager.defaultManager().createFileAtPath(filePath, contents: data, attributes: nil)
                                }
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), { 
                                let porgress: CGFloat = CGFloat(readCound) / CGFloat(phasets.count)
                                hudView.progress = porgress
                            })
                            
                        }
                        
                        LefeDB.write({[weak self] in
                            aAlbum.photosCount = phasets.count
                            aAlbum.cover = coverData
                            self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                            hudView.hidHudViewWithAnimated(true)

                        })
                        
                    }
                })
                
            })
            

            presentViewController(nav, animated: true, completion: nil)
        }
        else
        {
            let albumList = PMAlbumListController()
            albumList.album = aAlbum
            if aAlbum.pwd.isEmpty{
                navigationController?.pushViewController(albumList, animated: true)
            }else{
                // Have pwd
                let pwdVC = PMPwdController()
                pwdVC.pwdType = PMPwdType.Verify
                pwdVC.firstPwd = aAlbum.pwd
                pwdVC.finishComplete = { [weak self] pwd in
                    self?.navigationController?.pushViewController(albumList, animated: true)
                }
                let nav = PMBaseNavController(rootViewController: pwdVC)
                presentViewController(nav, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete local album
            let alert = UIAlertController.pm_showWithMessage(NSLocalizedString("ph_delete_album_alert", comment: ""), completion: {[weak self] (index) -> (Void) in
                if index == 1{
                    let album = self?.albums[indexPath.row]
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        try! self?.realm .write({
                            self?.realm.delete(album!)
                            self?.loadAlbums()
                            self?.tableView.reloadData()
                        })
                    })

                }
            })
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }

}

