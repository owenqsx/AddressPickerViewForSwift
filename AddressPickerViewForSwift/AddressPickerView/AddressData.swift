//
//  HGCommon.swift
//  higold-mvvm
//
//  Created by 戚思晓 on 2018/5/21.
//  Copyright © 2018年 佛山市逸云计算机科技有限公司. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON


class Province {
    var name: String!
    var id: Int!
    var cityModelArr: [City] = []
}

class City {
    var name: String!
    var id: Int!
    var regionModelArr: [Region] = []
}

class Region {
    var name: String!
    var id: Int!
}

class AddressData {
    
    var provinceList: [Province] = []
    var cityList: [City] = []
    var regionList: [Region] = []
    var region: Int?
    var city: Int?
    var province: Int?
    var regionName: String?
    var cityName: String?
    var provinceName: String?
    var addressName: String?
    
    
    init() {
        provinceList = makeAddressData()
    }
    
    init(regionId: Int) {
        self.region = regionId
        self.countAllParams(regionId: regionId)
    }
    
    func countAllParams(regionId: Int) {
        var provinceModelArr: [Province] = []
        let filePath = Bundle.main.path(forResource: "data", ofType: "json")
        if filePath == nil {
            print("加载数据源失败，请检查文件路径")
            return
        }
        var addressStr: String? = nil
        do {
            addressStr = try String.init(contentsOfFile: filePath!, encoding: .utf8)
        } catch {
            print("encoding error = ",error)
            return
        }
        let json = JSON.init(parseJSON: addressStr ?? "")
        let proviceData = json["86"].filter { (province) -> Bool in
            Int(province.0.subString(start: 0, length: 1)) ?? 8 < 7
        }
        let cityData = json.filter { (subjson) -> Bool in
            subjson.0.count == 6 && subjson.0.subString(start: 2) == "0000" && subjson.0.subString(start: 0, length: 1) != "8"
        }
        let regionData = json.filter { (subjson) -> Bool in
            subjson.0.count == 6 && subjson.0.subString(start: 2) != "0000" && subjson.0.subString(start: 0, length: 1) != "8"
        }
        for oneProvince in proviceData {
            let p = Province()
            p.name = oneProvince.1.stringValue
            p.id = Int(oneProvince.0)
            let theProvince = cityData.filter { (province) -> Bool in
                return province.0 == oneProvince.0
                }.first
            var cityModels: [City] = []
            let result = theProvince?.1.map { (oneCity) -> Bool in
                let c = City()
                c.name = oneCity.1.stringValue
                c.id = Int(oneCity.0)
                let theCity = regionData.filter { (city) -> Bool in
                    return city.0 == oneCity.0
                    }.first
                var regionModels: [Region] = []
                let result = theCity?.1.map({ (oneRegion) -> Bool in
                    let r = Region()
                    r.name = oneRegion.1.stringValue
                    r.id = Int(oneRegion.0)
                    regionModels.append(r)
                    regionList.append(r)
                    return true
                })
                c.regionModelArr = regionModels
                cityModels.append(c)
                cityList.append(c)
                return true
            }
            p.cityModelArr = cityModels
            provinceModelArr.append(p)
        }
        self.provinceList = provinceModelArr
        self.region = regionId
        // 根据规则自动替换后面两位为0，减少运算
//        self.city = cityList.filter({ (oneCity) -> Bool in
//            oneCity.regionModelArr.filter({ (oneRegion) -> Bool in
//                oneRegion.id == self.region
//            }).count >= 1
//        }).first?.id
//        self.province = provinceList.filter({ (oneProvince) -> Bool in
//            oneProvince.cityModelArr.filter({ (oneCity) -> Bool in
//                oneCity.id == self.city
//            }).count >= 1
//        }).first?.id
        self.city = regionId / 100 * 100
        self.province = regionId / 10000 * 10000
        self.regionName = regionList.filter({ (oneRegion) -> Bool in
            oneRegion.id == self.region
        }).first?.name ?? ""
        self.cityName = cityList.filter({ (oneCity) -> Bool in
            oneCity.id == self.city
        }).first?.name ?? ""
        self.provinceName = provinceList.filter({ (oneProvince) -> Bool in
            oneProvince.id == self.province
        }).first?.name ?? ""
        self.addressName = provinceName! + cityName! + regionName!
//        print("region")
//        print(self.region)
//        print("regionName")
//        print(self.regionName)
//        print("city")
//        print(self.city)
//        print("cityName")
//        print(self.cityName)
//        print("province")
//        print(self.province)
//        print("provinceName")
//        print(self.provinceName)
//        print(self.addressName)
    }
    
