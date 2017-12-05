//
//  Extension.swift
//  ModiKit
//
//  Created by mac on 2017/11/28.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

//MARK: - UIView
extension UIView {
    
    var left: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var right: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.width
            self.frame = frame
        }
        get {
            return self.left + self.width
        }
    }
    
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    
    var top: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.height
            self.frame = frame
        }
        get {
            return self.top + self.height
        }
    }
    
    var centerY: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height * 0.5
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height * 0.5
        }
    }
    
    var centerX: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width * 0.5
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width * 0.5
        }
    }

    var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
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

//MARK: - Int
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

//MARK: - UIImage
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
    
    
    /// 生成圆形图片
    ///
    /// - Returns: 返回圆形图片
    func circleImage() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
    
    /**
     Creates a new solid color image.
     - Parameter color: The color to fill the image with.
     - Parameter size: Image size (defaults: 10x10)
     - Returns A new image
     */
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    ///对指定图片进行拉伸
    func resizableImage(name: String) -> UIImage {
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = resizableImage(withCapInsets: UIEdgeInsetsMake(imageHeight, imageWidth, imageHeight, imageWidth))
        return normal
    }
    
    /**
     *  压缩上传图片到指定字节
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小
     *  return 压缩后图片的二进制
     */
    func compressImage(image: UIImage, maxLength: Int) -> NSData? {
        let newSize = self.scaleImage(image: image, imageLength: 300)
        let newImage = self.resizeImage(image: image, newSize: newSize)
        var compress:CGFloat = 0.9
        var data = UIImageJPEGRepresentation(newImage, compress)
        while (data?.count)! > maxLength && compress > 0.01 {
            compress -= 0.02
            data = UIImageJPEGRepresentation(newImage, compress)
        }
        return data as! NSData
    }
    
    /**
     *  通过指定图片最长边，获得等比例的图片size
     *  image       原始图片
     *  imageLength 图片允许的最长宽度（高度）
     *  return 获得等比例的size
     */
    func  scaleImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        if (width > imageLength || height > imageLength){
            if (width > height) {
                newWidth = imageLength;
                newHeight = newWidth * height / width;
            }else if(height > width){
                newHeight = imageLength;
                newWidth = newHeight * width / height;
            }else{
                newWidth = imageLength;
                newHeight = imageLength;
            }
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    /**
     *  获得指定size的图片
     *  image   原始图片
     *  newSize 指定的size
     *  return 调整后的图片
     */
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

//MARK: - UIButton
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
    
    @objc private func replaceAction(_ action: Selector, to target: UIButton?, for event: UIEvent?) {
//        debugPrint("replaceAction")
        
        struct once {
            static var loopSwitch = true
            static var loopSwitchArr: Dictionary<String,String> = [:]
        }
//        if once.loopSwitch {
//            target?.perform(action, with: self)
//            once.loopSwitch = false
//            //延时操作
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
//                once.loopSwitch = true
//                debugPrint("延时2秒")
//            })
//        }else {
//            debugPrint("禁止点击")
//        }
        
        //以上方式点击事件适用但当按钮同时添加多个事件如：touchDown事件时也会调用UIButton的SendAction方法：处理
        //action.desctiption : 返回该事件方法名
        if tag == 1000 {    //方便控制开关：有得按钮不需要此操作
            if once.loopSwitchArr[action.description] != "false" {
                target?.perform(action, with: self)
                once.loopSwitchArr[action.description] = "false"
                //延时操作
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    once.loopSwitchArr[action.description] = "true"
                    debugPrint("延时2秒")
                })
            }else {
                debugPrint(action.description + "禁止点击")
            }
        }else {
            target?.perform(action, with: self)
        }
    }
}

// MARK: - SwizzledMethod
/*
extension UIViewController {
    open override static func initialize() {
        struct Static {
            static var token = NSUUID().uuidString
        }
        if self != UIViewController.self {
            return
        }
        DispatchQueue.once(token: Static.token) {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.xl_viewWillAppear(animated:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing

            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    func xl_viewWillAppear(animated: Bool) {
        self.xl_viewWillAppear(animated: animated)
        print("xl_viewWillAppear in swizzleMethod")
    }
}
 */

//MARK: - DispatchQueue
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

//MARK: - String
extension String{
    func transformToPinYin()->String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }
}

//MARK: - UIColor
extension UIColor {
    convenience init(rgba: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        if rgba.hasPrefix("#") {
            let index   = rgba.characters.index(rgba.startIndex, offsetBy: 1)
            let hex     = rgba.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    debugPrint("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                }
            } else {
                debugPrint("Scan hex error")
            }
        } else {
            debugPrint("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
//    convenience init(hex: UInt) {
//        self.init(
//            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(hex & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
}















