//
//  JMFileManger.h
//  YaoYao
//
//  Created by JM Zhao on 2017/1/3.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFileManger : NSObject

+ (BOOL)creatDir:(NSString *)dirName;
+ (NSMutableArray *)getFileFromDir:(NSString *)dir bySuffix:(NSString *)suffix;
@end
