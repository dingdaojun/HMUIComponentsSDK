//
//  CardView.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/21.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import huamipay
import SDWebImage

class CardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var imageView: UIImageView = UIImageView()
    var nameLable: UILabel = UILabel()
    var defaultLabel: UILabel = UILabel()
    var editAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = frame.size.width
        let height = frame.size.height
        
        imageView = UIImageView.init(frame: frame)
        imageView.image = UIImage.init(nfcCardemuNamed: "imgDoorCard")
        self.addSubview(imageView)
        
        nameLable = UILabel.init(frame: CGRect.init(x: 20, y: 14, width: 100, height: 28))
        nameLable.textColor = .white
        
        self.addSubview(nameLable)
        
        defaultLabel = UILabel.init(frame: CGRect.init(x: width - 118, y: 14, width: 100, height: 28) )
        defaultLabel.textAlignment = .right
        self.addSubview(defaultLabel)
        
        let editBtn = UIButton.init(frame: CGRect.init(x: width - 98, y: height - 42, width: 80, height: 28))
        editBtn.setTitle("编辑名称", for: .normal)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(CardView.tapAction(_:) ))
        editBtn.addGestureRecognizer(tap)
        
//        editBtn.setImage(UIImage.init(nfcCardemuNamed: "12ArrowR"), for: .normal)
        
        self.addSubview(editBtn)
        
        self.isUserInteractionEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        editAction?()
    }
    
    func config(_ config: PayACCardProtocol) {
        nameLable.text = config.name
        
        if !config.art.isEmpty  {
            imageView.sd_setImage(with: URL.init(string: config.art), placeholderImage: UIImage.init(nfcCardemuNamed: "imgDoorCard"))
        }
    }
}
