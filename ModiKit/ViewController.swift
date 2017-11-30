//
//  ViewController.swift
//  ModiKit
//
//  Created by mac on 2017/11/27.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        
        
    }
    
    @IBAction func readCache(_ sender: UIButton) {
        let cacheSize = Cache.calcCacheSize()
        print("cacheSize = \(cacheSize)")
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

