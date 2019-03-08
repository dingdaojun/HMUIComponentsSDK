//
//  ValueSemaphore.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/4.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

public typealias BlockingQueue = ValueSemaphore<(Data, Error?)>

public class ValueSemaphore<T> {
    private let semaphore: DispatchSemaphore
    private var value: [T] = []
    private let queue = DispatchQueue(label: "Semaphore")
    
    public init(_ count: Int = 0) {
        semaphore = DispatchSemaphore(value: count)
    }
    
    public func push(_ newValue: T) {
        queue.async { [unowned self] in
            self.value.append(newValue)
            self.semaphore.signal()
        }
    }
    
    public func pop(timeout seconds: Double = 30.0) throws -> T {
        var _value: T!
        guard semaphore.wait(timeout: DispatchTime.now() + seconds) == .success else { throw LEPeripheralError.timeout }
        queue.sync { [unowned self] in
            _value = self.value.removeFirst()
        }
        return _value
    }
}
