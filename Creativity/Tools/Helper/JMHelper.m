//
//  JMHelper.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/21.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMHelper.h"
#import "MJExtension.h"
#import "JMAttributeString.h"
#import "StaticClass.h"
#import "JMTopBarModel.h"
#import "JMBottomModel.h"

@implementation JMHelper

// 字符串转字典
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

// 字典转字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// 画线数据包装成json字典
+ (NSMutableDictionary *)pointArray:(NSMutableArray *)data type:(NSInteger)type fill:(BOOL)isFill isDash:(BOOL)dash imageName:(NSString *)imageName text:(NSString *)textString
{
    if (imageName == nil) {imageName = @"0";}
    if (textString == nil) {textString = @"0";}
    
    NSString *tp = [NSString stringWithFormat:@"%ld", type];
    NSString *fl = [NSString stringWithFormat:@"%d", isFill];
    NSString *da = [NSString stringWithFormat:@"%d", dash];
    NSString *lc = [self getRGB:[StaticClass getColor]];
    NSString *ap = [NSString stringWithFormat:@"%.2f", [StaticClass getAlpha]];
    NSString *lw = [NSString stringWithFormat:@"%.2f", [StaticClass getLineWidth]];
    
    NSString *fontType = [NSString stringWithFormat:@"%ld", [StaticClass getFontType]];
//    NSString *fontSize = [NSString stringWithFormat:@"%.2f", [StaticClass getFontSize]];
    NSString *fontname = [StaticClass getFontName];
    
    return [NSMutableDictionary dictionaryWithDictionary:@{@"tp":tp, @"ap":ap, @"lw":lw, @"lc":lc, @"fl":fl, @"dash":da, @"image":imageName, @"text":textString, @"fontType":fontType, @"fontName":fontname, @"dt":[data mutableCopy]}];
}

// 1> rgb转换为颜色
+ (UIColor *)getColor:(NSString *)rgbS
{
    NSArray *array = [rgbS componentsSeparatedByString:@","];
    CGFloat r = [array[0] floatValue];
    CGFloat g = [array[1] floatValue];
    CGFloat b = [array[2] floatValue];
    CGFloat f = [array[3] floatValue];
//    JMLog(@"%f, %f, %f", r, g, b);
    return [UIColor colorWithRed:r green:g blue:b alpha:f];;
}

// 2> 颜色转换为rgb
+ (NSString *)getRGB:(UIColor *)color
{
    NSMutableArray *mRGB = [NSMutableArray arrayWithArray:[[NSString stringWithFormat:@"%@", color] componentsSeparatedByString:@" "]];
    [mRGB removeObjectAtIndex:0];
    if (mRGB.count<4) {
        
        for (int i =0; i <4-mRGB.count+1; i ++) {
            
            [mRGB insertObject:@"0" atIndex:0];
        }
    }
    return [mRGB componentsJoinedByString:@","];
}

// 反序列化
+ (NSMutableDictionary *)readJsonByPath:(NSString *)path
{
    // json反序列化
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    if (data) {
        
        id JsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        return JsonObject;
    }
    return nil;
}

// 序列化
+ (NSString *)writeJson:(id)dic dir:(NSString *)dir
{
    NSString *path;
    if (dir == nil) {
        
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", [JMHelper timerString]]];
    }else{
    
        path = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", [JMHelper timerString]]];;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        
        // 写入本地文件
        if ([jsonData writeToFile:path atomically:YES]) {
        
            return path;
        }else{
        
            return path;
        }
    }else{
        return nil;
    }
}

// 序列化
+ (NSString *)writeJsonToDocmentFile:(NSMutableDictionary *)dic
{
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSTimeInterval tmp =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    NSString *fileName = [NSString stringWithFormat:@"%f.json", tmp];
    NSString *path = [cachesDir stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        
        // 写入本地文件
        if ([jsonData writeToFile:path atomically:YES]) {
            
            return path;
        }else{
            
            return path;
        }
    }else{
        return nil;
    }
}


/******************************************************************************/
+ (NSMutableDictionary *)transformData:(NSMutableArray *)data;
{
    return [NSMutableDictionary dictionaryWithDictionary:@{@"dt":[data mutableCopy]}];
}

+ (NSString *)jsonString:(CGPoint)start en:(CGPoint)end type:(NSInteger)type back:(BOOL)isBack clearAll:(BOOL)isClear fill:(BOOL)isFill
{
    NSString *tp = [NSString stringWithFormat:@"%ld", type];
    NSString *st = NSStringFromCGPoint(start);
    NSString *en = NSStringFromCGPoint(end);
    NSArray *dt = @[st, en];
    NSString *lw = [NSString stringWithFormat:@"%.2f", [StaticClass getLineWidth]];
    NSString *lc = [self getRGB:[StaticClass getColor]];
    NSString *bk = [NSString stringWithFormat:@"%d", isBack];
    NSString *cl = [NSString stringWithFormat:@"%d", isClear];
    NSString *fl = [NSString stringWithFormat:@"%d", isFill];
    
    return [self dictionaryToJson:@{@"tp":tp, @"st":st, @"en":en, @"lw":lw, @"lc":lc, @"bk":bk, @"cl":cl, @"fl":fl, @"dt":dt}];
}

