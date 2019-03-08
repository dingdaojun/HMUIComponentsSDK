//
//  PayCitySwitch.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/26.
//

import Foundation

public struct PayCitySwitch {
    public static func generateCity(_ payCity: PayCity) -> CityCardApduProtocol {
        switch payCity {
        case .beijin:
            return PayCityBeijin()
        case .hefei:
            return PayCityHefei()
        case .jingjinji:
            return PayCityJingjinji()
        case .wuhan:
            return PayCityWuhan()
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
        }
    }
    
    public static func cityStaticInformation(_ payCity: PayCity) -> (cityName: String, cityCode: String, aid: Data) {
        switch payCity {
        case .beijin:
            return (PayCityBeijin.cityName, PayCityBeijin.cityCode, PayCityBeijin.aid)
        case .hefei:
            return (PayCityHefei.cityName, PayCityHefei.cityCode, PayCityHefei.aid)
        case .jingjinji:
            return (PayCityJingjinji.cityName, PayCityJingjinji.cityCode, PayCityJingjinji.aid)
        case .wuhan:
            return (PayCityWuhan.cityName, PayCityWuhan.cityCode, PayCityWuhan.aid)
        case .suzhou:
            return (PayCitySuzhou.cityName, PayCitySuzhou.cityCode, PayCitySuzhou.aid)
        case .shenzheng:
            return (PayCityShenzhen.cityName, PayCityShenzhen.cityCode, PayCityShenzhen.aid)
        case .lingnantong(let subCity):
            PayCityLingnantong.city = subCity
            return (PayCityLingnantong.cityName, PayCityLingnantong.cityCode, PayCityLingnantong.aid)
        case .jilin:
            return (PayCityJilin.cityName, PayCityJilin.cityCode, PayCityJilin.aid)
        case .guangxi:
            return (PayCityGuangxi.cityName, PayCityGuangxi.cityCode, PayCityGuangxi.aid)
        case .zhengzhou:
            return (PayCityZhengzhou.cityName, PayCityZhengzhou.cityCode, PayCityZhengzhou.aid)
        case .chongqing:
            return (PayCityChongqing.cityName, PayCityChongqing.cityCode, PayCityChongqing.aid)
        }
    }
    
    public static func allCity() -> [(cityName: String, cityCode: String, aid: Data, city: PayCity)] {
        return [(PayCityBeijin.cityName, PayCityBeijin.cityCode, PayCityBeijin.aid, .beijin),
                (PayCityHefei.cityName, PayCityHefei.cityCode, PayCityHefei.aid, .hefei),
                (PayCityJingjinji.cityName, PayCityJingjinji.cityCode, PayCityJingjinji.aid, .jingjinji),
                (PayCityWuhan.cityName, PayCityWuhan.cityCode, PayCityWuhan.aid, .wuhan),
                (PayCitySuzhou.cityName, PayCitySuzhou.cityCode, PayCitySuzhou.aid, .suzhou),
                (PayCityShenzhen.cityName, PayCityShenzhen.cityCode, PayCityShenzhen.aid, .shenzheng),
                (PayCityLingnantong.cityName, PayCityLingnantong.cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .guangzhou)),
                (PayCityJilin.cityName, PayCityJilin.cityCode, PayCityJilin.aid, .jilin),
                (PayCityGuangxi.cityName, PayCityGuangxi.cityCode, PayCityGuangxi.aid, .guangxi),
                (PayCityChongqing.cityName, PayCityChongqing.cityCode, PayCityChongqing.aid, .chongqing),
                (PayCityZhengzhou.cityName, PayCityZhengzhou.cityCode, PayCityZhengzhou.aid, .zhengzhou)]
    }
    
    public static func allLingNantong() -> [(cityName: String, cityCode: String, aid: Data, city: PayCity)] {
        return [(CityLingnantong.getSubCityInformation(.taizhou).cityName, CityLingnantong.getSubCityInformation(.taizhou).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .taizhou)),
                (CityLingnantong.getSubCityInformation(.guangzhou).cityName, CityLingnantong.getSubCityInformation(.guangzhou).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .guangzhou)),
                (CityLingnantong.getSubCityInformation(.foushan).cityName, CityLingnantong.getSubCityInformation(.foushan).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .foushan)),
                (CityLingnantong.getSubCityInformation(.zhuhai).cityName, CityLingnantong.getSubCityInformation(.zhuhai).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .zhuhai)),
                (CityLingnantong.getSubCityInformation(.shanwei).cityName, CityLingnantong.getSubCityInformation(.shanwei).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .shanwei)),
                (CityLingnantong.getSubCityInformation(.jiangmen).cityName, CityLingnantong.getSubCityInformation(.jiangmen).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .jiangmen)),
                (CityLingnantong.getSubCityInformation(.zhaoqing).cityName, CityLingnantong.getSubCityInformation(.zhaoqing).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .zhaoqing)),
                (CityLingnantong.getSubCityInformation(.zhongshan).cityName, CityLingnantong.getSubCityInformation(.zhongshan).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .zhongshan)),
                (CityLingnantong.getSubCityInformation(.dongguan).cityName, CityLingnantong.getSubCityInformation(.dongguan).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .dongguan)),
                (CityLingnantong.getSubCityInformation(.huizhou).cityName, CityLingnantong.getSubCityInformation(.huizhou).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .huizhou)),
                (CityLingnantong.getSubCityInformation(.zhanjiang).cityName, CityLingnantong.getSubCityInformation(.zhanjiang).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .zhanjiang)),
                (CityLingnantong.getSubCityInformation(.shantou).cityName, CityLingnantong.getSubCityInformation(.shantou).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .shantou)),
                (CityLingnantong.getSubCityInformation(.shaoguan).cityName, CityLingnantong.getSubCityInformation(.shaoguan).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .shaoguan)),
                (CityLingnantong.getSubCityInformation(.heyuan).cityName, CityLingnantong.getSubCityInformation(.heyuan).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .heyuan)),
                (CityLingnantong.getSubCityInformation(.yangjiang).cityName, CityLingnantong.getSubCityInformation(.yangjiang).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .yangjiang)),
        (CityLingnantong.getSubCityInformation(.qingyuan).cityName, CityLingnantong.getSubCityInformation(.qingyuan).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .qingyuan)),
        (CityLingnantong.getSubCityInformation(.maoming).cityName, CityLingnantong.getSubCityInformation(.maoming).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .maoming)),
        (CityLingnantong.getSubCityInformation(.meizhou).cityName, CityLingnantong.getSubCityInformation(.meizhou).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .meizhou)),
        (CityLingnantong.getSubCityInformation(.chaozhou).cityName, CityLingnantong.getSubCityInformation(.chaozhou).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .chaozhou)),
        (CityLingnantong.getSubCityInformation(.jieyang).cityName, CityLingnantong.getSubCityInformation(.jieyang).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .jieyang)),
        (CityLingnantong.getSubCityInformation(.yunfu).cityName, CityLingnantong.getSubCityInformation(.yunfu).cityCode, PayCityLingnantong.aid, .lingnantong(subCity: .yunfu))]
    }
    
    public static func getCity(with cityCode: String) -> PayCity? {
        let cities = allCity().filter { (_, code, _, _) -> Bool in
            return code == cityCode
        }
        
        guard cities.count == 0 else {
            return cities.first!.city
        }
        
        let lnts = allLingNantong().filter { (_, code, _, _) -> Bool in
            return code == cityCode
        }
        
        guard lnts.count == 0 else {
            return lnts.first!.city
        }
        
        return nil
    }
}
