//
//  LogViewController.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/3/6.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import UIKit
import HMLog

class LogViewController: UITableViewController {
    var logs: Array<HMLogItem> = []
    let cellIdentifier = "LogCellIdentifier"
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.title = "日志"
        let xib = UINib(nibName: "LogCell", bundle: nil)
        self.tableView.register(xib, forCellReuseIdentifier: cellIdentifier)
        let clearItem = UIBarButtonItem(title: "清空", style: .done, target: self, action: #selector(clearLog))
        self.navigationItem.rightBarButtonItem = clearItem
        
        DispatchQueue.global().async {
            self.logs = HMDatabaseLogger.init(configuration: LogHelper.logConfig()).queryLogItems()
            self.logs.sort(by: { (l, r) -> Bool in
                return l.date > r.date
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func clearLog() {
        let filePath = HMLogConfiguration.rootDirectory
        try? FileManager.default.removeItem(atPath: filePath!)
        
        DispatchQueue.main.async {
            self.logs = []
            self.tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LogCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! LogCell
        let item = logs[indexPath.row]
        cell.update(item: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
}
