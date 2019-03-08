//
//  CardSimulationFailureViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/25.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit

class CardSimulationFailureViewController: UIViewController {

    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBarView()
        
        retryButton.layer.masksToBounds = true
        retryButton.layer.cornerRadius = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retryButtonClick(_ sender: UIButton) {
        goBack();
    }
    
    func setupNavigationBarView() {
        navigationBarView.backAction = { [weak self] in
            self?.goBack()
        }
    }
    
    func goBack() {
        let count = self.navigationController!.viewControllers.count
        for index in (0..<count).reversed() {
            let vc = self.navigationController?.viewControllers[index]
            
            if (vc!.isKind(of: CardDetectionViewController.self) && index > 0) {
                let popVC = self.navigationController?.viewControllers[index]
                self.navigationController?.popToViewController(popVC!, animated: true)
                break;
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
