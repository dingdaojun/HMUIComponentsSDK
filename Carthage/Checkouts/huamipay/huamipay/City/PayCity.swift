//
//  PayCity.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/12.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation

public enum PayCity: Equatable {
    case beijin // 北京
    case hefei // 合肥
    case jingjinji // 京津翼 MOT
    case wuhan //武汉
    case jiangsu // 江苏MOT
    case suzhou // 苏州
    case shenzheng // 深圳
    case lingnantong(subCity: CityLingnantong) // 岭南通
    case jilin // 吉林MOT
    case guangxi //  广西MOT
    case zhengzhou // 郑州
    case chongqing // 重庆
    case xian //西安
}

public enum CityLingnantong: Equatable {
    case taizhou // 台州
    case guangzhou // 广州
    case foushan // 佛山
    case zhuhai // 珠海
    case shanwei // 汕尾
    case jiangmen // 江门
    case zhaoqing // 肇庆
    case zhongshan // 中山
    case dongguan // 东莞
    case huizhou // 惠州
    case zhanjiang // 湛江
    case shantou // 汕头
    case shaoguan // 韶关
    case heyuan // 河源
    case yangjiang // 阳江
    case qingyuan // 清远
    case maoming // 茂名
    case meizhou // 梅州
    case chaozhou // 潮州
    case jieyang // 揭阳
    case yunfu // 云浮
}

public struct PayCityInfo {
    public let name: String
    public let code: String
    public let aid: Data
    public let miName: String
    public let miFetchModel: String
    public let city: PayCity
}

public extension PayCity {
    /// 城市信息
    public var info: PayCityInfo {
        get {
            switch self {
            case .beijin:
                return PayCityInfo(name: PayCityBeijin.cityName, code: PayCityBeijin.cityCode, aid: PayCityBeijin.aid, miName: PayCityBeijin.miCardName, miFetchModel: PayCityBeijin.miFetchModel, city: self)
            case .hefei:
                return PayCityInfo(name: PayCityHefei.cityName, code: PayCityHefei.cityCode, aid: PayCityHefei.aid, miName: PayCityHefei.miCardName, miFetchModel: PayCityHefei.miFetchModel, city: self)
            case .jingjinji:
                return PayCityInfo(name: PayCityJingjinji.cityName, code: PayCityJingjinji.cityCode, aid: PayCityJingjinji.aid, miName: PayCityJingjinji.miCardName, miFetchModel: PayCityJingjinji.miFetchModel, city: self)
            case .wuhan:
                return PayCityInfo(name: PayCityWuhan.cityName, code: PayCityWuhan.cityCode, aid: PayCityWuhan.aid, miName: PayCityWuhan.miCardName, miFetchModel: PayCityWuhan.miFetchModel, city: self)
            case .jiangsu:
                return PayCityInfo(name: PayCityJiangsu.cityName, code: PayCityJiangsu.cityCode, aid: PayCityJiangsu.aid, miName: PayCityJiangsu.miCardName, miFetchModel: PayCityJiangsu.miFetchModel, city: self)
            case .suzhou:
                return PayCityInfo(name: PayCitySuzhou.cityName, code: PayCitySuzhou.cityCode, aid: PayCitySuzhou.aid, miName: PayCitySuzhou.miCardName, miFetchModel: PayCitySuzhou.miFetchModel, city: self)
            case .shenzheng:
                return PayCityInfo(name: PayCityShenzhen.cityName, code: PayCityShenzhen.cityCode, aid: PayCityShenzhen.aid, miName: PayCityShenzhen.miCardName, miFetchModel: PayCityShenzhen.miFetchModel, city: self)
            case .lingnantong(let subCity):
                PayCityLingnantong.city = subCity
                return PayCityInfo(name: PayCityLingnantong.cityName, code: PayCityLingnantong.cityCode, aid: PayCityLingnantong.aid, miName: PayCityLingnantong.miCardName, miFetchModel: PayCityLingnantong.miFetchModel, city: self)
            case .jilin:
                return PayCityInfo(name: PayCityJilin.cityName, code: PayCityJilin.cityCode, aid: PayCityJilin.aid, miName: PayCityJilin.miCardName, miFetchModel: PayCityJilin.miFetchModel, city: self)
            case .guangxi:
                return PayCityInfo(name: PayCityGuangxi.cityName, code: PayCityGuangxi.cityCode, aid: PayCityGuangxi.aid, miName: PayCityGuangxi.miCardName, miFetchModel: PayCityGuangxi.miFetchModel, city: self)
            case .zhengzhou:
                return PayCityInfo(name: PayCityZhengzhou.cityName, code: PayCityZhengzhou.cityCode, aid: PayCityZhengzhou.aid, miName: PayCityZhengzhou.miCardName, miFetchModel: PayCityZhengzhou.miFetchModel, city: self)
            case .chongqing:
                return PayCityInfo(name: PayCityChongqing.cityName, code: PayCityChongqing.cityCode, aid: PayCityChongqing.aid, miName: PayCityChongqing.miCardName, miFetchModel: PayCityChongqing.miFetchModel, city: self)
            case .xian:
                return PayCityInfo(name: PayCityXiAn.cityName, code: PayCityXiAn.cityCode, aid: PayCityXiAn.aid, miName: PayCityXiAn.miCardName, miFetchModel: PayCityXiAn.miFetchModel, city: self)
            }
        }
    }
    
