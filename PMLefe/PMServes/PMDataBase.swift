//
//  PMDataBase.swift
//  PMLefe
//
//  Created by wsy on 16/6/19.
//  Copyright © 2016年 WSY. All rights reserved.
//  The lefe database

import Foundation
import RealmSwift


private let kDataBaseName = "Lefe.realm"
private let kEncryptionKey = "WelcomeToUseLefeWelcomeToUseLefeWelcomeToUseLefeWelcomeToUseLefe"
// 数据库升级的时候必须更新版本
private let kDataBaseVersion: UInt64 = 20160731


// MARK: －DB
class LefeDB{
    
    // The configuration of lefe database
    class func configureDataBase() -> Realm.Configuration{
        let dbPath = PMLocalFileServes.documentPath.stringByAppendingString("/\(kDataBaseName)")
        let encryptionData: NSData = kEncryptionKey.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let relamConfigure = Realm.Configuration.init(path: dbPath, inMemoryIdentifier: nil, encryptionKey: encryptionData, readOnly: false, schemaVersion: kDataBaseVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
            }, objectTypes: nil)
        return relamConfigure
    }
    
    // The relam action
    class func write(block: () -> ()){
        dispatch_async(dispatch_get_main_queue(), {
            let realm = try! Realm()
            let _ = try? realm.write(block)
        })
    }
}


// MARK: -Album
class Album: Object {
    dynamic var name = ""         // 相册名称
    dynamic var date = NSDate()   // 创建时间
    dynamic var photosCount = 0   // 照片数
    dynamic var pwd = ""          // 密码
    dynamic var albumDescription = "" // 描述
    dynamic var cover: NSData?            // 封面
    dynamic var isHiden = false       // 是否隐藏
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

// MARK: -Note
class Note: Object {
    dynamic var title = ""     // 标题
    dynamic var content = ""   // 内容
    dynamic var date = NSDate() // 添加时间
    dynamic var pwd = ""        // 密码
    dynamic var noteId = NSDate().pm_timeStamp     // Note id
    
    override static func primaryKey() -> String? {
        return "noteId"
    }
    
    var contetnAtt: NSAttributedString{
        
        let parStyle = NSMutableParagraphStyle()
        parStyle.lineSpacing = 10
        
        return NSAttributedString(string: self.content, attributes: [NSFontAttributeName : UIFont(name: PMUIContraint.kFontHWFangsong, size: 18)!, NSParagraphStyleAttributeName: parStyle])
    }
    
    var titleAtt: NSAttributedString{
        
        let parStyle = NSMutableParagraphStyle()
        parStyle.lineSpacing = 10
        
        return NSAttributedString(string: self.content, attributes: [NSFontAttributeName : UIFont(name: PMUIContraint.kFontHWFangsong, size: 20)!, NSParagraphStyleAttributeName: parStyle])
    }
    
}


// MARK: -Collection
class Collection: Object{
    dynamic var collectionId = NSDate().pm_timeStamp     // Collection id
    dynamic var type: Int = 0 // 收藏类型
    dynamic var title: String = "" // 标题
    dynamic var account: String = "" // 账号
    dynamic var pwd: String = "" // 密码
    dynamic var content: String = "" // 文本内容
    dynamic var date = NSDate() // 添加时间
    dynamic var startPwd: String = "" // 进入密码

    
    override static func primaryKey() -> String? {
        return "collectionId"
    }
    
    var contetnAtt: NSAttributedString{
        
        let parStyle = NSMutableParagraphStyle()
        parStyle.lineSpacing = 10
        
        return NSAttributedString(string: self.content, attributes: [NSFontAttributeName : UIFont(name: PMUIContraint.kFontHWFangsong, size: 18)!, NSParagraphStyleAttributeName: parStyle])
    }

}

// MARK: -Audio
class Audio: Object{
    dynamic var audioId = NSDate().pm_timeStamp // Aideo id
    dynamic var name = ""  // 名称
    dynamic var filePath = "" // 路径
    dynamic var duration: Int = 0  // 时长
    
    override static func primaryKey() -> String? {
        return "audioId"
    }
}


// MARK: -Video
class Video: Object{
    dynamic var videoId = NSDate().pm_timeStamp // Video id
    dynamic var des = ""  // 描述
    dynamic var filePath = "" // 路径
    dynamic var date = NSDate() // 添加时间
    dynamic var cover: NSData? // 第一帧图
    
    override static func primaryKey() -> String? {
        return "videoId"
    }
}


// MARK: -Message
enum MsgType: String{
    case Text = "text"
    
   func cellNameWithIsMy(isMy: Bool) -> String {
        switch self {
        case .Text:
            if isMy{
                return NSStringFromClass(PMChatTextRightCell)
            }else{
                return NSStringFromClass(PMChatTextCell)
            }
        }
    }
}

class Message{
    var msgId = NSDate().pm_timeStamp // Video id
    var type: String = MsgType.Text.rawValue  // 描述
    var body = "" // 路径
    var date = NSDate() // 添加时间
    var isMy = false
    
    var showText: String = ""
}

//class Message: Object{
//    dynamic var msgId = NSDate().pm_timeStamp // Video id
//    dynamic var type: String = MsgType.Text.rawValue  // 描述
//    dynamic var body = "" // 路径
//    dynamic var date = NSDate() // 添加时间
//    dynamic var isMy = false
//    
//    override static func primaryKey() -> String? {
//        return "msgId"
//    }
//    
//    var showText: String = ""
//}



