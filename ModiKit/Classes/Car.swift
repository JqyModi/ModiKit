//
//  Car.swift
//  ModiKit
//
//  Created by mac on 2017/12/21.
//  Copyright © 2017年 modi. All rights reserved.
//

import Foundation
class Car: NSObject {
    @objc var name: String?
    @objc private var type: String?
    @objc private var color: String?
    
    var fe: FireExtinguisher?
    
    var bus: Bus?
    
    func setColor(color: String) {
        self.color = color
    }
    
    func setType(type: String) {
        self.type = type
    }
    
    func getType() -> String{
        return self.type!
    }
    
    class func propertyList() {
        var count: UInt32 = 0
        let prolist = class_copyPropertyList(self, &count)
        for i in 0..<Int(count) {
            let pro = prolist?[i]
            // 获取 `属性` 的名称C语言字符串
            let proString = property_getName(pro!)
            // 转化成 String的字符串
            let proName = String(utf8String: proString)
            print(proName!)
            //
            let proTypeString = ivar_getTypeEncoding(pro!)
            let proType = String(utf8String: proTypeString!)
            print(proType!)
        }
        // 释放 C 语言的对象
        free(prolist)
    }
}
