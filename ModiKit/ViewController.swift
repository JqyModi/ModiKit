//
//  ViewController.swift
//  ModiKit
//
//  Created by mac on 2017/11/27.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var car: Car?
    
    @IBOutlet weak var testImageView: UIImageView! {
        didSet {
//            testImageView?.sizeToFit()
            //设置模糊效果
//            let image = UIImage(named: "fy")
//            testImageView?.image = image?.blurImage(value: 1.0)
//            testImageView?.image = image?.imageCompress(targetWidth: 300)
        }
    }
    
    @IBOutlet weak var gifView: GIFView!{
        didSet {
//            gifView?.showGIFImageWithLocalName(name: "cat_gif")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "fy")
        testImageView?.image = image?.blurImage(value: 0.0)
        
        testImageView.moveToPointwithDuration(toPoint: CGPoint.init(x: 150, y: 150), duration: 3)
        
//        gifView?.showGIFImageWithLocalName(name: "gif2")
        let url = URL(string: "http://img3.duitang.com/uploads/item/201411/12/20141112224314_GEuBE.gif")
        gifView.showGIFWithURL(url: url!)
        
        let single = Singleton.sharedSingleton
        single.testValue = 10
        let single1 = Singleton.sharedSingleton
        debugPrint("single1.testValue = \(single1.testValue)")
        
        //测试KVC
        car = Car()
        car?.name = "法拉利"
        car?.setColor(color: "red")
        car?.setType(type: "make in china")
        
        //
    }
    
    @IBAction func readCache(_ sender: UIButton) {
        let cacheSize = Cache.calcCacheSize()
        print("cacheSize = \(cacheSize)")
        
        //KVO操作
        //1.将当前类作为观察者
        car?.addObserver(self, forKeyPath: "type", options: [.new,.old], context: nil)
        
        //操作KVC
        car?.setValue("China", forKey: "type")
        debugPrint("car type = \(car?.getType())")
        debugPrint("car type KVC -> \(car?.value(forKeyPath: "type"))")
        
        //Swift4新特性：支持结构体KVC
        let s = Student(name: "saobi", sex: "nan")
        
        
        var responseMessages = [200: "OK",
                                403: "Access forbidden",
                                404: "File not found",
                                500: "Internal server error"]
        //
        let dict: NSDictionary = ["name" : "汽车",
                    "type" : "机动车",
                    "color" : "orange",
                    "fe" : [
                        "create" : "2017.12.22",
                        "isChecked" : "true"
            ],
                    "bus" : [
                        "seat" : "20",
                        "serviceCount" : "2"
            ]
        ]
        
        let car1 = Car()
//        car1.setValuesForKeys(dict)
//        car1.setValuesWithDict(dict: dict)
        car1.setkeyValues(dict as! [AnyHashable : Any])
        debugPrint("car.bus.count ------> \(car1.bus?.seat)")
//        Car.propertyList()
        
        
    }
    
    // KVO - 实现type改变监听方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        debugPrint("监听到改变：change ---> \(change)")
    }
    
    @IBAction func clearCache(_ sender: UIButton) {
        let cachePath = NSHomeDirectory() + "/tmp/"
//        Cache.clearCache(path: cachePath) {
//            print("清理完成")
//        }
        debugPrint("exchange")
    }
    @IBAction func touchDown(_ sender: UIButton) {
        debugPrint("touchDown")
    }
}

struct Student {
    var name: String
    var sex: String
}

