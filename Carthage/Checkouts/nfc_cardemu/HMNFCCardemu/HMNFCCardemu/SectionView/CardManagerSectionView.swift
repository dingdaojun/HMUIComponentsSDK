//
//  CardManagerSectionView.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit

class CardManagerSectionView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    
    var tapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }

    
    func configuration() {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(CardManagerSectionView.tapClick) )
        
        self.addGestureRecognizer(gesture)
    }
    
    @objc func tapClick() {
        tapAction?()
    }
}
