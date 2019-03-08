//
//  FileListProfile.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/14.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import SwiftDate


struct FileInfomation {
    var filePath: String
    var fileName: String
    var fileDate: Date?
}

struct FileListProfile {
    static func fileList(folderPath: String) -> Array<FileInfomation> {
        let manager = FileManager.default
        let contentsOfPath = try? manager.contentsOfDirectory(atPath: folderPath)
        var fileArray: [FileInfomation] = []
        
        if let contents = contentsOfPath {
            for fileName in contents {
                let filePath = "\(folderPath)/\(fileName)"
                let attributes = try? manager.attributesOfItem(atPath: filePath)
                let fileDate = attributes?[FileAttributeKey.creationDate] as? Date
                let fileInfomation = FileInfomation(filePath: filePath, fileName: fileName, fileDate: fileDate)
                fileArray.append(fileInfomation)
            }
        }
        
        let sortFileArray = fileArray.sorted { (lft, rft) -> Bool in
            return lft.fileDate! > rft.fileDate!
        }
        
        return sortFileArray
    }
    
    static func deleteFile(filePath: String) {
        let manager = FileManager.default
        do {
            try manager.removeItem(atPath: filePath)
        } catch  {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "删除失败", subTitle: "失败原因: \(error)")
            }
        }
    }
}
