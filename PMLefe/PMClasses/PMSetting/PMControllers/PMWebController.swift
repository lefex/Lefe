//
//  PMWebController.swift
//  PMLefe
//
//  Created by wsy on 16/5/15.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

class PMWebController: PMBaseController {

    var webUrl: String?
    var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        let webView = UIWebView(frame: view.bounds)
        webView.delegate = self
        if let url = webUrl{
            let request = NSURLRequest(URL: NSURL(string: url)!)
            webView.loadRequest(request)
        }else{
            let request = NSURLRequest(URL: NSURL(string: "http://lefe.bid")!)
            webView.loadRequest(request)
        }
        view.addSubview(webView)
        
        //
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingView.center = view.center
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
    }
}


extension PMWebController: UIWebViewDelegate{
    func webViewDidStartLoad(webView: UIWebView) {
        self.loadingView.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingView.stopAnimating()
    }
}