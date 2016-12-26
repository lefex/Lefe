//
//  PMVideoPickerController.swift
//  PMLefe
//
//  Created by wsy on 16/7/11.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import RealmSwift

private let kThumbImageSize: CGFloat = 100
private let KCollectionEditIdentifier = "KCollectionEditIdentifier"



class PMVideoPickerController: PMBaseController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    internal var okAction: ((Array<String>) -> ())?
    
    var fetchResult: PHFetchResult!
    var selectedAssets: Array<PHAsset> = Array()
    var flagKey: Dictionary<String, String> = Dictionary()
    
    
    // MARK: - ViewController life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFistData()
       
        createAlbumCollectivew()
        
        _loadAllVideo()
    }
    
    func configureFistData() {
        title = NSLocalizedString("pm_videos", comment: "")
        self.setRightItemTitle(NSLocalizedString("pm_ok", comment: ""))
        setLeftItemImage("pm_cancel")
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: - Action
    override func didClickRightItem() {
        
        if self.selectedAssets.count == 0{
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        let imageManager = PHImageManager.defaultManager()
        let option = PHVideoRequestOptions()
        option.networkAccessAllowed = false
        
        let videoRootPath = PMLocalFileManager.videoRootPath
        let realm = try! Realm()
        
        let hudView = PMHubView.showInView(self.view, type: PMHudViewType.Progress)
    
        var index = 0
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            
            guard let wself = self else{
                return
            }
            
            for aAlset in wself.selectedAssets{
                index += 1
                
                imageManager.requestAVAssetForVideo(aAlset, options: option, resultHandler: { (videoAsset, audioMix, info) in
                    
                    if let aVideo = videoAsset as? AVURLAsset{
                        let videoUrl = aVideo.URL
                        
                        let videoPath = videoRootPath.stringByAppendingPathComponent(videoUrl.lastPathComponent ?? "")
                        let localVideoUrl = NSURL.fileURLWithPath(videoPath)
                        
                        do {
                            try NSFileManager.defaultManager().copyItemAtURL(videoUrl, toURL: localVideoUrl)
                            
                            // Save to db
                            LefeDB.write({[weak self] in
                                let video = Video()
                                video.filePath = videoUrl.lastPathComponent ?? ""
                                if let aImage = self?.generateThumbnailForVideoAtURL(videoUrl){
                                    video.cover = UIImageJPEGRepresentation(aImage, 0.8)
                                }
                                realm.add(video)
                                })
                            
                        }catch let error as NSError{
                            print(error.localizedDescription)
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let progress: CGFloat = CGFloat(index) / CGFloat(wself.selectedAssets.count)
                            hudView.progress = progress
                            if index == wself.selectedAssets.count{
                                hudView.hidHudViewWithAnimated(true)
                                wself.dismissViewControllerAnimated(true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func generateThumbnailForVideoAtURL(videoURL: NSURL) -> UIImage?{
        let urlAsset = AVURLAsset(URL: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: urlAsset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do{
           let imageRef = try imageGenerator.copyCGImageAtTime(kCMTimeZero, actualTime: nil)
            return UIImage(CGImage: imageRef)
        }catch let error as NSError{
            print("copy image error: \(error.localizedDescription)")
        }

        return nil
    }
    
    override func didClickLeftItem() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:  - Propety
    private let kColumsCount = 4;
    private let kItemMinSpace: CGFloat = 5.0;
    
    
    var ablumCollectivew: UICollectionView!
    
    
    var cellWidth: CGFloat{
        get {
            return (CGRectGetWidth(self.view.bounds) - (CGFloat(kColumsCount + 1) * kItemMinSpace)) / CGFloat(kColumsCount)
            
        }
    }
    
    
    // MARK: - Load data
    func _loadAllVideo(){
        fetchResult = PMAlbum.queryAllVideos()
        ablumCollectivew.reloadData()
    }
    
    // MARK: createUI
    func createAlbumCollectivew(){
        let rect = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        viewLayout.minimumInteritemSpacing = kItemMinSpace
        viewLayout.minimumLineSpacing = kItemMinSpace
        ablumCollectivew  = UICollectionView(frame: rect, collectionViewLayout: viewLayout)
        ablumCollectivew.dataSource = self
        ablumCollectivew.delegate = self
        ablumCollectivew.alwaysBounceVertical = true
        ablumCollectivew.backgroundColor = UIColor.whiteColor()
         ablumCollectivew .registerClass(PMAlbumPickCollectionCell.self, forCellWithReuseIdentifier: KCollectionEditIdentifier)
        
        self.view.addSubview(ablumCollectivew)
        ablumCollectivew.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: PMAlbumPickCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(KCollectionEditIdentifier, forIndexPath: indexPath) as! PMAlbumPickCollectionCell
        
        guard let item = fetchResult.objectAtIndex(indexPath.row) as? PHAsset else{
            return cell
        }
        cell.loacelIndentifier = item.localIdentifier
        
        // Click action
        cell.selectAction = { [weak self] isSelected in
            if isSelected{
                self?.selectedAssets.append(item)
                self?.flagKey[item.localIdentifier] = item.localIdentifier
                
            }else{
                self?.flagKey.removeValueForKey(item.localIdentifier)
                self?.selectedAssets.removeAtIndex((self?.selectedAssets.indexOf(item))!)
                
            }
            
            if let count = self?.selectedAssets.count{
                self?.setRightItemTitle(NSLocalizedString("pm_ok", comment: "") + "(\(count))")
            }
        }
        
        // Get image
        let imageOption = PHImageRequestOptions()
        imageOption.networkAccessAllowed = false
        let _ = PHImageManager.defaultManager().requestImageForAsset(item, targetSize: PMUIContraint.kThumbSize, contentMode: PHImageContentMode.Default, options: imageOption) { (image, imageInfo) in
            if let aImage = image{
                dispatch_async(dispatch_get_main_queue(), {
                    if let imageIndentifier = cell.loacelIndentifier{
                        if imageIndentifier == item.localIdentifier{
                            cell.configurAlbumPickCollectionCelleData(aImage, isSelect: self.flagKey[item.localIdentifier] != nil)
                        }
                    }
                })
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = cellWidth
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kItemMinSpace, kItemMinSpace, kItemMinSpace, kItemMinSpace)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
    }
    
}

