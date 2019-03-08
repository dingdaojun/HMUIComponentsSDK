//
//  AppDelegate.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/10/20.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import UIKit
import HMBluetoothKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let _ = LECentralManager.sharedInstance
        let _ = DeviceManager.sharedInstance
        configLog()
        
        let connectedListViewController = ConnectedListViewController(style: .plain)
        let nav = UINavigationController(rootViewController: connectedListViewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.backgroundColor = UIColor.red
        self.window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let firmwareFileName = url.lastPathComponent
        let firmwareFolder = DeviceViewController.firmwareFolder()
        let folderName = firmwareFolder.folderName
        self.createFolder(folderName: folderName)

        let manager = FileManager.default
        var filePath: String = firmwareFolder.path
        filePath += "/\(firmwareFileName)"

        do {
            let isExist = manager.fileExists(atPath: filePath)
            if isExist { try manager.removeItem(atPath: filePath) }
            try manager.copyItem(at: url, to: URL(fileURLWithPath: filePath, isDirectory: false))
            DeviceViewController.successTips(title: "提醒", subTitle: "保存固件文件成功")
        } catch {
            DeviceViewController.failTips(title: "提醒", subTitle: "保存固件文件失败: \(error)")
        }

        do {
            var inboxPath: String = NSHomeDirectory()
            inboxPath += "/Documents/Inbox/"
            try manager.removeItem(at: URL(fileURLWithPath: inboxPath, isDirectory: true))
        } catch {
            print("删除InBox")
        }

        return true
    }
    
    func createFolder(folderName: String){
        let firmwareFolder = DeviceViewController.firmwareFolder()
        let manager = FileManager.default
        let filePath: String = firmwareFolder.path
        let folderPathURL = URL(fileURLWithPath: filePath, isDirectory: true)
        print("文件夹: \(String(describing: folderPathURL))")
        let exist = manager.fileExists(atPath: filePath)
        if !exist {
            try! manager.createDirectory(at: folderPathURL, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

