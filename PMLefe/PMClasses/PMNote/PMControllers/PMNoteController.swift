//
//  PMNoteController.swift
//  PMLefe
//
//  Created by wsy on 16/6/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import RealmSwift

private let kNoteIdentifier = "noteListID"

class PMNoteController: PMBaseController {

    let realm = try! Realm()

    var tableView: UITableView!
    var notes: Results<Note>!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("pm_note", comment: "")
        
        makeUI()
        
        loadData()
    }
    
    // MARK: - Load data
    private func loadData() {
        notes = realm.objects(Note).sorted("date", ascending: false)
        if notes.count == 0 {
            let rect = CGRect(x: 0, y: 0, width: view.width, height: view.height - 64.0)
            let emptyView = PMEmptyTextView(frame: rect)
            
            emptyView.configureEmptyView(NSLocalizedString("no_no_note", comment: ""), contentText: NSLocalizedString("no_note_empty", comment: ""))
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
        tableView.registerClass(PMNoteListCell.self, forCellReuseIdentifier: kNoteIdentifier)
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension PMNoteController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let note = notes[indexPath.row]
        let detailVC = PMNodeDetailController()
        detailVC.note = note
        if note.pwd.isEmpty {
            navigationController?.pushViewController(detailVC, animated: true)
        }else{
            // Have pwd
            let pwdVC = PMPwdController()
            pwdVC.pwdType = PMPwdType.Verify
            pwdVC.firstPwd = note.pwd
            pwdVC.finishComplete = { [weak self] pwd in
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            let nav = PMBaseNavController(rootViewController: pwdVC)
            presentViewController(nav, animated: true, completion: nil)
        }

    }
}

extension PMNoteController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kNoteIdentifier, forIndexPath: indexPath) as! PMNoteListCell
        cell.configureNote(notes[indexPath.row])
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
            let alert = UIAlertController.pm_showWithMessage(NSLocalizedString("no_delete_alert", comment: ""), completion: {[weak self] (index) -> (Void) in
                if index == 1{
                    let note = self?.notes[indexPath.row]
                    
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



