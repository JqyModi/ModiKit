//
//  Singleton.swift
//  ModiKit
//
//  Created by mac on 2017/11/29.
//  Copyright © 2017年 modi. All rights reserved.
//

import Foundation

class Singleton {
    
    var testValue = 0
    
    /*
    //单例方式一: GCD_once：Swift3.0已经废弃
    func shareDefault() -> Singleton {
        struct Once {
            static var onceToken: dispatch_time_t = 0
            static var singleton: Singleton? = nil
        }
        //利用GCD特性创建一次实例
        dispatch_once(&Once.onceToken) {
            Once.singleton = Singleton()
        }
        return Once.singleton
    }*/
    
    /*
    //单例方式二: 结构体
    func shareDefault() -> Singleton {
        struct Once {
            static var singleton = Singleton()
        }
        return Once.singleton
    }*/
    
    //单例方式三: 全局常量
//    static let shareDefault = Singleton()
    
    //swift3.0推荐使用
    private static let sharedInstance = Singleton()
    class var sharedSingleton: Singleton {
        return sharedInstance
    }
    
    //私有化构造方法
//    private override func init() {
//
//    }
    private init() {
        
    }
}
