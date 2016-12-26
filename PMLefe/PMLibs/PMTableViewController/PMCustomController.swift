//
//  PMCustomController.swift
//  PMLefe
//
//  Created by wsy on 16/4/17.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMCustomController: PMBaseController {

}

extension PMCammerController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("")!
    }
}

extension PMCammerController: UITableViewDelegate{

}