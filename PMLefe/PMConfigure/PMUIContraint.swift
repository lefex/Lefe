//
//  PMUIContraint.swift
//  PMLefe
//
//  Created by wsy on 16/1/22.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import UIKit


public struct PMUIContraint{
    
    // MARK: - UI
    public static let kLeftEdge: CGFloat = 15
    public static let kRightEdge: CGFloat = 10
    public static let kSectionHeight: CGFloat = 30
    
    public static let kScreenWidth = UIScreen.mainScreen().bounds.size.width
    public static let kScreenHeight = UIScreen.mainScreen().bounds.size.height
    
    // MARK: - Color
    public static func defaultTextColor() -> UIColor{
        return UIColor(red: 0, green: 195/255.0, blue: 175/255.0, alpha: 1.0)
    }
    
    public static func defaultLefeMainColor() -> UIColor{
        return UIColor(red: 57/255.0, green: 184/255.0, blue: 187/255.0, alpha: 1.0)
    }
    
    public static func defaultTableColor() -> UIColor{
        return UIColor(red: 238/255.0, green: 238/255.0, blue: 240/255.0, alpha: 1.0)
    }
    
    public static func grayColor() -> UIColor{
        return UIColor(red: 91/255.0, green: 91/255.0, blue: 91/255.0, alpha: 1.0)
    }
    
    public static func darkGrayColor() -> UIColor{
        return UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
    }
    
    public static func defaultNoteTextColor() -> UIColor{
        return UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
    }
    
    public static func defaultBubbleTextColor() -> UIColor{
        return UIColor(red: 39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1.0)
    }
    
    public static func defaultBubbleGrayColor() -> UIColor{
        return UIColor(red: 238/255.0, green: 238/255.0, blue: 240/255.0, alpha: 1.0)
    }
    
    // MARK: - Default image
    public static func defaultAlbumCover() -> UIImage{
        return UIImage(named: "111.jpg")!
    }
    
    public static func defaultAlbumThumbImage() -> UIImage{
        return UIImage(named: "111.jpg")!
    }
    
    public static func defaultVideoImage() -> UIImage{
        return UIImage(named: "111.jpg")!
    }
    
    // MARK: - Storyboard name
    public static let kMainStoryboard = "Main"
    public static let kTabBarStoryboard = "TabBar"
    public static let kCammerStoryboard = "Cammer"
    public static let kSettingStoryboard = "PMSetting"
    public static let kPhotoStoryboard = "PMPhoto"
    
    // MARK: - Constraint
    public static let kThumbName = "LefeThumb"


    // MARK: - Photo size
     public static var kThumbSize: CGSize{
        get {
            let scal = UIScreen.mainScreen().scale
            return CGSizeMake(200 * scal, 200 * scal)
        }
    }
    
    public static let kPhotoSize = CGSizeMake(500, 1000)
    
    
    // MARK: - Font
    public static let kFontHWFangsong = "STFangsong"
    public static let kFontWyue = "Wyue-GutiFangsong-NC"

    public static var kFontSize: CGFloat{
        get{
            let fontSize = CGFloat(PMUserDefault.pm_floatValueForKey(PMFontSizeKey))
            if fontSize < kDefaultFontSize{
                return kDefaultFontSize
            }else{
                return fontSize
            }
        }
    }
    
    public static var kFont: UIFont{
        get{
            if let name = PMUserDefault.pm_stringValueForKey(PMFontNameKey){
                if let font = UIFont(name: name, size: kFontSize){
                    return font
                }else{
                    return UIFont(name: kDefaultFontName, size: kFontSize)!
                }
            }
            return UIFont(name: kDefaultFontName, size: kFontSize)!

        }
    }
    
    public static func fontWithName(size: CGFloat) -> UIFont{
        if let name = PMUserDefault.pm_stringValueForKey(PMFontNameKey){
            if let font = UIFont(name: name, size: size){
                return font
            }else{
                return UIFont(name: kDefaultFontName, size: size)!
            }
        }
        return UIFont(name: kDefaultFontName, size: size)!
    }
    
    public static func fontWithNameSize(name: String, size: CGFloat) -> UIFont{
        return UIFont(name: kFontHWFangsong, size: size)!
    }
    
    
    public static var kDefaultFontSize: CGFloat{
        get{
            return 16.0
        }
    }
    
    public static var kDefaultFontName: String{
        get{
            return "Heiti TC"
        }
    }
    
    public static var kAPPFontNames: [String]{
        get{
            return [
                kFontHWFangsong,
                kFontWyue,
                "Copperplate-Light",
                "GillSans-Italic",
                "AppleSDGothicNeo-UltraLight",
                "PingFangSC-Thin",
                "Papyrus"]
        }
    }


}