//
//  JMFileManger.m
//  YaoYao
//
//  Created by JM Zhao on 2017/1/3.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMFileManger.h"
#import "JMHomeModel.h"
#import "NSObject+JMProperty.h"

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

// 根据路径删除文件
+ (BOOL)removeFileByPath:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 文件夹路径
    NSString *pathDir = fileName;
    
    BOOL isDir               = NO;
    BOOL existed               = [fileManager fileExistsAtPath:pathDir isDirectory:&isDir];
    
    // 文件夹不存在直接返回
    if ( !(isDir == YES && existed == YES) ){
        
        return NO;
        
    }else{ // 文件夹存在
        
        return [fileManager removeItemAtPath:fileName error:nil];
    }
}

+ (void)clearCache:(NSString *)folderPath
{
    NSError *error;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    
    for (NSString *dir in array) {
        
        NSArray *jsons = [JMFileManger getFileFromDir:[folderPath stringByAppendingPathComponent:dir] bySuffix:@"gif"];
        
        if (jsons.count == 0) {
            
            [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:dir] error:nil];
        }
    }
}

+ (NSMutableArray *)homeModels
{
    NSError *error;
    NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:JMDocumentsPath error:&error];
    if (!error) {
    
        NSMutableArray *dataSource = [NSMutableArray array];
        for (NSString *path in dirs) {
            
            if (![path isEqualToString:@".DS_Store"]) {
                
                NSArray *pngs = [self getFileFromDir:[JMDocumentsPath stringByAppendingPathComponent:path] bySuffix:@"gif"];
                if (pngs.count>0) {
                    
                    NSDictionary *dic = @{@"folderPath":pngs.firstObject};
                    JMHomeModel *model = [JMHomeModel objectWithDictionary:dic];
                    [dataSource addObject:model];
                }
            }
        }
        
        return dataSource;
    }else{
    
        return nil;
    }
}

@end
