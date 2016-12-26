//
//  PMAlbumContentController.swift
//  PMLefe
//
//  Created by wsy on 16/6/8.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let kAlbumContentIdentifier = "kAlbumDetailIdentifier"

private enum AlbumConentType: Int {
    case CrateTime = 0
    case PhotoCount = 1
    case Size = 2
    case Descrption = 3

    
    var sectionName: String {
        switch self {
        case .CrateTime: return NSLocalizedString("ph_create_time", comment: "")
        case .PhotoCount: return NSLocalizedString("ph_photo_count", comment: "")
            
        case .Size: return NSLocalizedString("ph_size", comment: "")
        case .Descrption: return NSLocalizedString("ph_description", comment: "")
            
        }
    }
    
}

class PMAlbumContentController: PMBaseController {
    
    internal var album: Album?
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ph_detail", comment: "")
        
        makeUI()
    }
    
    // MARK: CrateUI
    private func makeUI(){
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = PMUIContraint.defaultTableColor()
        tableView.dataSource = self
        tableView.delegate = self
                
        view.addSubview(tableView)
        
        createHeaderView()
    }
    
    private func createHeaderView(){
        let headerHeight: CGFloat = 240.0
        let bgView = UIImageView(frame: CGRectMake(0, 0, view.width, headerHeight))
        bgView.contentMode = .ScaleAspectFill
        bgView.layer.masksToBounds = true
        var coverImage: UIImage
        if let cover = self.album?.cover{
           coverImage = UIImage(data: cover)!
        }else{
            coverImage = PMUIContraint.defaultAlbumCover()
        }
        bgView.image = coverImage
        tableView.tableHeaderView = bgView
        
    }
    
}

extension PMAlbumContentController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kAlbumContentIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: .Value1, reuseIdentifier: kAlbumContentIdentifier)
        }
        
        let cellType = AlbumConentType(rawValue: indexPath.row)
        cell?.textLabel?.text = cellType?.sectionName
        cell?.textLabel?.font = PMUIContraint.kFont
        switch cellType! {
        case .CrateTime:
            cell?.detailTextLabel?.text = self.album?.date.pm_YMD
        case .PhotoCount:
            cell?.detailTextLabel?.text = "\((self.album?.photosCount)!)"
        case .Size:
            cell?.detailTextLabel?.text = ""
        case .Descrption:
            cell?.detailTextLabel?.text = self.album?.albumDescription
        }

        return cell!
    }
    
}

extension PMAlbumContentController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
