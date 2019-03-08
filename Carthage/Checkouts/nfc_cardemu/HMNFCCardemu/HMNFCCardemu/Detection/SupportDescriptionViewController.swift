//
//  SupportDescriptionViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit

class SupportDescriptionViewController: UIViewController {

    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBarView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBarView() {
        navigationBarView.backAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
