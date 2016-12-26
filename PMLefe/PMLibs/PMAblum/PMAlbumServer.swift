//
//  PMAlbumServer.swift
//  PMLefe
//
//  Created by wsy on 16/5/15.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import AssetsLibrary
import Photos

private let kThumbImageSize: CGFloat = 200

class PMAlbum {
    
    let photoLibrary = PHPhotoLibrary.sharedPhotoLibrary()
    
    class func queryAllVideos() -> PHFetchResult {
        let fetchOtion = PHFetchOptions()
        fetchOtion.includeHiddenAssets = false
        let albums = PHAsset.fetchAssetsWithMediaType(.Video, options: fetchOtion)
        return albums
    }
    
    func queryAllThumbImages() -> [UIImage] {
        var result: [UIImage] = [UIImage]()
        
        let fetchOption = PHFetchOptions()
        fetchOption.includeHiddenAssets = false
        let fetchResult = PHAsset.fetchAssetsWithOptions(fetchOption)
        let imageManager = PHImageManager.defaultManager()
        fetchResult.enumerateObjectsUsingBlock { (asset, index, stop) in
            guard let aAsset = asset as? PHAsset else{
                return
            }
            
            let imageOption = PHImageRequestOptions()
            imageOption.synchronous = true
            imageManager.requestImageForAsset(aAsset, targetSize: CGSizeMake(kThumbImageSize, kThumbImageSize), contentMode: PHImageContentMode.Default, options: imageOption, resultHandler: { (image, imageInfo) in
                if let image = image{
                    result.append(image)
                }
            })
        }

        return result
    }
    
    func queryAllAsset() -> PHFetchResult {
        let fetchOption = PHFetchOptions()
        fetchOption.includeHiddenAssets = false
        
        return PHAsset.fetchAssetsWithOptions(fetchOption)
    }
    
    
}