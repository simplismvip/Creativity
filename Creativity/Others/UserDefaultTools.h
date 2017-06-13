//
//  UserDefaultTools.h
//  PageShare
//
//  Created by JM Zhao on 16/8/29.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultTools : NSObject

// 根据key值删除value值
+ (void)removeObjectByKey:(NSString *)key;

// 存储和读取 NSNumber 值
+ (BOOL)setUrl:(NSURL *)url forKey:(NSString *)defaultName;
+ (NSURL *)readUrlByKey:(NSString *)key;

// 存储和读取 NSNumber 值
+ (BOOL)setValue:(NSNumber *)value forKey:(NSString *)defaultKey;
+ (NSInteger)getValueByKey:(NSString *)key;

// 存储和读取 NSString 值
+ (BOOL)setString:(NSString *)string forKey:(NSString *)defaultName;
+ (NSString *)readStringByKey:(NSString *)key;

// 存储和读取 BOOL 值
+ (BOOL)setBool:(BOOL)Bool forKey:(NSString *)defaultName;
+ (BOOL)readBoolByKey:(NSString *)key;

// 存储和读取 NSInteger 值
+ (BOOL)setInteger:(NSInteger)integer forKey:(NSString *)defaultName;
+ (NSInteger)readIntegerByKey:(NSString *)key;

// 存储和读取 float 值
+ (BOOL)setFloat:(float)Float forKey:(NSString *)defaultName;
+ (float)readFloatByKey:(NSString *)key;


@end
