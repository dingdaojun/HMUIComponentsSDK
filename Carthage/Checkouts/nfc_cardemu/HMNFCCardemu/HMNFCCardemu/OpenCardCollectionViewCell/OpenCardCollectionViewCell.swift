//
//  OpenCardCollectionViewCell.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit

class OpenCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rightContraints: NSLayoutConstraint!
    @IBOutlet weak var leftConstraints: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iamgeView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
