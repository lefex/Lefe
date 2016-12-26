//
//  PMLastestController.swift
//  PMLefe
//
//  Created by wsy on 16/3/22.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

private let indentifier = "PMLastestControllerCell"

class PMLastestController: PMBaseController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFristData()
        
        registeNotification()
        
        
        let card = PMCardView(frame: self.view.bounds)
        view.addSubview(card)
    }
    
    override func didClickRightItem() {
        let customerVC = PMCustomerController()
        customerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(customerVC, animated: true)
//
//        let vc = UMFeedback.feedbackViewController()
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupFristData(){
        title = NSLocalizedString("se_lastest", comment: "")
        setRightItemImage("customer_red")
        tableView.registerClass(PMVideoCell.self, forCellReuseIdentifier: indentifier)
        tableView.backgroundColor = PMUIContraint.defaultTableColor()

    }
    
    func registeNotification(){
        NSNotificationCenter.defaultCenter().addObserverForName(PMConstant.kNotificationFontChange, object: nil, queue: nil) {[weak self] (_) -> Void in
            self?.tableView.reloadData()
        }
    }
}

extension PMLastestController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(indentifier)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
}
