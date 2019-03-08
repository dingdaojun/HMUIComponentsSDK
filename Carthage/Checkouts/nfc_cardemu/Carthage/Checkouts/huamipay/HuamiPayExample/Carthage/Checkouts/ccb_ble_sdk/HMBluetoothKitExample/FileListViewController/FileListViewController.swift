//
//  FileListViewController.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/14.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import UIKit


typealias SelectedFileCallBack = (_ fileInfomation: FileInfomation) -> Void

class FileListViewController: UITableViewController {
    private var fileList: [FileInfomation] = []
    var folderPath: String
    var navigationTitle: String
    var selectedFileCallBack: SelectedFileCallBack?
    
    init(folderPath: String, title: String) {
        self.folderPath = folderPath
        self.navigationTitle = title
        super.init(style: .plain)
        fileList = FileListProfile.fileList(folderPath: folderPath)
        self.title = self.navigationTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13.0)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)]
    }
    
    @objc func deletePeripehral() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("删除") {
                
            }
            
            alertView.addButton("不删除") {}
            
            let msg: String = "删除后，数据将不在存储，如再此需要测试此设备，需前往扫描页面进行绑定后，到详情页进行保存即可"
            
            let _ = alertView.showWait("提醒", subTitle: msg, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "fileListIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let fileInfomation = fileList[indexPath.row]
        cell?.textLabel?.text = fileInfomation.fileName
        
        if let fileDate = fileInfomation.fileDate {
            print("fileDate: \(fileDate)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringDate = dateFormatter.string(from: fileDate)
            cell?.detailTextLabel?.text = "日期: \(stringDate)"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFileCallBack?(fileList[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 设置单元格的编辑的样式
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // 设置确认删除按钮的文字
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "确认删除"
    }
    
    // 单元格编辑后的响应方法
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fileInfomation = fileList[indexPath.row]
            FileListProfile.deleteFile(filePath: fileInfomation.filePath)
            
            DispatchQueue.main.async {
                self.fileList = FileListProfile.fileList(folderPath: self.folderPath)
                tableView.reloadData()
            }
        }
    }
}

extension FileListViewController {
    
}
