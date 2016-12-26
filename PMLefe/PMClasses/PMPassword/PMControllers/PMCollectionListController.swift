//
//  PMCollectionListController.swift
//  PMLefe
//
//  Created by wsy on 16/6/11.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RealmSwift

private let kCLTextIdentifier = "clTextID"
private let kCLEmptyTextIdentifier = "clEmptyTextID"

class PMCollectionListController: PMBaseController {
    
    let realm = try! Realm()
    
    var tableView: UITableView!
    var collections: Results<Collection>!
    var heightCache: Dictionary<String, CGFloat> = Dictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("pm_password", comment: "")
        
        makeUI()
        
        loadData()
    }
    
    // MARK: - Load data
    private func loadData() {
        collections = realm.objects(Collection).sorted("date", ascending: false)
        if collections.count == 0 {
            let rect = CGRect(x: 0, y: 0, width: view.width, height: view.height - 64.0)
            let emptyView = PMEmptyTextView(frame: rect)
            
            emptyView.configureEmptyView(NSLocalizedString("cl_no_collections", comment: ""), contentText: NSLocalizedString("cl_empty_collections", comment: ""))
            tableView.tableFooterView = emptyView;
            
        }else{
            tableView.tableFooterView = UIView()
        }
        
        tableView.reloadData()
    }
    
    // MARK: CrateUI
    private func makeUI(){
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = PMUIContraint.defaultTableColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(CLTextCell.self, forCellReuseIdentifier: kCLTextIdentifier)
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
    }
    
}


extension PMCollectionListController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let aCollection = collections[indexPath.row]
        if let aHeight = heightCache[aCollection.collectionId]{
            return aHeight
        }else{
            var content = ""
            if aCollection.type == CLCollectionType.Password.rawValue {
                content = aCollection.title
            }else{
                content = aCollection.content
            }
            var aHeight = content.heightWithFont(PMUIContraint.fontWithNameSize(PMUIContraint.kFontHWFangsong, size: 20.0), width: view.width - 30)
            aHeight += 30
            if aHeight < 44 {
                aHeight = 44
            }else if aHeight > 110{
                aHeight = 110
            }
            heightCache[aCollection.collectionId] = aHeight
            return aHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let collection = collections[indexPath.row]
        let detailVC = PMCollectionDetailController()
        detailVC.collection = collection
        if collection.startPwd.isEmpty {
            navigationController?.pushViewController(detailVC, animated: true)
        }else{
            // Have pwd
            let pwdVC = PMPwdController()
            pwdVC.pwdType = PMPwdType.Verify
            pwdVC.firstPwd = collection.pwd
            pwdVC.finishComplete = { [weak self] pwd in
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            let nav = PMBaseNavController(rootViewController: pwdVC)
            presentViewController(nav, animated: true, completion: nil)
        }
    }
}

extension PMCollectionListController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCLTextIdentifier, forIndexPath: indexPath) as! CLTextCell
        let aCollection = collections[indexPath.row]
        if aCollection.type == CLCollectionType.Password.rawValue {
            cell.configureNote(aCollection.title)
        }
        else if aCollection.type == CLCollectionType.Text.rawValue {
            cell.configureNote(aCollection.content)

        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete local album
            let alert = UIAlertController.pm_showWithMessage(NSLocalizedString("cl_delete_alert", comment: ""), completion: {[weak self] (index) -> (Void) in
                if index == 1{
                    let note = self?.collections[indexPath.row]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        try! self?.realm .write({
                            self?.realm.delete(note!)
                            self?.loadData()
                            self?.tableView.reloadData()
                        })
                    })
                    
                }
                })
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
}