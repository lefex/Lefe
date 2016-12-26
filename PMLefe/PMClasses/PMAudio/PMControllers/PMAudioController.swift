//
//  PMAudioController.swift
//  PMLefe
//
//  Created by wsy on 16/1/16.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation

private let kPlayHeight: CGFloat = 250

class PMAudioController: PMBaseController{
    
    // 播放按钮
    lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 180/255.0, green:  180/255.0, blue:  180/255.0, alpha: 0.5)
        return view
    }()
    
    lazy var playView: PMAudioPlayView = {
        let view = PMAudioPlayView(frame: CGRect.zero)
        return view
    }()
    
    var displayLink: CADisplayLink!

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createDriectoryButton: UIButton!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomContraint: NSLayoutConstraint!
    
    var playerManager: AVAudioPlayer?

    var dataArray: Array<String> = Array()
    
    var selectIndexPath: NSIndexPath?
    
    // MARK: - view controller lifr cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFirstData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayLink = CADisplayLink(target: self, selector: #selector(timerAction))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.invalidate()
        
        // Stop player
        PMAudioPlayer.sharePlayer.stop()
    }
    
    private func setUpFirstData(){
        title = NSLocalizedString("au_my_audio", comment: "")
        tableView.backgroundColor = PMUIContraint.defaultTableColor()
        createUI()
        loadLocalData()
    }
    
    private func loadLocalData(){
        let file: PMAudioFile = PMAudioFile(fileName: nil)
        dataArray = Array()
        
        file.queryAllAudioFilesWithCompleteHander { (files, directories) -> () in
            
            for fileName in files{
                self.dataArray.append(fileName)
            }
            
            if self.dataArray.count == 0 {
                let rect = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - 64.0)
                let emptyView = PMEmptyTextView(frame: rect)
                
                emptyView.configureEmptyView(NSLocalizedString("au_no_audio", comment: ""), contentText: NSLocalizedString("au_add_audio", comment: ""))
                self.tableView.tableFooterView = emptyView
                
            }else{
                self.tableView.tableFooterView = UIView()
            }
            
            self.tableView.reloadData()
        }

    }
    
    // MARK: - Action
    func timerAction() {
        self.playView.progressView.minValue = Float(PMAudioPlayer.sharePlayer.currentTime)
        self.playView.progressView.progress = Float(PMAudioPlayer.sharePlayer.currentTime)
    }

}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension PMAudioController : UITableViewDataSource, UITableViewDelegate{
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("ID")
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: "ID")
             cell?.accessoryType = .DisclosureIndicator
        }
        
        let fileName: String = self.dataArray[indexPath.row]
        cell!.textLabel?.text = fileName.pm_stringByDeletingPathExtension()
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectIndexPath = indexPath
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // Play
        let playAction = UIAlertAction(title: NSLocalizedString("au_play", comment: ""), style: .Default) { (action) in
            
            self.maskView.hidden = false
            UIView.animateWithDuration(0.25, animations: { 
                self.playView.frame = CGRect(x: 0, y: self.parentViewController!.view.height - kPlayHeight, width: self.view.width, height: kPlayHeight)
                }, completion: { (isFinish) in
                    self.playAction()
            })
            
        }
        actionSheet.addAction(playAction)
        
        // Delete
        let deleteAction = UIAlertAction(title: NSLocalizedString("ph_delete", comment: ""), style: .Destructive) { (action) in
            
            let fileUrl = PMLocalFileManager.audioRootPath.stringByAppendingPathComponent(self.dataArray[indexPath.row])
            
            do {
               try NSFileManager.defaultManager().removeItemAtPath(fileUrl)
                self.dataArray.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            }catch let error as NSError {
                print_pm("Delete error: \(error.localizedDescription)")
            }

            
        }
        actionSheet.addAction(deleteAction)
        
        // Cancel
        let cancelAction = UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: .Cancel) { (action) in
            
        }
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

// MARK: - audio play
extension PMAudioController{
    
    func playAudioWithFileName(fileName: String){
        let fileUrl = PMLocalFileManager.audioRootPath.stringByAppendingPathComponent(fileName)
        print_pm("play url: \(fileUrl)")
        PMAudioPlayer.sharePlayer.preparePlay(fileUrl)
        PMAudioPlayer.sharePlayer.play()
        
        self.playView.progressView.maxValue = Float(PMAudioPlayer.sharePlayer.duration)

        PMAudioPlayer.sharePlayer.finishAction = {
            self.playView.playButton.selected = false
        }
    }

}

// MARK: - createUI
extension PMAudioController{
    private func createUI(){
        createTableView()
        
        self.maskView.hidden = true
        self.parentViewController?.view.addSubview(self.maskView)
        self.maskView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        self.maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PMAudioController.maskViewClick)))
        
        self.maskView.addSubview(self.playView)
        self.playView.frame = CGRect(x: 0, y: self.parentViewController!.view.height, width: self.view.width, height: kPlayHeight)
        self.playView.playButton.addTarget(self, action: #selector(PMAudioController.playAction), forControlEvents: .TouchUpInside)
    }
    
    private func createTableView(){
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionHeaderHeight = 30
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func maskViewClick() {

        UIView.animateWithDuration(0.25, animations: { 
            self.playView.frame = CGRect(x: 0, y: self.parentViewController!.view.height, width: self.view.width, height: kPlayHeight)
            }) { (isFinish) in
                self.maskView.hidden = true
                PMAudioPlayer.sharePlayer.stop()
                self.playView.playButton.selected = false
        }
    }
    
    func playAction() {
        if self.playView.playButton.selected {
            PMAudioPlayer.sharePlayer.stop()
            self.playView.playButton.selected = false
        }else{
            if let indexPath = self.selectIndexPath{
                self.playView.playButton.selected = true
                self.playAudioWithFileName(self.dataArray[indexPath.row])
            }
        }

    }
}

// 播放视图
class PMAudioPlayView: UIView {
    // 播放按钮
    lazy var playButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "ls_play"), forState: .Normal)
        button.setImage(UIImage(named: "au_pause"), forState: .Selected)
        return button
    }()
    
    // 进度条
    lazy var progressView: PMProcgressView = {
        let view = PMProcgressView(frame: CGRectZero)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.progressView)
        self.addSubview(self.playButton)
        
        self.playButton.snp_makeConstraints { (make) in
            make.top.equalTo(40)
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.centerX.equalTo(self)
        }
        
        self.progressView.snp_makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-30)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




