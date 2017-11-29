//
//  GIFView.swift
//  ModiKit
//
//  Created by mac on 2017/11/28.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit
import ImageIO
import QuartzCore


/// 加载本地GIF图片
class GIFView: UIView {

    var width: CGFloat? {
        return frame.width
    }
    var height: CGFloat? {
        return frame.height
    }
    var viewWHRatio: CGFloat? {
        return width!/height!
    }
    
    var gifPath: String?
    
    private var gifUrl: URL?
    private var totalTime: Float = 0
    private var imagesArr: [CGImage] = []
    private var timeArr: [NSNumber] = []
    
    func showGIFImageWithLocalName(name: String) {
        //获取本地GIF对应URL路径
        if let resourceUrl = Bundle.main.url(forResource: name, withExtension: ".gif") {
            if FileManager.default.fileExists(atPath: resourceUrl.path) {
                print("file found")
                gifUrl = resourceUrl
            }
        }
        createFrame()
    }
    
    func showGIFWithURL(url: URL) {

        //将URL转MD5来作为文件名
        let fileName = getMD5WithString(url: url.absoluteString)
        //不可以在沙盒中随意创建文件下: 否则无法创建及写入文件
//        let path = NSHomeDirectory() + "/Library/Caches/GIF/" + fileName + ".gif"
        let path = NSHomeDirectory() + "/Library/Caches/" + fileName + ".gif"
        gifPath = path
        let manager = FileManager.default
        if manager.fileExists(atPath: path) {
            self.gifUrl = URL(fileURLWithPath: path)
            self.createFrame()
        }else {
            //创建文件夹及文件
//            if manager.createFile(atPath: path, contents: nil, attributes: nil) {
                //获取session单例
                let session = URLSession.shared
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let fileData = data as? NSData {
                        DispatchQueue.main.async {
                            if fileData.write(toFile: self.gifPath!, atomically: true) {
                                self.gifUrl = URL(fileURLWithPath: self.gifPath!)
                                self.createFrame()
                            }
                        }
                    }
                }
                //开始任务
                task.resume()
//            }
        }
 
    }
    
    func getMD5WithString(url: String) -> String{
        //获取到UTF8编码的String
        let str = url.cString(using: String.Encoding.utf8)
        //获取到UFT8编码下字节长度
        let strLen = CC_LONG(url.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        //销毁result
        result.deinitialize()
        return String(format: hash as! String)
    }

    func createFrame() {
        //
        let cfUrl = gifUrl! as CFURL
        //获取git中所有关键帧资源
        let gifSource = CGImageSourceCreateWithURL(cfUrl, nil)
        //获取关键帧数量
        let gifCount = CGImageSourceGetCount(gifSource!)
        //
        for index in 0..<gifCount {
            let cgImage = CGImageSourceCreateImageAtIndex(gifSource!, index, nil)
            imagesArr.append(cgImage!)
            
            let sourceDict = CGImageSourceCopyPropertiesAtIndex(gifSource!, index, nil) as! NSDictionary
            
            //h获取每帧图片的宽高
            let gifWidth = sourceDict[kCGImagePropertyPixelWidth] as! CGFloat
            let gifHeight = sourceDict[kCGImagePropertyPixelHeight] as! CGFloat
            //当图片宽高比与UIView的宽高比不一致时调整图片大小
            let gifWHRatio = gifWidth/gifHeight
            
            if viewWHRatio != gifWHRatio {
                fitScaleGif(gifWidth: gifWidth, gifHeight: gifHeight)
            }
            
            let gifDict = sourceDict[String(kCGImagePropertyGIFDictionary)] as! NSDictionary
            let time = gifDict[String(kCGImagePropertyGIFUnclampedDelayTime)] as! NSNumber
            timeArr.append(time)
            totalTime += time.floatValue
        }
        showAnimation()
    }
    
    
    func fitScaleGif(gifWidth: CGFloat, gifHeight: CGFloat) {
        let ratio: CGFloat = gifWidth/gifHeight
        
        var newWidth: CGFloat = 0
        var newHeight: CGFloat = 0
        
        if ratio > viewWHRatio! {
            //调整宽度
            newWidth = width!
            newHeight = gifWidth / viewWHRatio!
        }else {
            //调整高度
            newHeight = height!
            newWidth = gifHeight * viewWHRatio!
        }
        let point = self.center
        self.frame.size = CGSize(width: newWidth, height: newHeight)
        //中心点保持不变
        self.center = point
    }
    
    func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var current: Float = 0
        //获取动画时间点
        var keyTimes = [NSNumber]()
        for time in timeArr {
            keyTimes.append(NSNumber(value: current/totalTime))
            current += time.floatValue
        }
        animation.keyTimes = keyTimes
        animation.values = imagesArr
        animation.duration = CFTimeInterval(totalTime)
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "contents")
    }
}





