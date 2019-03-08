//
//  CardManagerViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//


/*
 当前只会有一张卡，为了加快进度没有使用复杂 UI 用于多卡展示
 
 */

import UIKit
import huamipay
import SDWebImage

class CardManagerViewController: UIViewController {

    
    @IBOutlet weak var questionSetionView: CardManagerSectionView!
    @IBOutlet weak var removeSectionView: CardManagerSectionView!
    @IBOutlet weak var navigationBarView: NavigationBarView!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var cardProtocols: [PayACCardProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        setupNavigationBarView()
        
        questionSetionView.nameLabel.text = "常见问题"
        removeSectionView.nameLabel.text = "删除门卡"
        
        PublicInterface.shared.pay?.miACCloud.accessCardList { cardProtocols, error in
            guard error ==  nil else {
                return
            }
            
            guard let arr = cardProtocols else {
                return
            }
            
            self.cardProtocols = arr
            
            if arr.count < 1 {
                return
            }
            
            let cardProtocol = arr[0]
            
            DispatchQueue.main.async {
                self.cardNameLabel.text = cardProtocol.name
                
                if !cardProtocol.art.isEmpty {
                    self.imageView.sd_setImage(with: URL.init(string: cardProtocol.art))
                }
            }
        }
        
        removeSectionView.tapAction = { [weak self] in
            let alertController: UIAlertController = UIAlertController.init(title: "确定删除门卡", message: "删除后若需要在此使用该门卡，请重新模拟", preferredStyle: .alert)
            
            //cancel button
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                //cancel code
            }
            alertController.addAction(cancelAction)
            
            
            //Create an optional action
            let okAction: UIAlertAction = UIAlertAction(title: "确定", style: .default) { action  -> Void in
                // 删除卡片
                
                guard let arr = self?.cardProtocols else {
                    return
                }
                
                
                if arr.count < 1 {
                    return
                }
                
                let cardProtocol = arr[0]
                
                let param: MIAccessControlOperationParam = MIAccessControlOperationParam()
                param.aid = cardProtocol.aid
                
                PublicInterface.shared.pay?.miACCloud.deleteCard(param) { error in
                    guard error == nil else {
                        return
                    }
                    
                    // Goback
                    if PublicInterface.shared.cardExist {
                        DispatchQueue.main.async {
                            self?.navigationController?.popViewController(animated: true)
                            return;
                        }
                    }
                    
                    let count = self?.navigationController!.viewControllers.count
                    
                    for index in (0..<count!).reversed() {
                        let vc = self?.navigationController?.viewControllers[index]
                        
                        if (vc!.isKind(of: CardDetectionViewController.self) && index > 0) {
                            let popVC = self?.navigationController?.viewControllers[index]
                            
                            DispatchQueue.main.async {
                                self?.navigationController?.popToViewController(popVC!, animated: true)
                                return;
                            }
                        }
                    }
                }
                
            }
            alertController.addAction(okAction)
        
            self?.present(alertController, animated: true, completion: nil)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupNavigationBarView() {
        
        let count = self.navigationController!.viewControllers.count
        
        for index in (0..<count).reversed() {
            let vc = self.navigationController?.viewControllers[index]
            
            if (vc!.isKind(of: CardDetectionViewController.self) && index > 0) {
                let popVC = self.navigationController?.viewControllers[index-1]
                navigationBarView.backAction = { [weak self] in
                    self?.navigationController?.popToViewController(popVC!, animated: true)
                }
                break;
            }
        }
    }
    
    
    @IBAction func editButtonClick(_ sender: UIButton) {
        let alertController: UIAlertController = UIAlertController.init(title: "编辑卡片名称", message: nil, preferredStyle: .alert)
        
        //cancel button
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            //cancel code
        }
        alertController.addAction(cancelAction)
        
        //Create an optional action
        let okAction: UIAlertAction = UIAlertAction(title: "确定", style: .default) { action  -> Void in
            if alertController.textFields!.count < 1 {
                return
            }
            
            let name = alertController.textFields![0].text
            
            guard name != nil else {
                return
            }
            
            if name!.isEmpty {
                return
            }
            
            let arr = self.cardProtocols
            
            
            if arr.count < 1 {
                return
            }
            
            var cardProtocol = arr[0]
            
            cardProtocol.name = name!
            
            PublicInterface.shared.pay?.miACCloud.updateAccessCardInfomation(with: cardProtocol){ error in
                
                guard error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                   self.cardNameLabel.text = name!
                }
            }
        }
        
        alertController.addAction(okAction)
        
        alertController.addTextField { textField in
            textField.placeholder  = "输入卡片名称"
            textField.delegate = self
        }
   
        present(alertController, animated: true, completion: nil)
    }
}

extension CardManagerViewController: UITextFieldDelegate {
    
}
