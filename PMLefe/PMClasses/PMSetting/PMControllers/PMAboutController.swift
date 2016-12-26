//
//  PMAboutController.swift
//  PMLefe
//
//  Created by wsy on 16/5/15.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import MessageUI

private let kAboutControllerIdentifier = "aboutController"

class PMAboutController: PMBaseController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("se_about_lefe", comment: "")
        createTableView()
        createHeaderView()
    }
    
    // MARK: CreateUI
    func createHeaderView(){
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(view.frame), height: 300)
        tableView.tableHeaderView = bgView
        
        let logoWidth = 100
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoWidth, height: logoWidth))
        logoImageView.center = CGPoint(x: view.width/2.0, y: 100)
        logoImageView.image = UIImage(named: "about")
        bgView.addSubview(logoImageView)
        
        let desLabel = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(logoImageView.frame) + 30, width: view.width, height: 44))
        desLabel.font = UIFont(name: PMUIContraint.kFontHWFangsong, size: 20)
        desLabel.textColor = UIColor.blackColor()
        desLabel.text = NSLocalizedString("se_record_life", comment: "")
        desLabel.textAlignment = .Center
        bgView.addSubview(desLabel)
        
    }
    
    func createTableView(){
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

}


// MARK: UITableViewDataSource
extension PMAboutController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kAboutControllerIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: .Value1, reuseIdentifier: kAboutControllerIdentifier)
        }
        cell?.textLabel?.font = PMUIContraint.kFont
        cell?.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        if indexPath.row == 0{
            // Version
            cell?.textLabel?.text = NSLocalizedString("se_version", comment: "")
            if let infoDict = NSBundle.mainBundle().infoDictionary{
                if let version = infoDict["CFBundleShortVersionString"]{
                    cell?.detailTextLabel?.text = "\(NSLocalizedString("se_current_version", comment: "")) \(version)"
                }
            }
        }else if indexPath.row == 1{
            // FeedBack
            cell?.textLabel?.text = NSLocalizedString("se_problem_feedback", comment: "")
            cell?.detailTextLabel?.text = NSLocalizedString("se_welcome_feedback", comment: "")
        }else{
            // Home
            cell?.textLabel?.text = NSLocalizedString("se_home", comment: "")
            cell?.detailTextLabel?.text = "http://lefe.bid"
        }
        
        return cell!
    }
}

// MARK: UITableViewDelegate
extension PMAboutController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1{
            // FeedBack
            if MFMailComposeViewController.canSendMail(){
                _sendEmail()
            }else{
                let alert = UIAlertController.pm_showWithMessage(NSLocalizedString("se_feedback_alert", comment: ""), completion: { (index) -> (Void) in
                    
                })
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }else if indexPath.row == 2{
            // Home
            let webVC = PMWebController()
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func _sendEmail() {
        let mailVC = MFMailComposeViewController()
        mailVC.setSubject("Lefe feedback")
        mailVC.setCcRecipients(["wsyxyxs@126.com"])
        mailVC.setToRecipients(["wsyxyxs@126.com"])
        mailVC.setBccRecipients(["wsyxyxs@126.com"])
        mailVC.mailComposeDelegate = self
        self.presentViewController(mailVC, animated: true, completion: nil)
    }
    
}

// MARK: MFMailComposeViewControllerDelegate
extension PMAboutController: MFMailComposeViewControllerDelegate{
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}




