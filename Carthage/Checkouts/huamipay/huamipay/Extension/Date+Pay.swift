//
//  Date+Pay.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/21.
//

import Foundation

extension Date {
    /// 4位数据转YYYYMMDD
    ///
    /// - Parameter resData: 数据
    /// - Returns: date
    public static func bytesToPayDate(resData: Data) -> Date {
        let year = resData.subdata(in: 0..<2).toHexString()
        let month = resData.subdata(in: 2..<3).toHexString()
        let day = resData.subdata(in: 3..<4).toHexString()
        let dateString = "\(year)-\(month)-\(day)"
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormate.date(from: dateString) else { return Date() }
        return date
    }
    
    /// 3位数据转YYYYMMDD
    ///
    /// - Parameter resData: 数据
    /// - Returns: date
    public static func threeBytesToPayDate(resData: Data) -> Date {
        let year = Int(resData.subdata(in: 0..<1).toHexString())! + 2000
        let month = Int(resData.subdata(in: 1..<2).toHexString())!
        let day = Int(resData.subdata(in: 2..<3).toHexString())!
        let dateString = "\(year)-\(month)-\(day)"
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        return dateFormate.date(from: dateString)!
    }
}
