//
//  JMFileManger.h
//  YaoYao
//
//  Created by JM Zhao on 2017/1/3.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFileManger : NSObject
+ (void)clearCache:(NSString *)folderPath;
+ (BOOL)removeFileByPath:(NSString *)fileName;
+ (BOOL)creatDir:(NSString *)dirName;
+ (NSMutableArray *)getFileFromDir:(NSString *)dir bySuffix:(NSString *)suffix;
+ (NSMutableArray *)homeModels;
+ (void)copyFile2Documents;
@end
