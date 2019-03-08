//
//  CardSimulationSuccessViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import huamipay
import CryptoSwift

class CardSimulationSuccessViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var labelSchool: UILabel!
    
    var sessionID: String = ""
    
    var cardInfo: PayACCardProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage.init(nfcCardemuNamed: "SimulationSuccess")!.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor.init(hex: "1EB569")
        
        finishButton.layer.masksToBounds = true
        finishButton.layer.cornerRadius = 20
        
        let homeGesture = UITapGestureRecognizer.init(target: self, action: #selector(CardSimulationSuccessViewController.labelClick) )
        let companyGesture = UITapGestureRecognizer.init(target: self, action: #selector(CardSimulationSuccessViewController.labelClick) )
        let schoolGesture = UITapGestureRecognizer.init(target: self, action: #selector(CardSimulationSuccessViewController.labelClick) )
        
        labelHome.addGestureRecognizer(homeGesture)
        labelCompany.addGestureRecognizer(companyGesture)
        labelSchool.addGestureRecognizer(schoolGesture)
        
        textField.delegate = self
        
        PublicInterface.shared.pay?.miACCloud.cardInfomation(with: sessionID ) {
            cardPtotocol, error in
            
            guard error == nil else {
                return
            }
            
            self.cardInfo = cardPtotocol
            
            PublicInterface.shared.operationQueue.addOperation {
                if let aidStr = self.cardInfo?.aid {
                    let data = Data.init(hex: aidStr)
                    print("设置默认卡 \(aidStr)")
                    do {
                        try PayCityBase().setDefault(true, aid: data)
                        print("设置默认卡成功 \(aidStr)")
                    } catch {
                        print("设置默认卡失败 \(aidStr)")
                    }
                    
                    PublicInterface.shared.delegate?.swapDefaultCard(actionType: 0x02, aid: aidStr)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func finishButtonClick(_ sender: UIButton) {
        guard let text = textField.text, !text.isEmpty else {
            Toast.makeToast(title: "请输入备注名")
            return
        }
        
        if cardInfo == nil {
            Toast.makeToast(title: "未获取卡信息")
            return
        }
        
        cardInfo?.name = text
        PublicInterface.shared.pay?.miACCloud.updateAccessCardInfomation(with: cardInfo!){ error in
            
            guard error == nil else {
                return
            }
            
            PublicInterface.shared.pay?.miACCloud.accessCardList { cardProtocols, error in
                guard error ==  nil else {
                    return
                }
                
                guard let arr = cardProtocols, arr.count > 0  else {
                    return
                }
            
                DispatchQueue.main.async {
                    let vc : CardListViewController = UIStoryboard.init(openCard: .OpenCard).instantiate()
                    vc.cardProtocols = arr
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func labelClick(gesture : UITapGestureRecognizer) {
        let view = gesture.view
        
        guard view != nil else {
            return
        }
        
        guard view!.isKind(of: UILabel.self) else {
            return
        }
        
        let label = view! as! UILabel
        
        textField.text = label.text;
    }

}

extension CardSimulationSuccessViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}
