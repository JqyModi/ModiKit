//
//  Extension.swift
//  ModiKit
//
//  Created by mac on 2017/11/28.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

extension UIView {
    /// X方向上的移动动画
    ///
    /// - Parameters:
    ///   - toPoint: 目标点坐标
    ///   - duration: 移动时长
    func moveToXwithDuration(toX: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.frame.origin.x = toX
        }
    }
    /// Y方向上的移动动画
    ///
    /// - Parameters:
    ///   - toPoint: 目标点坐标
    ///   - duration: 移动时长
    func moveToYwithDuration(toY: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.frame.origin.y = toY
        }
    }
    /// 移动到某一点动画：CGPoint
    ///
    /// - Parameters:
    ///   - toPoint: 目标点坐标
    ///   - duration: 移动时长
    func moveToPointwithDuration(toPoint: CGPoint, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.center = toPoint
        }
    }
}
extension Int {
    //转化为CGFloat
    var FloatValue: CGFloat {
        return CGFloat(self)
    }
    //转Double
    var DoubleValue: Double {
        return Double(self)
    }
}
extension UIImage {
    //扩展宽高
    var height: CGFloat {
        return self.size.height
    }
    var width: CGFloat {
        return self.size.width
    }
    
    /// 图片压缩
    ///
    /// - Parameter targetWidth: 压缩后图片宽度
    /// - Returns: 返回压缩后图片
    func imageCompress(targetWidth: CGFloat) -> UIImage? {
        //获取原图片宽高比
        let ratio = height/width
        //计算出压缩后的高
        let targetHeight = targetWidth * ratio
        //开始压缩
        UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
        //设置压缩时Rect
        self.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        //获取压缩后图片
        let targetImage = UIGraphicsGetImageFromCurrentImageContext()
        //结束压缩
        UIGraphicsEndImageContext()
        return targetImage
    }
    
    /// 图片毛玻璃效果
    ///
    /// - Parameter value: 模糊程度
    /// - Returns: 返回模糊处理图片
    func blurImage(value: NSNumber) -> UIImage {
        //三种处理方式：CPU、GPU、OpenGL -> CPU
        //获取处理上下文
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        //获取上下文处理对象CIImage：需要用CoreImage来调用因为UIImage本身也有一个属性是CIImage会冲突
        let ciImage = CoreImage.CIImage(image: self)
        //获取滤镜
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        //设置滤镜属性
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(value, forKey: kCIInputRadiusKey)
        //获取滤镜处理后图片
        let cgImage = context.createCGImage((blurFilter?.outputImage)!, from: (ciImage?.extent)!)
        let blurImage = UIImage(cgImage: cgImage!)
        return blurImage
    }
}

extension UIButton {
    public class func initializeOnceMethod() {
        //原来设置给Button的点击事件
        let orgMethod = #selector(UIButton.sendAction(_:to:for: ))
        //用来替换的事件
        let newMethod = #selector(UIButton.replaceAction(_:to:for:))
        //runtime获取类本身的方法及属性：类似Java反射机制
        let org = class_getInstanceMethod(self, orgMethod)
        let new = class_getInstanceMethod(self, newMethod)
        //添加方法到类本身
        let didAddMethod = class_addMethod(self, orgMethod, method_getImplementation(new!), method_getTypeEncoding(new!))
        //替换方法
        if didAddMethod {
            class_replaceMethod(self, newMethod, method_getImplementation(org!), method_getTypeEncoding(org!))
        }else{
            method_exchangeImplementations(org!, new!)
        }
    }
    
    private func exchangeMethod() {
        //原来设置给Button的点击事件
        let orgMethod = #selector(UIButton.sendAction(_:to:for: ))
        //用来替换的事件
        let newMethod = #selector(UIButton.replaceAction(_:to:for:))
        //runtime获取类本身的方法及属性：类似Java反射机制
        let org = class_getInstanceMethod(self.classForCoder, orgMethod)
        let new = class_getInstanceMethod(self.classForCoder, newMethod)
        //添加方法到类本身
        let didAddMethod = class_addMethod(self.classForCoder, orgMethod, method_getImplementation(new!), method_getTypeEncoding(new!))
        //替换方法
        if didAddMethod {
            class_replaceMethod(self.classForCoder, newMethod, method_getImplementation(org!), method_getTypeEncoding(org!))
        }else{
            method_exchangeImplementations(org!, new!)
        }
    }
    
    @objc private func replaceAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        debugPrint("replaceAction")
    }
}

//extension UIViewController {
//    open override static func initialize() {
//        struct Static {
//            static var token = NSUUID().uuidString
//        }
//
//        if self != UIViewController.self {
//            return
//        }
//
//        DispatchQueue.once(token: Static.token) {
//            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
//            let swizzledSelector = #selector(UIViewController.xl_viewWillAppear(animated:))
//
//            let originalMethod = class_getInstanceMethod(self, originalSelector)
//            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//
//
//            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
//            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
//
//            if didAddMethod {
//                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod)
//            }
//        }
//    }
//
//    func xl_viewWillAppear(animated: Bool) {
//        self.xl_viewWillAppear(animated: animated)
//        print("xl_viewWillAppear in swizzleMethod")
//    }
//}

extension DispatchQueue {
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}
















