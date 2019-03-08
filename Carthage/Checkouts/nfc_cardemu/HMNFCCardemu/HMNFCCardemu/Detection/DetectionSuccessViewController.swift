//
//  DetectionSuccessViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import huamipay

class DetectionSuccessViewController: UIViewController {

    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    @IBOutlet weak var startButton: UIButton!
    
    var cardTag: CardTag?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBarView()
        
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func supportButtonClick(_ sender: UIButton) {
        let vc : SupportDescriptionViewController = UIStoryboard.init(openCard: .Detection).instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func startButtonClick(_ sender: UIButton) {
        let vc : OpenCardSimulationViewController = UIStoryboard.init(openCard: .OpenCard).instantiate()
        vc.cardTag = cardTag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupNavigationBarView() {
    
        let count = self.navigationController!.viewControllers.count
        
        for index in (0..<count).reversed() {
            let vc = self.navigationController?.viewControllers[index]
            
            if (vc!.isKind(of: CardDetectionViewController.self)) {
                navigationBarView.backAction = { [weak self] in self?.navigationController?.popToViewController(vc!, animated: true)
                }
                break;
            }
        }
    }
}
