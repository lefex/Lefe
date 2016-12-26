//
//  PMAudioRecordController.swift
//  PMLefe
//
//  Created by wsy on 16/1/16.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import AVFoundation

class PMAudioRecordController: PMBaseController {
    
    var displayLink: CADisplayLink!
    
    var isNeedSave = false
    
    // The audio temp path
    var fileUrl: NSURL{
        get {
            let url = NSURL(fileURLWithPath: PMLocalFileServes.tempPath.stringByAppendingPathComponent("lefe." + AudioFileExtenion.M4A.rawValue))
            return url
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var reSetButton: UIButton!
    
    // Start
    @IBAction func startAction(sender: UIButton) {
        
        if startButton.selected{
            // pause
            self.pauseRecording()
        }else{
            // start
            self.startRecording()
            
        }
        startButton.selected = !startButton.selected
    }
    
    // Save
    @IBAction func saveAction(sender: UIButton) {
        
        isNeedSave = false
        
        PMAudioRecord.sharedRecordManager.endRecod()
        
        let audioSaveUrl = NSURL(fileURLWithPath: PMLocalFileManager.audioRootPath.stringByAppendingPathComponent((nameTextField.text ?? NSDate().pm_MD_HMS) + "." + AudioFileExtenion.M4A.rawValue))
        print_pm("Save audio path: \(audioSaveUrl)")
        do{
           _ = try NSFileManager.defaultManager().moveItemAtURL(fileUrl, toURL: audioSaveUrl)
            
            let hub = PMHubView.showInView(self.view, type: PMHudViewType.Text)
            hub.labelText = NSLocalizedString("au_have_save", comment: "")
            hub.hidHudViewAfterDelay(2.5, animated: true)
            
            nameTextField.text = NSDate().pm_MD_HMS
            
        }catch let error as NSError{
            print("Save audio error: \(error.localizedDescription)")
        }
    }
    
    
    // Restart
    @IBAction func reStartAction(sender: UIButton) {
        let alert = UIAlertController.pm_showWithMessage(NSLocalizedString("au_begin_audio_alert", comment: "")) { (index) -> (Void) in
            if index == 1{
                self.startButton.selected = true
                self.startRecording()
            }
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    lazy var waveView: SCSiriWaveformView = {
       let view = SCSiriWaveformView()
        view.waveColor = PMUIContraint.defaultTextColor()
        view.primaryWaveLineWidth = 3.0
        view.secondaryWaveLineWidth = 1.0
        view.idleAmplitude = 0.03
        view.backgroundColor = UIColor.whiteColor()
        view.updateWithLevel(0)
        return view
    }()
    
    
    // MARK: viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirstData()
        
        view.addSubview(waveView)
        waveView.snp_makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(timeLabel.snp_bottom)
            make.bottom.equalTo(startButton.snp_top).offset(-10)
        }
        reSetButton.hidden = true
        saveButton.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayLink = CADisplayLink(target: self, selector: #selector(updateMeters))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.invalidate()
    }
    
    func updateMeters() {
        waveView.updateWithLevel(PMAudioRecord.sharedRecordManager.powerLeval())
        
        timeLabel.text = self.changeTotalTimeToShow(Int(PMAudioRecord.sharedRecordManager.currentTime))
    }
    
    
    // MARK: - load data
    private func configureFirstData(){
        
        nameTextField.text = NSDate().pm_MD_HMS
        title = NSLocalizedString("pm_audio", comment: "")
        
//        setRightItemImage("ph_album_detail")
        setLeftItemImage("pm_cancel")
    }
    
    // MARK:  - Action
    override func didClickLeftItem() {
        
        self.pauseRecording()
        self.startButton.selected = false
        
        if isNeedSave {
            let alert = UIAlertController(title: "", message: NSLocalizedString("au_cancel_alert", comment: ""), preferredStyle: .Alert)
            let saveAction = UIAlertAction(title: NSLocalizedString("au_save", comment: ""), style: .Destructive) { (action) in
                self.saveAction(self.saveButton)
            }
            alert.addAction(saveAction)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("pm_cancel", comment: ""), style: .Cancel) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    override func didClickRightItem() {
        let audioListVC = self.getViewControllerFromStoryboardWithIndentifier("PMAudioController", storyBoardType: PMUIContraint.kMainStoryboard)
        navigationController?.pushViewController(audioListVC, animated: true)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if nameTextField.isFirstResponder(){
            nameTextField.resignFirstResponder()
        }
    }
    
    // Helper
    func startRecording() {
        isNeedSave = true

        PMAudioRecord.sharedRecordManager.beginRecord(fileUrl, audioRecordDelegate: self)
        
        reSetButton.alpha = 1.0
        saveButton.alpha = 1.0
        UIView.animateWithDuration(0.25, animations: { 
            self.reSetButton.alpha = 0
            self.saveButton.alpha = 0
            }) { (isFinish) in
                self.reSetButton.hidden = true
                self.saveButton.hidden = true
        }
    }
    
    func pauseRecording() {
        PMAudioRecord.sharedRecordManager.endRecod()
        reSetButton.alpha = 0
        saveButton.alpha = 0
        UIView.animateWithDuration(0.25, animations: {
            self.reSetButton.alpha = 1.0
            self.saveButton.alpha = 1.0
        }) { (isFinish) in
            self.reSetButton.hidden = false
            self.saveButton.hidden = false
        }
    }
}


extension PMAudioRecordController{
    
    func changeTotalTimeToShow(totalTime: Int) -> String {
        let hour: Int = (totalTime/3600)
        let minute: Int = (totalTime - hour*3600)/60
        let second: Int  = totalTime - hour*3600 - minute*60
        
        func getTimeStr(seconds: Int) -> String{
            if seconds == 0{
                return  "00"
            }else if seconds < 10{
                return  "0" + String(seconds)
            }else{
                return  String(seconds)
            }
        }
        return  getTimeStr(hour) + ":" + getTimeStr(minute) + ":" + getTimeStr(second)
    }
}

extension PMAudioRecordController: AVAudioRecorderDelegate
{
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print_pm("record finished")
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print_pm("record error occur: " + error!.localizedDescription)
    }
    
    func audioRecorderEndInterruption(recorder: AVAudioRecorder, withOptions flags: Int) {
        print_pm("record end interruption")
    }
}

