//
//  PMVideoListViewController.swift
//  PMLefe
//
//  Created by wsy on 16/6/9.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import AVFoundation
import AVKit

enum VideoJumpType: Int{
    case Add = 0
    case List = 1
}

class PMVideoListViewController: PMBaseController, UICollectionViewDataSource, UICollectionViewDelegate, PMVideoLayoutDelegate {
    
    var collectivew: UICollectionView!
    var jumpType: VideoJumpType = .Add
    
    var heightCache: Dictionary<String, CGFloat> = Dictionary()
    
    var videos: Results<Video>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectivew()
        
        title = NSLocalizedString("pm_videos", comment: "")
        if jumpType == .Add {
            setRightItemImage("pm_add_item")
        }
        
        loadVideos()
    }
    
    // Load data
    private func loadVideos(){
        videos = realm.objects(Video).sorted("date", ascending: false)
        collectivew.reloadData()
    }
    
    // MARL: Action
    override func didClickLeftItem() {
        if jumpType == .Add {
            dismissViewControllerAnimated(true, completion: nil)

        }else{
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func didClickRightItem() {
        
    }
    
    // MARK: CreateUI
    func createCollectivew(){
        let rect = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let viewLayout = PMVideoCollectionLayout()
        viewLayout.delegate = self
        collectivew = UICollectionView(frame: rect, collectionViewLayout: viewLayout)
        collectivew.dataSource = self
        collectivew.delegate = self
        collectivew.alwaysBounceVertical = true
        collectivew.allowsMultipleSelection = true
        collectivew.backgroundColor = PMUIContraint.defaultTableColor()
        collectivew .registerClass(PMVideoListCCell.self, forCellWithReuseIdentifier: "ID")
        self.view.addSubview(collectivew)
        collectivew.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PMVideoListCCell = collectivew.dequeueReusableCellWithReuseIdentifier("ID", forIndexPath: indexPath) as! PMVideoListCCell
        cell.configureVideo(videos[indexPath.item])
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let aVideo = videos[indexPath.item]
        let filePath = PMLocalFileManager.videoRootPath.stringByAppendingPathComponent(aVideo.filePath)
        let fileUrl = NSURL.fileURLWithPath(filePath)
        let avPlayer = AVPlayer(URL: fileUrl)
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = avPlayer
        presentViewController(videoPlayer, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat {
        
        let video = videos[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: withWidth, height: CGFloat(MAXFLOAT))
        
        var aImage = PMUIContraint.defaultVideoImage()
        if let data = video.cover{
            if let image = UIImage(data: data){
                aImage = image
            }
        }
        
        if let aHeight = heightCache[video.videoId]{
            return aHeight
        }else{
            let rect  = AVMakeRectWithAspectRatioInsideRect(aImage.size, boundingRect)
            heightCache[video.videoId] = rect.size.height
            return rect.size.height
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        print(action)
    }
    
}

