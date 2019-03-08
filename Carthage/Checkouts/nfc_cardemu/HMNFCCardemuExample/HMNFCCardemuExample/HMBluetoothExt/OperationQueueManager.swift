//
//  OperationQueueManager.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/9.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

class OperationQueueManager: NSObject {
    static let sharedInstance = OperationQueueManager()
    fileprivate var operationQueueDictionary: Dictionary<UUID, OperationQueue> = [:]
    lazy var bleQueue = OperationQueue()
    
    private override init() {
        super.init()
    }
    
    public func operationQueue(_ identifier: UUID) -> OperationQueue {
        if let operationQueue = operationQueueDictionary[identifier] { return operationQueue }
        let queue = OperationQueue()
        queue.name = identifier.uuidString
        return queue
    }
    
    public func runningOperation(_ identifier: UUID) -> [Operation] {
        let queue = operationQueue(identifier)
        let executingOperations = queue.operations.filter { (operation) -> Bool in
            return operation.isExecuting
        }
        return executingOperations
    }
    
    public func addOperation(_ operation: Operation, for indentifier: UUID) {
        let queue = operationQueue(indentifier)
        queue.addOperation(operation)
        operationQueueDictionary[indentifier] = queue
    }
    
    public func removeAllOperation(_ identifier: UUID? = nil) {
        if let uuid = identifier {
            let queue = operationQueue(uuid)
            queue.cancelAllOperations()
            for operation in runningOperation(uuid) { operation.cancel() }
            operationQueueDictionary.removeValue(forKey: uuid)
        } else {
            for (uuid, queue) in operationQueueDictionary {
                queue.cancelAllOperations()
                for operation in runningOperation(uuid) { operation.cancel() }
            }
            operationQueueDictionary.removeAll()
        }
    }
}