+ (NSMutableDictionary *)jsonData:(CGPoint)start en:(CGPoint)end type:(NSInteger)type back:(BOOL)isBack clearAll:(BOOL)isClear fill:(BOOL)isFill
{
    NSString *tp = [NSString stringWithFormat:@"%ld", type];
    NSString *st = NSStringFromCGPoint(start);
    NSString *en = NSStringFromCGPoint(end);
    NSArray *dt = @[st, en];
    NSString *lw = [NSString stringWithFormat:@"%.2f", [StaticClass getLineWidth]];
    NSString *lc = [self getRGB:[StaticClass getColor]];
    NSString *bk = [NSString stringWithFormat:@"%d", isBack];
    NSString *cl = [NSString stringWithFormat:@"%d", isClear];
    NSString *fl = [NSString stringWithFormat:@"%d", isFill];
    return [NSMutableDictionary dictionaryWithDictionary:@{@"tp":tp, @"lw":lw, @"lc":lc, @"bk":bk, @"cl":cl, @"fl":fl, @"dt":dt}];
}

+ (long long)getFilesByExtension:(NSString *)extension path:(NSString *)filePath
{
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL dir = NO;
    BOOL exist = [manger fileExistsAtPath:filePath isDirectory:&dir];
    long long sumSize = 0;
    
    // 文件不存在
    if (!exist) return 0;
    
    if (dir) {
        
        NSArray *array = [manger contentsOfDirectoryAtPath:filePath error:nil];
        
        for (NSString *fileName in array) {
            
            if ([[[fileName pathExtension] lowercaseString] isEqualToString:extension]) {
                
                sumSize += [[manger attributesOfItemAtPath:[filePath stringByAppendingPathComponent:fileName] error:nil] fileSize];
            }
        }
    }
    
    return sumSize/1048576.f;
}

+ (NSString *)timerString
{
    NSTimeInterval tmp =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    return [[NSString stringWithFormat:@"%f", tmp] componentsSeparatedByString:@"."].firstObject;
}

+ (NSString *)timestamp:(NSString *)timestring
{
    NSTimeInterval _interval=[timestring doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy/MM/dd/HH/mm"];
    return [objDateformat stringFromDate: date];
}

// 创建文件夹
+ (NSString *)creatFolder:(NSString *)name dir:(NSString *)dir
{
    BOOL isDir = NO;
    NSString *pathDir = [dir stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:pathDir isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        BOOL isSuccess = [fileManager createDirectoryAtPath:pathDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (isSuccess) {
            
            return pathDir;
        }else{
        
            return nil;
        }
    }else{
    
        return nil;
    }
}

+ (NSMutableArray *)getTopBarModel
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"topBarJson" ofType:@"json"];
    NSDictionary *jsonDic = [self readJsonByPath:jsonPath];
    NSArray *topBarArray = jsonDic[@"topBar"];
    NSMutableArray *topBars = [NSMutableArray array];
    
    for (int i = 0; i < topBarArray.count; i ++) {
        
        NSDictionary *dict = topBarArray[i];
        NSString *title = dict.allKeys.lastObject;
        NSDictionary *valueDic = dict.allValues.lastObject;
        
        JMTopBarModel *model = [[JMTopBarModel alloc] init];
        model.title = title;
        if (i == 2) {model.column = 3;}
        model.column = 1;
        [topBars addObject:model];
        
        NSArray *imageArray = valueDic[@"imageName"];
        NSArray *titleArray = valueDic[@"showName"];
        NSString *isColor = valueDic[@"color"];
        NSInteger type = [valueDic[@"type"] integerValue];
        NSMutableArray *rows = [NSMutableArray array];
        
        if ([isColor isEqualToString:@"1"]) {
            
            NSArray *colors = valueDic[@"colorArr"];
            for (int i = 0; i < imageArray.count; i ++) {
                
                JMBottomModel *model = [[JMBottomModel alloc] init];
                model.title = titleArray[i];
                model.image = imageArray[i];
                model.backgroundColor = colors[i];
                model.type = type;
                [rows addObject:model];
            }
        }else{
            
            for (int i = 0; i < imageArray.count; i ++) {
                
                JMBottomModel *model = [[JMBottomModel alloc] init];
                model.title = titleArray[i];
                model.image = imageArray[i];
                model.backgroundColor = nil;
                model.type = type;
                [rows addObject:model];
            }
        }
        
        model.models = rows;
    }
    
    return topBars;
}


@end
