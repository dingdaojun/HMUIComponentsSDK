//
//  PayWebView.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/14.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import UIKit
import huamipay
import HMPayKit

let payCompany = "api.ucashier.mipay.com"
let huamiPrefix = "huami.band.mitsm"
let scheme = "\(huamiPrefix).\(payCompany)"
let referer = "\(scheme)://"

class PayWebViewController: UIViewController, UIWebViewDelegate {
    var payURL:URL?
    var returnUrl: String?
    
    typealias CompleteCallback = () -> Void
    var completeCallback: CompleteCallback?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let url = payURL else { return }
        let myWebView = UIWebView(frame: self.view.bounds)
        myWebView.delegate = self
        myWebView.loadRequest(URLRequest(url: url))
        self.view.addSubview(myWebView)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("shouldStartLoadWith:\n \(request.url!.absoluteString.urlDecoded())\n")
        guard let absoluteString = request.url?.absoluteString else { return false }
        let wxprefix = "https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"
        if absoluteString.hasPrefix(wxprefix) {
            if var fields = request.allHTTPHeaderFields,
               fields["Referer"] == referer  { return true}
            
            var newRequest = URLRequest(url: URL(string: absoluteString)!)
            newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields
            if var newFields = newRequest.allHTTPHeaderFields {
                newFields["Referer"] = referer
                newRequest.allHTTPHeaderFields = newFields
            } else {
                newRequest.allHTTPHeaderFields = ["Referer": referer]
            }
            
            print("header:\n \(newRequest.allHTTPHeaderFields ?? [:])\n")
            webView.loadRequest(newRequest)
            return false
            
        }
        
        guard request.url?.absoluteString.hasPrefix(returnUrl!) == true else { return true }
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.completeCallback!()
        }
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        print("startLoad")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        print("finishLoad")
    }
}

extension String {
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
