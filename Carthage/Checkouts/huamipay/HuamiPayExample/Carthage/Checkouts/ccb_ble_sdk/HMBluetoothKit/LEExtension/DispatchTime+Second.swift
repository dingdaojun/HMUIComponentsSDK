//
//  DispatchTime+Second.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/2.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}


extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
