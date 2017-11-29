//
//  Cache.swift
//  ModiKit
//
//  Created by mac on 2017/11/28.
//  Copyright © 2017年 modi. All rights reserved.
//

import Foundation

class Cache {
    
    // MARK: -  CalcCache
    
    /// 计算指定目录文件夹大小
    ///
    /// - Returns: 默认计算当前沙盒根路径下文件大小
    static func calcCacheSize(path: String = NSHomeDirectory()) -> String {
        //读取沙盒根目录大小
        let size = calcFolderSize(folderPath: path)
        return String.init(format: "%.2f", size)
    }
    
    /// 计算指定文件大小
    ///
    /// - Parameter filePath: 文件绝对路径
    /// - Returns: 返回文件大小
    private static func calcFileSize(filePath: String) -> Double {
        let manager = FileManager.default
        var fileSize: Double = 0
        do {
            let fileAttributes = try manager.attributesOfItem(atPath: filePath)
            fileSize = fileAttributes[FileAttributeKey.size] as! Double
        }catch {
            print(error)
        }
        return fileSize
    }
    
    /// 计算指定路径文件夹大小
    ///
    /// - Parameter folderPath: 文件夹路径
    /// - Returns: 返回文件夹大小：单位MB
    private static func calcFolderSize(folderPath: String) -> Double {
        let manager = FileManager.default
        var folderSize: Double = 0
        
        debugPrint("homePath = \(folderPath)")
        
        if manager.fileExists(atPath: folderPath) {
            do {
                let childPaths = manager.subpaths(atPath: folderPath)
                for path in childPaths! {
                    let childFilePath = folderPath + "/" + path
                    let childSize = calcFileSize(filePath: childFilePath)
                    folderSize += childSize
                }
            }catch {
                print(error)
            }
        }
        return folderSize/1024/1024
    }
    
    //MARK: -    ClearCache
    
    static func clearCache(path: String = NSHomeDirectory(), complete: ()->Void ) {
        clearFolder(folderPath: path)
        //清理完成回调
        complete()
    }
    
    private static func clearFolder(folderPath: String) {
        let manager = FileManager.default
        
        if manager.fileExists(atPath: folderPath) {
            do {
                let childPaths = manager.subpaths(atPath: folderPath)
                for path in childPaths! {
                    let childFilePath = folderPath + "/" + path
                    clearFile(filePath: childFilePath)
                }
            }catch {
                print(error)
            }
        }
    }
    
    private static func clearFile(filePath: String) {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            do {
                try manager.removeItem(atPath: filePath)
            }catch {
                debugPrint(error)
            }
        }
    }
    
}







