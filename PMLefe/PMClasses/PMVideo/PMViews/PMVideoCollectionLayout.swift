//
//  PMVideoCollectionLayout.swift
//  PMLefe
//
//  Created by wsy on 16/7/16.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

// 列数
private let kNumberOfColumns: Int = 2
private let kCellPadding: CGFloat = 6


protocol PMVideoLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath, withWidth:CGFloat) -> CGFloat
    
//    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class PMVideoAttribute: UICollectionViewLayoutAttributes {
    // The photo height
    var photoHeight: CGFloat = 0
}


class PMVideoCollectionLayout: UICollectionViewLayout {
    
    // Delegate
    var delegate: PMVideoLayoutDelegate!
    // Cache
    var cache: Array<PMVideoAttribute> = Array()
    
    private var contentHeight:CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return PMVideoAttribute.self
    }
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    // 这个方法就是当你的布局快要生效的时候,你会在这个方法里计算好每个Item的position和CollectionView的size.
    override func prepareLayout() {
        super.prepareLayout()
        
        if cache.isEmpty{
            let sectionCount = collectionView?.numberOfSections()
            
            guard let sections = sectionCount else{
                return
            }
            
            
            let columnWidth = (contentWidth - (CGFloat(kNumberOfColumns) + 1) * kCellPadding) / CGFloat(kNumberOfColumns)
            
            var xOffsets: Array<CGFloat> = Array()
            for column in 0 ..< kNumberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth + (CGFloat(column)+1)*kCellPadding)
            }
            
            var yOffsets: Array<CGFloat> = Array(count: kNumberOfColumns, repeatedValue: 0)
            var column = 0
            
            // Sention
            for i in 0 ..< sections{
                let rowCount = collectionView?.numberOfItemsInSection(i)
                
                guard let rows = rowCount else{
                    return
                }
                
                // Row
                for row in 0 ..< rows {
                    let indexPath = NSIndexPath(forItem: row, inSection: i)
                    
                    // 计算frame
                    let xOffset: CGFloat = xOffsets[column]
                    let yOffset: CGFloat = yOffsets[column]
                    
                    let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: columnWidth)
                    
                    let rect = CGRect(x: xOffset, y: yOffset + kCellPadding, width: columnWidth, height: photoHeight - kCellPadding)
                    
                    print("rect = \(rect)")
                    
                    let attribution = PMVideoAttribute(forCellWithIndexPath: indexPath)
                    attribution.frame = rect
                    attribution.photoHeight = photoHeight
                    
                    contentHeight = max(contentHeight, rect.maxY)
                    
                    cache.append(attribution)
                    
                    yOffsets[column] = yOffsets[column] + photoHeight
                    column = column >= (kNumberOfColumns - 1) ? 0 : (column+1)
                }
            }
        }
        
        
        
    }
    
    /*
     在这个方法里返回某个特定区域的布局的属性.有点绕是吧,那我简单点说.eg.有一个CollectionView,ContentSize是(320, 1000), size是(320, 400),这时候我滑滑滑,滑到了(0, 544, 320, 400).好,那么在这个区域,有几个Cell,每个Cell的位置都是怎么样的?就是通过这个方法获知的.你不告诉CollectionView,他怎么知道怎么放cell,对吧.
     
     文／叶孤城___（简书作者）
     原文链接：http://www.jianshu.com/p/22adf62ea491
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes  in cache {
            if CGRectIntersectsRect(attributes.frame, rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    // 返回CollectionView的ContentSize.
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
}
