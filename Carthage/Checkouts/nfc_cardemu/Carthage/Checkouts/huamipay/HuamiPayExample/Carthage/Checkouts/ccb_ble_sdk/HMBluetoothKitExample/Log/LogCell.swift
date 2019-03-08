//
//  LogCell.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/3/7.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import UIKit
import HMLog

class LogCell: UITableViewCell  {
    @IBOutlet weak var logTypeLabel: UILabel!
    @IBOutlet weak var logTagLabel: UILabel!
    @IBOutlet weak var logTimeLabel: UILabel!
    @IBOutlet weak var logContentTextView: UITextView!
    
    func update(item: HMLogItem) {
        logTypeLabel.text = item.levelText()
        switch item.level {
        case .error:
            logTypeLabel.textColor = UIColor.white
            logTypeLabel.backgroundColor = UIColor.red
        case .warning:
            logTypeLabel.textColor = UIColor.blue
            logTypeLabel.backgroundColor = UIColor.yellow
        default:
            logTypeLabel.textColor = UIColor.black
            logTypeLabel.backgroundColor = UIColor.clear
        }
        
        logTagLabel.text = item.tag
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // 设置时区
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        logTimeLabel.text = dateFormatter.string(from: item.date)
        logContentTextView.text = item.content
    }
}
