//
//  CardProblemViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/24.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import WebKit

class CardProblemViewController: UIViewController {
    
    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarView.backAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Do any additional setup after loading the view.
        let requeest = URLRequest.init(url: URL.init(string: "http://cdn.awsbj0.fds.api.mi-img.com/mifit/1532422681.html")!);
        
        let webView : WKWebView = WKWebView.init(frame: CGRect.init(x: 0, y: navigationBarView.navHeightConstraint.constant, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - navigationBarView.navHeightConstraint.constant))
    
        view.addSubview(webView)
        
        webView.load(requeest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
