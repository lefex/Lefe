//
//  PMCammerController.swift
//  PMLefe
//
//  Created by wsy on 16/3/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMCammerController: PMBaseController {
    
    var cammerManager: PMCammerManager!

    @IBOutlet var cammerView: PMCammerView!
    @IBOutlet weak var previewView: PMPreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cammerManager = PMCammerManager()
        if cammerManager.setUpSession(){
            previewView.session = cammerManager.captureSession
            cammerManager.startSession()
            print("Create video session success")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        cammerManager.stopSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
