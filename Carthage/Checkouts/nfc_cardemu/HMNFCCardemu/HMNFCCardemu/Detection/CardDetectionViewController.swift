//
//  OpenCardViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit

class CardDetectionViewController: UIViewController {
    
    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        
        setupNavigationBarView()

        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 20
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func supportButtonClick(_ sender: UIButton) {
        let vc : SupportDescriptionViewController = UIStoryboard.init(openCard: .Detection).instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func startButtonClick(_ sender: UIButton) {
        let vc : StartDetectionViewController = UIStoryboard.init(openCard: .Detection).instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
