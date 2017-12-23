//
//  NSObject+Extension.m
//  字典转模型
//
//  Created by apple on 15-2-9.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)


/*
 实现原理:
 1.取出当前对象所有属性名称
 2.根据名称从字典中取值
 3.利用KVC给当前对象赋值
 

 注意点:
 1.属性是对象 -->需要特殊处理
  >取出当前属性的类型, 如果是自定义对象类型就根据类型创建对象,再取出当前对象对应的字典重复1~3步
 2.子父类 -->需要获取父类属性
  >定义一个变量记录当前的类型, 当取完当前对象的类型后将变量赋值给当前对象的父类再次重复取值设值, 直到没有父类位置(NSObject没有父类)
 */
- (void)setkeyValues:(NSDictionary *)dict
{
    // 0.获取当前的类
    Class c = [self class];
    // 只要有父类
    while (c != nil) {
        // 1.取出模型中所有的属性
        unsigned int count = 0;
        // ivars相当于数组
//    Ivar *ivars = class_copyIvarList([self class], &count);
        Ivar *ivars = class_copyIvarList(c, &count);
        // 2.遍历所有属性
        for (int  i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
            // 处理获取到得属性名称 _name
            name = [name substringFromIndex:1];
            
            // 根据取出的属性名称到字典中取出对应的值
            id value = dict[name]; // name
            
            // 取出来的属性是否是对象类型, 如果是, 那么需要创建该对象并且赋值
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            
            // 处理获取到得类型 @"Gun"
            if ([type hasPrefix:@"@"] && ![type hasPrefix:@"@\"NS"]) {
                // 自定义类型 @"Gun"
                NSRange range = NSMakeRange(2, type.length - 3);
                type = [type substringWithRange:range];
                
                // 根据获取到得类型创建对应的对象
                Class objClass = NSClassFromString(type);
#warning 注意: 当前创建的这个对象, 就是属性将来的值
                value = [[objClass alloc] init];
                
                // 取出当前当前属性对应的值(字典)
                id subDict =  dict[name];
                
                // 取出对应属性所有的值赋值给自定义对象
                [value setkeyValues:subDict];
                
            }
            
            // 注意: 有可能会获取到一些系统自带的属性, 那么这些属性从字典中取值是取不到值的
            // 那么如果娶不到值就直接赋值可能会报错, 所以判断如果没有值就不赋值
            if (value == nil) {
                continue;
            }
            // 3.设置属性的值
            //        NSLog(@"%@ %@", name, value);
            [self setValue:value forKey:name];
        }
        
        c = [c superclass];
    }

}
@end
