//
//  OpenCardSimulationViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import huamipay
import huamipay

class OpenCardSimulationViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var progress: UIProgressView!
    
    var cardTag: CardTag?
    
    var collcetionViewTimer = Timer()
    
    var progressTimer = Timer()
    
    var currentPage = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if  collcetionViewTimer.isValid {
            collcetionViewTimer.invalidate()
        }
        
        collcetionViewTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(OpenCardSimulationViewController.nextPage), userInfo: nil, repeats: true)
        collcetionViewTimer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if  collcetionViewTimer.isValid {
            collcetionViewTimer.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = view.bounds.size.width
        let statusBarHeight: CGFloat = 20
        let navigationBarHeight: CGFloat = 64
        let bottomSeperatorHeight: CGFloat = 100
        let height = view.bounds.size.height - statusBarHeight - navigationBarHeight - bottomSeperatorHeight
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumLineSpacing = 0
        
        collectionView.register(UINib.init(nibName: "OpenCardCollectionViewCell", bundle: Bundle.NFCCardemu), forCellWithReuseIdentifier: "OpenCardCollectionViewCell")

        progress.progress = 0.0
        progressTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(OpenCardSimulationViewController.progressAnimation), userInfo: nil, repeats: true)
        progressTimer.fire()
        
        guard let card = self.cardTag else {
            return;
        }
        
        let param = MIAccessControlOperationParam.init(uid: card.uid, sak: card.sak, atqa: card.atqa)

        PublicInterface.shared.pay?.miACCloud.installCard(param) { sessionID, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    let vc : CardSimulationFailureViewController = UIStoryboard.init(openCard: .OpenCard).instantiate()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return;
            }

            guard sessionID != nil else {
                return;
            }

            DispatchQueue.main.async {
                let vc : CardSimulationSuccessViewController = UIStoryboard.init(openCard: .OpenCard).instantiate()
                vc.sessionID = sessionID!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        };
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func nextPage() {
        currentPage = (currentPage + 1) % 2
        collectionView.setContentOffset(CGPoint.init(x: CGFloat(currentPage) * UIScreen.main.bounds.width, y: 0.0), animated: true)
        pageControl.currentPage = currentPage
    }
    
    @objc func progressAnimation() {
        if progress.progress < 0.9 {
            progress.progress += 0.1
        }
    }
}

extension OpenCardSimulationViewController: UICollectionViewDelegate {
    
}

extension OpenCardSimulationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OpenCardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenCardCollectionViewCell", for: indexPath) as! OpenCardCollectionViewCell
        
        if indexPath.item == 0 {
            cell.titleLabel.text = "将门卡设置为默认卡靠近门禁直接刷卡"
            cell.iamgeView.image = UIImage.init(nfcCardemuNamed: "imgDoorCardAnalog2")
            cell.rightContraints.constant = 50
            cell.leftConstraints.constant = 80
        }
        
        if indexPath.item == 1 {
            cell.titleLabel.text = "手环贴近门禁刷卡感应区域即可感应"
            cell.iamgeView.image = UIImage.init(nfcCardemuNamed: "imgDoorCardAnalog3")
            cell.rightContraints.constant = 80
            cell.leftConstraints.constant = 50
        }
        
        return cell
    }
}