    /// 所有城市
    public static var all: [PayCityInfo] {
        get {
            return [PayCity.beijin.info,
                    PayCity.hefei.info,
                    PayCity.jingjinji.info,
                    PayCity.wuhan.info,
                    PayCity.jiangsu.info,
                    PayCity.suzhou.info,
                    PayCity.shenzheng.info,
                    PayCity.lingnantong(subCity: .guangzhou).info,
                    PayCity.jilin.info,
                    PayCity.guangxi.info,
                    PayCity.zhengzhou.info,
                    PayCity.chongqing.info,
                    PayCity.xian.info]
        }
    }
    
    /// 所有岭南通城市
    public static var allLingnantong: [PayCityInfo] {
        get {
            return [PayCity.lingnantong(subCity: .chaozhou).info,
                    PayCity.lingnantong(subCity: .dongguan).info,
                    PayCity.lingnantong(subCity: .foushan).info,
                    PayCity.lingnantong(subCity: .guangzhou).info,
                    PayCity.lingnantong(subCity: .heyuan).info,
                    PayCity.lingnantong(subCity: .huizhou).info,
                    PayCity.lingnantong(subCity: .jiangmen).info,
                    PayCity.lingnantong(subCity: .jieyang).info,
                    PayCity.lingnantong(subCity: .maoming).info,
                    PayCity.lingnantong(subCity: .zhuhai).info,
                    PayCity.lingnantong(subCity: .zhongshan).info,
                    PayCity.lingnantong(subCity: .zhaoqing).info,
                    PayCity.lingnantong(subCity: .zhanjiang).info,
                    PayCity.lingnantong(subCity: .yunfu).info,
                    PayCity.lingnantong(subCity: .yangjiang).info,
                    PayCity.lingnantong(subCity: .taizhou).info,
                    PayCity.lingnantong(subCity: .shaoguan).info,
                    PayCity.lingnantong(subCity: .shanwei).info,
                    PayCity.lingnantong(subCity: .shantou).info,
                    PayCity.lingnantong(subCity: .qingyuan).info,
                    PayCity.lingnantong(subCity: .meizhou).info,]
        }
    }
    
    /// 根据appCode查找城市
    ///
    /// - Parameter cityCode: 城市ID
    /// - Returns: PayCity
    public static func cityCode(_ code: String) -> PayCity? {
        let cities = PayCity.all.filter { return $0.code == code }
        guard cities.count == 0 else { return cities.first!.city }
        let lnts = PayCity.allLingnantong.filter { return $0.code == code }
        guard lnts.count == 0 else { return lnts.first!.city }
        return nil
    }
    
    public static func miCarName(_ name: String) -> PayCity? {
        let cities = PayCity.all.filter { return $0.miName == name }
        guard cities.count == 0 else { return cities.first!.city }
        let lnts = PayCity.allLingnantong.filter { return $0.miName == name }
        guard lnts.count == 0 else { return lnts.first!.city }
        return nil
    }
}

extension PayCity {
    /// 各城市实体类
    var cityProtocol: CityCardApduProtocol {
        switch self {
        case .beijin:
            return PayCityBeijin()
        case .hefei:
            return PayCityHefei()
        case .jingjinji:
            return PayCityJingjinji()
        case .wuhan:
            return PayCityWuhan()
        case .jiangsu:
            return PayCityJiangsu()
        case .suzhou:
            return PayCitySuzhou()
        case .shenzheng:
            return PayCityShenzhen()
        case .lingnantong(let subCity):
            PayCityLingnantong.city = subCity
            return PayCityLingnantong()
        case .jilin:
            return PayCityJilin()
        case .guangxi:
            return PayCityGuangxi()
        case .chongqing:
            return PayCityChongqing()
        case .zhengzhou:
            return PayCityZhengzhou()
        case .xian:
            return PayCityXiAn()
        }
    }
}

extension PayCity {
    /// 是否为MOT
    public var isMOT: Bool {
        switch self {
        case .jingjinji, .jilin, .guangxi, .jiangsu: return true
        default: return false
        }
    }
}
