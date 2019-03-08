//
//  CardListViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/21.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import huamipay
import CryptoSwift

class CardListViewController: UIViewController {

    @IBOutlet weak var navigationBarView: NavigationBarView!
    @IBOutlet weak var cardAnimationView: CardAnimationView!
    @IBOutlet weak var cardHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var actionCells: [String] = []
    var cardProtocols: [PayACCardProtocol] = []
    var latestCardProtocol: PayACCardProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var height: CGFloat = 245.0
        
        var options = CardAnimationOption()
        if cardProtocols.count == 1 {
            options = CardAnimationOption.init(numberOfVisibleItems: 1, offset:(horizon: 0, vertical: 0), showedCyclically: true, isPanGestureEnabled: false)
        } else {
            options = CardAnimationOption.init(numberOfVisibleItems: cardProtocols.count, offset:(horizon: 0, vertical: -30), showedCyclically: true, isPanGestureEnabled: true)
            height +=  (CGFloat ( cardProtocols.count - 1 ) * 30 )
        }
        
        cardHeightConstraints.constant = height
        cardAnimationView.delegate = self
        cardAnimationView.dataSource = self
    
        cardAnimationView.options = options
        cardAnimationView.reloadData()
        latestCardProtocol = cardProtocols.last
        
        tableView.register(UINib.init(cardemulet: "BusinessCell"), forCellReuseIdentifier: "BusinessCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        self.actionCells = ["常见问题","删除卡片"]
        PublicInterface.shared.operationQueue.addOperation {
            guard let card = self.cardProtocols.last else {
                return;
            }
            
            self.defaultUIAction(card.aid)
        }
        
        setupNavigationBarView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBarView() {
        // Goback
        if PublicInterface.shared.cardExist {
            navigationBarView.backAction = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                return
            }
            return
        }
        
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

}

extension CardListViewController {
    func defaultUIAction(_ aidStr: String) {
        let data = Data.init(hex: aidStr)
        
        guard let isDefault = try? PayCityBase().isDefault(data) else {
            return;
        }
        
        if isDefault {
            self.actionCells = ["常见问题","删除卡片"]
        } else {
            self.actionCells = ["常见问题","删除卡片","设置默认卡"]
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func deleteCard() -> Void {
        let alertController: UIAlertController = UIAlertController.init(title: "确定删除门卡", message: "删除后若需要在此使用该门卡，请重新模拟", preferredStyle: .alert)
        
        //cancel button
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            //cancel code
        }
        alertController.addAction(cancelAction)
        
        
        //Create an optional action
        let okAction: UIAlertAction = UIAlertAction(title: "确定", style: .default) { action  -> Void in
            
            guard let cardProtocol = self.latestCardProtocol else {
                return
            }
            
            // 删除卡片
            HUD.show(withType: .Loading, title: "正在删除")
            
            let param: MIAccessControlOperationParam = MIAccessControlOperationParam()
            param.aid = cardProtocol.aid
            
            PublicInterface.shared.pay?.miACCloud.deleteCard(param) { error in
                HUD.hide()
                guard error == nil else {
                    HUD.show(withType: .Error, title: "删除失败")
                    return
                }
                
                HUD.show(withType: .Success, title: "删除成功")
                
                PublicInterface.shared.delegate?.swapDefaultCard(actionType: 0x02, aid: nil)
                
                if self.cardProtocols.count == 1 {
                    
                    // Goback
                    if PublicInterface.shared.cardExist {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            return;
                        }
                        return
                    }
                    
                    let count = self.navigationController!.viewControllers.count
                    
                    for index in (0..<count).reversed() {
                        let vc = self.navigationController?.viewControllers[index]
                        
                        if (vc!.isKind(of: CardDetectionViewController.self) && index > 0) {
                            let popVC = self.navigationController?.viewControllers[index-1]
                            
                            HUD.hide()
                            DispatchQueue.main.async {
                                self.navigationController?.popToViewController(popVC!, animated: true)
                                return;
                            }
                        }
                    }
                    return;
                }
                
                let arr = self.cardProtocols.filter{ card in
                    return card.aid == cardProtocol.aid
                }
                
                self.cardProtocols = arr
                
                DispatchQueue.main.async {
                    self.cardAnimationView.reloadData()
                }
                
                self.latestCardProtocol = self.cardProtocols.last
                PublicInterface.shared.operationQueue.addOperation {
                    guard let card = self.cardProtocols.last else {
                        return;
                    }
                    
                    let aidStr = card.aid
                    self.defaultUIAction(aidStr)
                    
                    HUD.hide()
                }
            }
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc : CardProblemViewController = UIStoryboard.init(openCard: .OpenCard).instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
            return;
        }
        
        if indexPath.row == 1 {
            self.deleteCard()
            return;
        }
        
        if indexPath.row == 2 {
            PublicInterface.shared.operationQueue.addOperation {
                guard let aidStr = self.latestCardProtocol?.aid else {
                    DispatchQueue.main.async {
                        HUD.show(withType: .Error, title: "设置失败")
                    }
                    return
                }
                
                do {
                    let data = Data.init(hex: aidStr)
                    try PayCityBase().setDefault(true, aid: data)
                } catch {
                    DispatchQueue.main.async {
                        HUD.show(withType: .Error, title: "设置失败")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    HUD.show(withType: .Success, title: "设置成功")
                }
                
                self.actionCells = ["常见问题","删除卡片"]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension CardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BusinessCell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.infoLabel.text = actionCells[indexPath.row]
        return cell;
    }
}

extension CardListViewController: CardAnimationViewDataSource {
    func numberOfTotalCards(in cards: CardAnimationView) -> Int {
        return cardProtocols.count
    }
    
    func view(for cards:CardAnimationView, index:Int, reusingView: UIView?) -> UIView {
        
        let view = CardView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 215))
        view.config(cardProtocols[index])
        view.editAction = { [weak self] in
            
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
                
                guard var cardProtocol = self?.cardProtocols[index] else {
                    return
                }
                
                cardProtocol.name = name!
                
                PublicInterface.shared.pay?.miACCloud.updateAccessCardInfomation(with: cardProtocol){ error in
                    
                    guard error == nil else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        view.nameLable.text = name!
                    }
                }
            }
            
            alertController.addAction(okAction)
            
            alertController.addTextField { textField in
                textField.placeholder  = "输入卡片名称"
            }
            
            self?.present(alertController, animated: true, completion: nil)
        }
        
        return view
    }
}

extension CardListViewController: CardAnimationViewDelegate {
    func cards(_ cards: CardAnimationView, didRemovedItemAt index: Int) {
        let nextIndex = (index + 1) % cardProtocols.count
        
        let card = cardProtocols[nextIndex]
        
        PublicInterface.shared.operationQueue.addOperation {
            let aidStr = card.aid
            
            self.defaultUIAction(aidStr)
        }
    }
}
