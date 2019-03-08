//
//  PaySyncValue.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/2/2.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation

typealias PayBlockingQueue = PaySyncValue<(String, (code: Int, msg: String)?)>

public class PaySyncValue<T> {
    private let semaphore: DispatchSemaphore
    private var value: [T] = []
    private let queue = DispatchQueue(label: "PaySemaphore")
    
    public init(_ count: Int = 0) {
        semaphore = DispatchSemaphore(value: count)
    }
    
    public func push(_ newValue: T) {
        queue.async {
            self.value.append(newValue)
            self.semaphore.signal()
        }
    }
    
    public func pop(timeout seconds: Double = 5.0) throws -> T {
        var _value: T!
        guard semaphore.wait(timeout: DispatchTime.now() + seconds) == .success else { throw PayError.timeout }
        queue.sync {
            _value = self.value.removeFirst()
        }
        return _value
    }
}
