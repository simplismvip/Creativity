//
//  JMHelper.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/21.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMHomeModel;

@interface JMHelper : NSObject

// 1> 字符串转字典
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

// 2> 字典转字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;


// 1> 反序列化
+ (NSMutableDictionary *)readJsonByPath:(NSString *)path;

// 2> 序列化
+ (NSString *)writeJson:(id)dic dir:(NSString *)dir;

// 画图数据
+ (NSString *)writeJsonToDocmentFile:(NSMutableDictionary *)dic;

// 1> rgb转换为颜色
+ (UIColor *)getColor:(NSString *)rgbS;

// 2> 颜色转换为rgb
+ (NSString *)getRGB:(UIColor *)color;

+ (NSMutableDictionary *)pointArray:(NSMutableArray *)data type:(NSInteger)type fill:(BOOL)isFill isDash:(BOOL)dash imageName:(NSString *)imageName text:(NSString *)textString;

// 获取文件大小
+ (long long)getFilesByExtension:(NSString *)extension path:(NSString *)filePath;

+ (NSString *)timerString;
+ (NSString *)timestamp:(NSString *)timestring;
+ (NSString *)creatFolder:(NSString *)name dir:(NSString *)dir;

// 获取系统字体
+ (NSMutableArray *)systemFont;
+ (NSMutableArray *)systemFontType;

// 
+ (NSMutableArray *)getTopBarModel;
+ (NSMutableArray *)getSetModel;
@end
