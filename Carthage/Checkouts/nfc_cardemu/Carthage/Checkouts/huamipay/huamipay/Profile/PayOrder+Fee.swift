//
//  PayOrderInfo+Fee.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/26.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


/// 订单费用
public struct PayOrderFee {
    public struct Fee {
        /// feeID
        public var feeID: String = ""
        /// 正常开卡费用
        public var normalOpenCard: Int = 0
        /// 优惠开卡费用
        public var discountOpenCard: Int = 0
        /// 正常充值费用
        public var normalCharge: Int = 0
        /// 优惠充值费用
        public var discountCharge: Int = 0
        /// 正常迁入费用
        public var normalShiftIn: Int = 0
        /// 优惠迁入费用
        public var discountShiftIn: Int = 0
        /// 正常迁出费用
        public var normalShiftOut: Int = 0
        /// 优惠迁出费用
        public var discountShiftOut: Int = 0
        
        
        public init() {}
        
        /// 是否有开卡优惠
        ///
        /// - Returns: true 有优惠；false 无优惠
        public func isOpenCardDiscount() -> Bool {
            guard (normalOpenCard - discountOpenCard) == 0  else { return true }
            return false
        }
        
        /// 是否有充值优惠
        ///
        /// - Returns: true 有优惠； false 无优惠
        public func isChargeDiscount() -> Bool {
            guard (normalCharge - discountCharge) == 0  else { return true }
            return false
        }
    }
    
    /// 订单类型
    public var type: PayOrderType
    /// 城市
    public var city: PayCity
    /// 费用
    public var fees: [Fee]
    
    public init() {
        self.type = .all
        self.city = .guangxi
        self.fees = []
    }
}
