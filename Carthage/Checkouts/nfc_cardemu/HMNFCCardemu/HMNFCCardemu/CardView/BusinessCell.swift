//
//  BusinessCell.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/21.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

}
