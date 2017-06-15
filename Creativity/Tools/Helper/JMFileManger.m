//
//  JMFileManger.m
//  YaoYao
//
//  Created by JM Zhao on 2017/1/3.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMFileManger.h"

@implementation JMFileManger

+ (BOOL)creatDir:(NSString *)dirName
{
    NSFileManager *manger = [NSFileManager defaultManager];
    
    BOOL dir        = NO;
    BOOL exist       = [manger fileExistsAtPath:dirName isDirectory:&dir];
    
    // 文件不存在
    if (!exist&&!dir) {
    
        return [manger createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        return NO;
    }
}

+ (NSMutableArray *)getFileFromDir:(NSString *)dir bySuffix:(NSString *)suffix
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSError *error;
    NSArray *array = [manger contentsOfDirectoryAtPath:dir error:&error];
    NSMutableArray *pngs = [NSMutableArray array];
    if (!error) {
        
        for (NSString *name in array) {
            
            if ([name hasSuffix:suffix]) {
                
                [pngs addObject:[dir stringByAppendingPathComponent:name]];
            }
        }
    }
    
    return pngs;
}


@end
