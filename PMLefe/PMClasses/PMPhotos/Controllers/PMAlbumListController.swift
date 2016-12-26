//
//  PMAlbumListController.swift
//  PMLefe
//
//  Created by wsy on 16/6/19.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let kThumbImageSize: CGFloat = 100
private let KCollectionIdentifier = "collectionIdentifier"
private let KCollectionEditIdentifier = "KCollectionEditIdentifier"



class PMAlbumListController: PMBaseController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    internal var album: Album?
    internal var isEditModel = false // 是否为编辑模式
    internal var okAction: ((Array<String>) -> ())?
    
    var albumName: String = ""
    var thumbRootPath: String = ""
    
    var dataArray: Array<String> = Array()
    var cacheImages: Dictionary<String, UIImage> = Dictionary()
    var selectedImageDict: Dictionary<String, String> = Dictionary()


    // MARK: - ViewController life
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEditModel {
            self.setRightItemTitle(NSLocalizedString("pm_ok", comment: ""))
        }else{
            self.setRightItemImage("ph_album_detail")
        }
        if let album = album {
            title = album.name
            albumName = album.name
            thumbRootPath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(PMUIContraint.kThumbName + albumName)
        }
        view.backgroundColor = UIColor.whiteColor()
        createAlbumCollectivew()
        
        _loadAllPhoto()
        
        regiseteNotification()

    }
    
    override func didReceiveMemoryWarning() {
        cacheImages = Dictionary()
    }
    
    // MARK: - Action
    override func didClickRightItem() {
        if isEditModel{
            
            // TODO: 字典中取出所有的values，直接为Array<String>
            var values: Array<String> = Array()
            for fileName in selectedImageDict.values{
                values.append(fileName)
            }
            navigationController?.popViewControllerAnimated(true)
            okAction?(values)

        }
        else{
            let albumDetailVC = PMAlbumDetailController()
            albumDetailVC.album = self.album
            navigationController?.pushViewController(albumDetailVC, animated: true)
        }
    }
    
    // MARK: - Notification
    func regiseteNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PMAlbumListController.dealWithNotDeleteAlbumPhotos), name: PMConstant.kNotificationReloadAlbumList, object: nil)
    }
    
    func dealWithNotDeleteAlbumPhotos() {
        _loadAllPhoto()
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
    func _loadAllPhoto(){
        do {
             dataArray = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(thumbRootPath)
            
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
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
        if isEditModel {
            ablumCollectivew .registerClass(PMAlbumPickCollectionCell.self, forCellWithReuseIdentifier: KCollectionEditIdentifier)

        }else{
            ablumCollectivew .registerClass(PMAlbumPickNoSelectCell.self, forCellWithReuseIdentifier: KCollectionIdentifier)
        }
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
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        
        if self.isEditModel {
            let cell: PMAlbumPickCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(KCollectionEditIdentifier, forIndexPath: indexPath) as! PMAlbumPickCollectionCell
            
            guard indexPath.row < dataArray.count else{
                return cell
            }
            
            let imageName = self.dataArray[indexPath.row]
            
            // Click action
            cell.selectAction = { [weak self] isSelected in
                if isSelected{
                    self?.selectedImageDict[imageName] = imageName
                    
                }else{
                    self?.selectedImageDict.removeValueForKey(imageName)
                    
                }
                
                if let count = self?.selectedImageDict.count{
                    self?.setRightItemTitle(NSLocalizedString("pm_ok", comment: "") + "(\(count))")
                }
            }
            
            let filePath = self.thumbRootPath.stringByAppendingPathComponent(imageName)
            cell.loacelIndentifier = imageName
            if let aImage = cacheImages[imageName]{
                let aValue = selectedImageDict[imageName]
                cell.configurAlbumPickCollectionCelleData(aImage, isSelect: aValue != nil)
                
            }else{
                dispatch_async(dispatch_get_global_queue(0, 0)) {
                    if let aImage = UIImage(contentsOfFile: filePath){
                        dispatch_async(dispatch_get_main_queue(), {
                            if cell.loacelIndentifier == imageName{
                                let aValue = self.selectedImageDict[imageName]
                                cell.configurAlbumPickCollectionCelleData(aImage, isSelect: aValue != nil)
                            }
                            self.cacheImages[imageName] = aImage
                        })
                    }
                }
            }

            return cell
        }
        else{
            // Edit mode
            let cell: PMAlbumPickNoSelectCell = collectionView.dequeueReusableCellWithReuseIdentifier(KCollectionIdentifier, forIndexPath: indexPath) as! PMAlbumPickNoSelectCell
            
            guard indexPath.row < dataArray.count else{
                return cell
            }
            
            let imageName = self.dataArray[indexPath.row]
            let filePath = self.thumbRootPath.stringByAppendingPathComponent(imageName)
            
            cell.loacelIndentifier = imageName
            
            if let aImage = cacheImages[imageName]{
                cell.configurAlbumPickCollectionCelleData(aImage)
            }else{
                dispatch_async(dispatch_get_global_queue(0, 0)) {
                    if let aImage = UIImage(contentsOfFile: filePath){
                        dispatch_async(dispatch_get_main_queue(), {
                            if cell.loacelIndentifier == imageName{
                                cell.configurAlbumPickCollectionCelleData(aImage)
                            }
                            self.cacheImages[imageName] = aImage
                        })
                    }
                }
            }
            
            return cell

        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = cellWidth
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kItemMinSpace, kItemMinSpace, kItemMinSpace, kItemMinSpace)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        var index = 0
        var photos: Array<PMPhotoItem> = Array()
        for fileName in dataArray{
            var photoItem: PMPhotoItem
            if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)){
                guard let photoCell = cell as? PMAlbumPickNoSelectCell else{
                    return
                }
                var isCurrentItem = false
                if index == indexPath.row{
                    isCurrentItem = true
                }
                photoItem = PMPhotoItem(image: photoCell.imageView.image, thumbView: photoCell.imageView, isSelectedItem: isCurrentItem, asset: nil, filePath: fileName)
                
            }else{
                photoItem = PMPhotoItem(image: nil, thumbView: nil, isSelectedItem: false, asset: nil, filePath: fileName)
                
            }
            
            photos.append(photoItem)
            index += 1
        }
        
        let previewVC = PMPhotoPreviewController()
        previewVC.photos = photos
        if let album = self.album{
            previewVC.albumName = album.name
        }
        presentViewController(previewVC, animated: true, completion: nil)
    }

}