    func makeAddressData() -> [Province] {
        var provinceModelArr: [Province] = []
        let filePath = Bundle.main.path(forResource: "data", ofType: "json")
        if filePath == nil {
            print("加载数据源失败，请检查文件路径")
            return []
        }
        var addressStr: String? = nil
        do {
            addressStr = try String.init(contentsOfFile: filePath!, encoding: .utf8)
        } catch {
            print("encoding error = ",error)
            return []
        }
        let json = JSON.init(parseJSON: addressStr ?? "")
        let proviceData = json["86"].filter { (province) -> Bool in
            Int(province.0.subString(start: 0, length: 1)) ?? 8 < 7
        }
        let cityData = json.filter { (subjson) -> Bool in
            subjson.0.count == 6 && subjson.0.subString(start: 2) == "0000" && subjson.0.subString(start: 0, length: 1) != "8"
        }
        let regionData = json.filter { (subjson) -> Bool in
            subjson.0.count == 6 && subjson.0.subString(start: 2) != "0000" && subjson.0.subString(start: 0, length: 1) != "8"
        }
        for oneProvince in proviceData {
            let p = Province()
            p.name = oneProvince.1.stringValue
            p.id = Int(oneProvince.0)
            let theProvince = cityData.filter { (province) -> Bool in
                return province.0 == oneProvince.0
                }.first
            var cityModels: [City] = []
            let result = theProvince?.1.map { (oneCity) -> Bool in
                let c = City()
                c.name = oneCity.1.stringValue
                c.id = Int(oneCity.0)
                let theCity = regionData.filter { (city) -> Bool in
                    return city.0 == oneCity.0
                    }.first
                var regionModels: [Region] = []
                let result = theCity?.1.map({ (oneRegion) -> Bool in
                    let r = Region()
                    r.name = oneRegion.1.stringValue
                    r.id = Int(oneRegion.0)
                    regionModels.append(r)
                    return true
                })
                c.regionModelArr = regionModels
                cityModels.append(c)
                return true
            }
            p.cityModelArr = cityModels
            provinceModelArr.append(p)
        }
        return provinceModelArr
    }
    
    func getCity(region: Int) -> Int {
        let filePath = Bundle.main.path(forResource: "data", ofType: "json")
        if filePath == nil {
            print("加载数据源失败，请检查文件路径")
            return 0
        }
        var addressStr: String? = nil
        do {
            addressStr = try String.init(contentsOfFile: filePath!, encoding: .utf8)
        } catch {
            print("encoding error = ",error)
            return 0
        }
        let json = JSON.init(parseJSON: addressStr ?? "")
        let regionData = json.filter { (subjson) -> Bool in
            subjson.0.count == 6 && subjson.0.subString(start: 2) != "0000" && subjson.0.subString(start: 0, length: 1) != "8"
        }
        let cityId = regionData.filter { (oneRegion) -> Bool in
            oneRegion.0 == "\(region)"
            }.first?.0
        return Int(cityId ?? "0") ?? 0
    }
    
    func getProvince(city: Int) -> Int {
        let filePath = Bundle.main.path(forResource: "data", ofType: "json")
        if filePath == nil {
            print("加载数据源失败，请检查文件路径")
            return 0
        }
        var addressStr: String? = nil
        do {
            addressStr = try String.init(contentsOfFile: filePath!, encoding: .utf8)
        } catch {
            print("encoding error = ",error)
            return 0
        }
        let json = JSON.init(parseJSON: addressStr ?? "")
        let cityData = json.filter { (subjson) -> Bool in
            subjson.0.count == 6 && subjson.0.subString(start: 2) == "0000" && subjson.0.subString(start: 0, length: 1) != "8"
        }
        let provinceId = cityData.filter { (oneCity) -> Bool in
            oneCity.0 == "\(region)"
            }.first?.0
        return Int(provinceId ?? "0") ?? 0
    }

}

extension String {
    
    /**
     去除左右的空格和换行符
     */
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /**
     将字符串通过特定的字符串拆分为字符串数组
     - parameter str   : 拆分数组使用的字符串
     - returns : 字符串数组
     */
    func split(string:String) -> [String] {
        return NSString(string: self).components(separatedBy: string)
    }
    
    /**
     拆分字符串，并获取指定索引的字符串
     - parameter splitStr   : 拆分数组使用的字符串
     - parameter index      : 索引位置
     - parameter defaultStr : 默认字符串
     - returns : 拆分所得字符串
     */
    func strSplitByIndex(splitStr str:String, index:Int, defaultStr:String = "") -> String {
        let a = self.split(string:str)
        if index > a.count - 1  {
            return defaultStr
        }
        return a[index]
    }
    
    /**
     字符串替换
     - parameter of     : 被替换的字符串
     - parameter with   : 替换使用的字符串
     - returns : 替换后的字符串
     */
    func replace(of: String, with: String) -> String {
        return self.replacingOccurrences(of: of, with: with)
    }
    
    /**
     判断是否包含，虽然系统提供了方法，这里也只是简单的封装。如果swift再次升级的话，就知道现在做的好处了
     - parameter string : 是否包含的字符串
     - returns : 是否包含
     */
    func has(string:String) -> Bool {
        return self.contains(string)
    }
    
    /**
     字符出现的位置
     - parameter string : 字符串
     - returns : 字符串出现的位置
     */
    func indexOf(string str:String) -> Int {
        var i = -1
        if let r = range(of: str) {
            if !r.isEmpty {
                i = self.distance(from: self.startIndex, to: r.lowerBound)
            }
        }
        return i
    }
    
    /**
     这个太经典了,获取指定位置和大小的字符串
     - parameter start  : 起始位置
     - parameter length : 长度
     - returns : 字符串
     */
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(self.startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        let range = st ..< en
        return String(self[range])
        //        return self.substring(with:range)
    }
    
    
}


