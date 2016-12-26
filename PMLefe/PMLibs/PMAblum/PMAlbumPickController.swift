//
//  PMAblumPickController.swift
//  PMLefe
//
//  Created by wsy on 16/5/15.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

private let KCollectionIdentifier = "collectionIdentifier"
private let kThumbImageSize: CGFloat = 100

// MARK: PMAlbumPickCollectionCell
class PMAlbumPickCollectionCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var selectButton: UIButton!
    var loacelIndentifier: String?
    
    var selectAction: ((isSelect: Bool) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
        selectButton = UIButton(type: .Custom)
        selectButton.setImage(UIImage(named: "ph_circle"), forState: .Normal)
        selectButton.setImage(UIImage(named: "ph_circle_point"), forState: .Selected)
        selectButton.frame = CGRect(x: frame.width - 40, y: 0, width: 40, height: 40)
        selectButton.addTarget(self, action: #selector(selectButtonClick(_:)), forControlEvents: .TouchUpInside)
        contentView.addSubview(selectButton)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configurAlbumPickCollectionCelleData(image: UIImage, isSelect: Bool) {
        imageView.image = image
        selectButton.selected = isSelect
    }
    
    func selectButtonClick(button: UIButton) {
        
        self.selectButton.width = 30
        selectAction?(isSelect: !button.selected)


        UIView.animateWithDuration(0.2) {[weak self] in
            if button.selected{
                self?.imageView.alpha = 1.0
                self?.selectButton.selected = false
            }
            else{
                self?.imageView.alpha = 0.6
                self?.selectButton.selected = true
            }
            self?.selectButton.width = 40

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PMAlbumPickNoSelectCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var loacelIndentifier: String?
    
    var selectAction: ((isSelect: Bool) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configurAlbumPickCollectionCelleData(image: UIImage) {
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: PMAblumPickController
class PMAlbumPickController: PMBaseController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:  Propety
    private let kColumsCount = 4;
    private let kItemMinSpace: CGFloat = 5.0;
    
    internal var cancelAction: (() -> Void)?
    internal var okAction: (([PHAsset]) -> Void)?
    
    var selectedAssets: Array<PHAsset> = Array()
    var flagKey: Dictionary<String, String> = Dictionary()

    var ablumCollectivew: UICollectionView!
    var fetchResult: PHFetchResult!
    let scal = UIScreen.mainScreen().scale

    var targetSize: CGSize{
        get {
            return CGSizeMake(kThumbImageSize * scal, kThumbImageSize * scal)
        }
    }
    
    var cellWidth: CGFloat{
        get {
            return (CGRectGetWidth(self.view.bounds) - (CGFloat(kColumsCount + 1) * kItemMinSpace)) / CGFloat(kColumsCount)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = NSLocalizedString("ph_all_photos", comment: "")
        setRightItemTitle(NSLocalizedString("pm_ok", comment: ""))
        setLeftItemImage("pm_cancel")
        createAlbumCollectivew()
        
        _loadAllPhoto()
    }
    
    func _loadAllPhoto(){
        fetchResult = PMAlbum().queryAllAsset()
    }
    
    // MARK: Action
    override func didClickRightItem() {
        okAction?(selectedAssets)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didClickLeftItem() {
        cancelAction?()
        dismissViewControllerAnimated(true, completion: nil)
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
        ablumCollectivew.registerClass(PMAlbumPickCollectionCell.self, forCellWithReuseIdentifier: KCollectionIdentifier)
        self.view.addSubview(ablumCollectivew)
    }

    // MARK: - UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PMAlbumPickCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(KCollectionIdentifier, forIndexPath: indexPath) as! PMAlbumPickCollectionCell

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
        let _ = PHImageManager.defaultManager().requestImageForAsset(item, targetSize: targetSize, contentMode: PHImageContentMode.Default, options: imageOption) { (image, imageInfo) in
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let previewVC = PMPhotoPreviewController()
        var photos: [PMPhotoItem] = []
        
        fetchResult.enumerateObjectsUsingBlock { (asset, index, stop) in
            
            guard let photoAsset = asset as? PHAsset else{
                return
            }
            
            var photoItem: PMPhotoItem
            if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)){
                guard let photoCell = cell as? PMAlbumPickCollectionCell else{
                    return
                }
                var isCurrentItem = false
                if index == indexPath.row{
                    isCurrentItem = true
                }
                photoItem = PMPhotoItem(image: photoCell.imageView.image, thumbView: photoCell.imageView, isSelectedItem: isCurrentItem, asset: photoAsset, filePath: nil)

            }else{
                photoItem = PMPhotoItem(image: nil, thumbView: nil, isSelectedItem: false, asset: photoAsset, filePath: nil)

            }
            
            photos.append(photoItem)

        }
        
        previewVC.photos = photos
        presentViewController(previewVC, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension PMAlbumPickController{
    
}



