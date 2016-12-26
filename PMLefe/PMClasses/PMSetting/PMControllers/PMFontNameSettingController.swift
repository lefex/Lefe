//
//  PMFontNameSettingController.swift
//  PMLefe
//
//  Created by wsy on 16/3/29.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let indentifier = "PMFontNameCellID"

class PMFontNameSettingController: PMBaseController{
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray: [String] = PMUIContraint.kAPPFontNames
    let currentFontName = PMUIContraint.kFont.fontName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("se_set_font", comment: "")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

}

extension PMFontNameSettingController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(indentifier)
        if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: indentifier)
            cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        cell?.textLabel?.font = UIFont(name: dataArray[indexPath.row], size: 18)
        cell?.textLabel?.text = NSLocalizedString("se_welcome", comment: "")
        cell?.detailTextLabel?.text = dataArray[indexPath.row]
        if currentFontName == dataArray[indexPath.row]{
            cell?.accessoryType = .Checkmark
        }else{
            cell?.accessoryType = .None
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        PMUserDefault.pm_setValue(dataArray[indexPath.row], forKey: PMFontNameKey)
        NSNotificationCenter.defaultCenter().postNotificationName(PMConstant.kNotificationFontChange, object: nil)
        
        navigationController?.popViewControllerAnimated(true)
    }
}

