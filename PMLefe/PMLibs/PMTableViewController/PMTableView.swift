//
//  PMTableView.swift
//  PMLefe
//
//  Created by wsy on 16/4/20.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMTableView: UIView {

    var tableView: UITableView!
    var style: UITableViewStyle?
    
    var rowDataSource: Array<AnyObject> = []
    var sectionDataSource: Array<Array<AnyObject>> = [[]]
    
    var isGroupType: Bool{
        return sectionDataSource.count > 0
    }
    
    init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame)
        self.style = style
        
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(){
        if self.style == nil{
            tableView = UITableView(frame: self.bounds, style: .Plain)
        }else{
            tableView = UITableView(frame: self.bounds, style: self.style!)
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(PMTextCell.self, forCellReuseIdentifier: NSStringFromClass(PMTextCell.self))
        tableView.registerClass(PMIconTextCell.self, forCellReuseIdentifier: NSStringFromClass(PMIconTextCell.self))
        
        addSubview(tableView)
    }
}

extension PMTableView: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return isGroupType ? sectionDataSource.count : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGroupType{
            return sectionDataSource[section].count
        }else{
            return rowDataSource.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var dataItem: AnyObject?
//        if isGroupType{
//            dataItem = sectionDataSource[indexPath.section][indexPath.row]
//        }else{
//            dataItem = rowDataSource[indexPath.row]
//        }
        return tableView.dequeueReusableCellWithIdentifier("122")!
    }
}

extension PMTableView: UITableViewDelegate{
    
}
