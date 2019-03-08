//
//  CityProtocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/20.
//

import Foundation


public  protocol CityCardApduProtocol {
    static var aid: Data { get }
    static var cityName: String { get }
    static var cityCode: String { get }
    static var miCardName: String { get }
    static var miFetchModel: String { get }
    
    func getBance() throws -> Int
    func getDealRecords() throws -> [DealInfo]
    func getRechargeRecords() throws -> [DealInfo]
    func getCardInformation() throws -> PayCardInfo
    
    func setDefault(_ non: Bool, for city: PayCity) throws
    func isDefault() throws -> Bool
}
