//
//  JMUserDefault.h
//  Creativity
//
//  Created by JM Zhao on 2017/7/6.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMUserDefault : NSObject
/**
 *  设置URL根据输入key值
 *
 *  @param url         需要存入的URL数据
 *  @param defaultName key值
 *
 *  @return 返回存储是否成功
 */
+ (BOOL)setUrl:(NSURL *)url forKey:(NSString *)defaultName;

/**
 *  根据key值读取对应value值
 *
 *  @param key key值
 *
 *  @return 返回读取的value值
 */
+ (NSURL *)readUrlByKey:(NSString *)key;

/**
 *  根据key值读取对应value值
 *
 *  @param integer key值
 *
 *  @return 返回读取的value值
 */
+ (BOOL)setInteger:(NSInteger)integer forKey:(NSString *)defaultName;

/**
 *  根据key值读取对应value值
 *
 *  @param key key值
 *
 *  @return 返回读取的value值
 */
+ (BOOL)readIntegerByKey:(NSString *)key;

/**
 *  根据key值读取对应value值
 *
 *  @param string key值
 *
 *  @return 返回读取的value值
 */
+ (BOOL)setString:(NSString *)string forKey:(NSString *)defaultName;

/**
 *  根据key值读取对应value值
 *
 *  @param key key值
 *
 *  @return 返回读取的value值
 */
+ (NSString *)readStringByKey:(NSString *)key;

/**
 *  根据key值读取对应value值
 *
 *  @param Bool key值
 *
 *  @return 返回读取的value值
 */
+ (BOOL)setBool:(BOOL)Bool forKey:(NSString *)defaultName;

/**
 *  根据key值读取对应value值
 *
 *  @param key key值
 *
 *  @return 返回读取的value值
 */
+ (BOOL)readBoolByKey:(NSString *)key;

/**
 *  根据key值删除value值
 *
 *  @param key key值
 */
+ (void)removeObjectByKey:(NSString *)key;
@end
