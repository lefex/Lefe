//
//  PMPhotoPreviewController.swift
//  PMLefe
//
//  Created by wsy on 16/5/18.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

// MARK: PMPhotoItem
struct PMPhotoItem {
    // The image that will be displayed. Make sure to set this property before presenting the controller
    var image: UIImage?
    
    // Animate from th thumbnail into the full screen
    var thumbView: UIView?
    
    // The index of current items
    var isSelectedItem: Bool
    
    var asset: PHAsset?
    
    var filePath: String?
}



private let kMaxZoomScal: CGFloat = 2

// MARK: PMAlbumPreviewCollectionCellDelegate

protocol PMAlbumPreviewCollectionCellDelegate {
    func albumPreviewCollectionCellDidClick(cell: PMAlbumPreviewCollectionCell)
}


// MARK: PMAlbumPreviewCollectionCell

class PMAlbumPreviewCollectionCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    var scrolleView: UIScrollView!
    var imageContainView: UIView!
    
    var loacelIndentifier: String?
    var delegate: PMAlbumPreviewCollectionCellDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.blackColor()
        let screenFrame = UIScreen.mainScreen().bounds
        
        // ScrollView as backgroud view
        
        scrolleView = UIScrollView(frame: CGRectMake(0, 0, screenFrame.width, screenFrame.height))
        scrolleView.contentSize = CGSizeMake(screenFrame.width, screenFrame.height)
        scrolleView.bounces = false
        scrolleView.bouncesZoom = true
        scrolleView.maximumZoomScale = kMaxZoomScal
        scrolleView.delegate = self
        contentView.addSubview(scrolleView)
        
        // Single click
        let singleGesture = UITapGestureRecognizer(target: self, action: #selector(PMAlbumPreviewCollectionCell._imageClick(_:)))
        scrolleView.addGestureRecognizer(singleGesture)
        
        // Double click
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(PMAlbumPreviewCollectionCell.doubleClick(_:)))
        doubleGesture.numberOfTapsRequired = 2
        doubleGesture.delaysTouchesBegan = true
        scrolleView.addGestureRecognizer(doubleGesture)
        
        // imageContainView
        imageContainView = UIView(frame: scrolleView.bounds)
        imageContainView.clipsToBounds = true
        scrolleView.addSubview(imageContainView)
        
        // ImageView to show image
        imageView = UIImageView(frame: CGRectMake(0, 0, screenFrame.width, screenFrame.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.userInteractionEnabled = true
        imageContainView.addSubview(imageView)
        
    }
    
    // MARK: Action
    func _imageClick(tapGesture: UITapGestureRecognizer) {
        self.delegate?.albumPreviewCollectionCellDidClick(self)
    }
    
    func doubleClick(tapGesture: UITapGestureRecognizer) {
        if scrolleView.zoomScale > 1 {
           scrolleView.setZoomScale(1, animated: true)
        }else{
            scrolleView.setZoomScale(kMaxZoomScal, animated: true)
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configurAlbumPickCollectionCelleData(image: UIImage) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        imageView.frame = image.pm_imageFrameForScreen()
        CATransaction.commit()
        
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageContainView
    }
}



// MARK: PMPhotoPreviewController
class PMPhotoPreviewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    private let kItemMinSpace: CGFloat = 5.0
    private let kPreviewIndentifer: String = "previewIndentifer"

    var photos: [PMPhotoItem] = [PMPhotoItem]()
    var albumName: String = ""
    internal var previewCollectivew: UICollectionView!
    var firstIndexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    var pageLabel: UILabel!
    
    var currentCell: PMAlbumPreviewCollectionCell?{
        get{
            if let cell =  previewCollectivew.visibleCells().first as? PMAlbumPreviewCollectionCell{
                return cell
            }else{
                return nil
            }
        }
    }
    
    // MARK: Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Device rotate notification
        NSNotificationCenter.defaultCenter().addObserverForName(UIDeviceOrientationDidChangeNotification, object: nil, queue: nil) {[weak self] (notification) in
            self?.deviceRotoateNotification()
        }
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        // CreateUI
        createPreviewCollectivew()
        createPageLabel()
        createTopPoint()
        
        // Find current cell
        var index = 0
        for photoItem in self.photos {
            if photoItem.isSelectedItem {
                break
            }
            index += 1
        }
        
        firstIndexPath = NSIndexPath(forItem: index, inSection: 0)
        previewCollectivew.scrollToItemAtIndexPath(firstIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
    }
    
    // MARK: createUI
    private func createPreviewCollectivew(){
        let rect = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.minimumInteritemSpacing = 0
        viewLayout.minimumLineSpacing = 0
        viewLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        previewCollectivew  = UICollectionView(frame: rect, collectionViewLayout: viewLayout)
        previewCollectivew.dataSource = self
        previewCollectivew.delegate = self
        previewCollectivew.bounces = false
        previewCollectivew.backgroundColor = UIColor.whiteColor()
        previewCollectivew.pagingEnabled = true
        previewCollectivew .registerClass(PMAlbumPreviewCollectionCell.self, forCellWithReuseIdentifier: kPreviewIndentifer)
        view.addSubview(previewCollectivew)
    }
    
    private func createPageLabel(){
        pageLabel = UILabel()
        pageLabel.textColor = UIColor.whiteColor()
        pageLabel.font = UIFont.systemFontOfSize(10)
        pageLabel.text = "1 / \(self.photos.count)"
        pageLabel.textAlignment = .Center
        view.addSubview(pageLabel)
        pageLabel.snp_makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.centerX.equalTo(view)
            make.bottom.equalTo(-20)
        }
        view.layoutIfNeeded()
    }
    
    private func createTopPoint(){
        let topButton = UIButton(type: .Custom)
        topButton.setImage(UIImage(named: "home_top_point"), forState: .Normal)
        topButton.addTarget(self, action: #selector(topButtonClick(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(topButton)
        topButton.snp_makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.right.equalTo(-10)
            make.top.equalTo(30)
        }
    }
    
    // MARK: Action
    func topButtonClick(button: UIButton) {
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("ph_save_to_album", comment: ""), style: .Default, handler: { (saveAction) in
            
        }))
        
        alertView.addAction(UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: .Destructive, handler: { (cancelAction) in
            
        }))
        presentViewController(alertView, animated: true, completion: nil)
    }

    
    // MARK: Helper
    func deviceRotoateNotification() {
        
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PMAlbumPreviewCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(kPreviewIndentifer, forIndexPath: indexPath) as! PMAlbumPreviewCollectionCell
        
        if indexPath.row < self.photos.count {
            let photoItem = self.photos[indexPath.row]
            if let itemAsset = photoItem.asset{
                // Get system photo image
                cell.loacelIndentifier = itemAsset.localIdentifier
                PHImageManager.defaultManager().requestImageForAsset(itemAsset, targetSize: CGSizeMake(view.width, 1000), contentMode: .AspectFill, options: nil, resultHandler: { (image, info) in
                    if let aImage = image {
                        if itemAsset.localIdentifier == cell.loacelIndentifier{
                            cell.configurAlbumPickCollectionCelleData(aImage)
                        }
                    }
                    
                })
            }
            else{
                // Get local album image
                if let fileName = photoItem.filePath{
                    cell.loacelIndentifier = fileName
                    dispatch_async(dispatch_get_global_queue(0, 0), {
                        let filePath = PMLocalFileManager.albumRootPath.stringByAppendingPathComponent(self.albumName).stringByAppendingPathComponent(fileName)
                        let aImage = UIImage(contentsOfFile: filePath)
                        dispatch_async(dispatch_get_main_queue(), { 
                            if cell.loacelIndentifier == fileName{
                                cell.configurAlbumPickCollectionCelleData(aImage ?? PMUIContraint.defaultAlbumThumbImage())
                            }
                        })
                    })
                }
            }
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        pageLabel.text = "\(indexPath.row + 1) / \(self.photos.count)"
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        dismissViewControllerAnimated(true, completion: nil)
    }



    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



// MARK: UIViewControllerTransitioningDelegate

extension PMPhotoPreviewController: UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PMAnimatedTransition(isPresent: true, photoItems: self.photos)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PMAnimatedTransition(isPresent: false, photoItems: self.photos)
    }
}

// MARK: PMAlbumPreviewCollectionCellDelegate
extension PMPhotoPreviewController: PMAlbumPreviewCollectionCellDelegate{

    func albumPreviewCollectionCellDidClick(cell: PMAlbumPreviewCollectionCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
