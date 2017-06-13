//
//  Tool_FMDBGetDatabase.m
//  FMDB封装
//
//  Created by Yang on 16/3/24.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import "Tool_FMDBGetDatabase.h"

@implementation Tool_FMDBGetDatabase

@synthesize dbQueue = _dbQueue;


static Tool_FMDBGetDatabase *tool_database = nil;

//单例
+ (instancetype)shareTool_FMDBGetDatabase
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        tool_database = [[self alloc] init] ;
    }) ;
    return tool_database;
}
- (id)copyWithZone:(struct _NSZone *)zone
{
    return [Tool_FMDBGetDatabase shareTool_FMDBGetDatabase];
}

//创建数据库保存路径
+ (NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    docsdir = [docsdir stringByAppendingPathComponent:@"Contact"];
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"contact.sqlite"];
    
    return dbpath;
}

//创建多线程安全的数据库
- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}
@end
