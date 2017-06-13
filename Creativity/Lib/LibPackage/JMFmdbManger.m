//
//  JMFmdbManger.m
//  YaoYao
//
//  Created by JM Zhao on 2016/12/1.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMFmdbManger.h"

static JMFmdbManger *dbManger = nil;

@implementation JMFmdbManger

// 单例
+ (instancetype)shareDBManger
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        dbManger = [[self alloc] init] ;
    }) ;
    return dbManger;
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [JMFmdbManger shareDBManger];
}

- (BOOL)creatDB:(NSString *)path
{
    self.db = [FMDatabase databaseWithPath:path];
    if ([_db open]) {return YES;}
    else{
        _db = nil;
        return NO;
    }
}

- (BOOL)creatDBQueue:(NSString *)path
{
    if (!self.dbQueue) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:path];
        if (_dbQueue) {return YES;}else{return NO;}
    }else{
        return YES;
    }
}

// 创建表 @{@"name":@"TEXT"}
- (BOOL)creatTable:(NSString *)name fields:(NSArray<NSDictionary *>*)fields
{
    if ([_db open]) {
        
        NSMutableString *sqlString = [NSMutableString stringWithString:@"id integer PRIMARY KEY, "];
        for (NSDictionary *dic in fields) {
            
            [sqlString appendFormat:@"%@ %@, ", dic.allKeys.firstObject, dic.allValues.firstObject];
        }
        
        [sqlString deleteCharactersInRange:NSMakeRange(sqlString.length-2, 1)];
        return [_db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);", name, sqlString]];
        
    }else{return NO;}
}

// 增 @{@"name":@"values"}
- (BOOL)insertDB:(NSArray<NSDictionary *>*)fields
{
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSDictionary *dic in fields) {
        
        [valueString appendString:@"?, "];
        [keyString appendFormat:@"%@, ", dic.allKeys.firstObject];
        if (!dic.allValues.firstObject) {[values addObject:@""];
        }else{[values addObject:dic.allValues.firstObject];}
    }
    
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length-2, 1)];
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length-2, 1)];
    return [_db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", @"T_Students", keyString, valueString] withArgumentsInArray:values];
}

// 删
- (BOOL)deleteDB:(NSInteger)ids
{
    return [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?", @"T_Students"], @(ids)];
}
//
//
//// 改
//- (BOOL)changeDB:(NSArray *)fields
//{
//
//}
//
//
//// 查
//- (BOOL)selectDB:(NSArray *)fields
//{
//
//}

- (BOOL)dropTable{
    
    return [_db executeUpdate:@"DROP TABLE IF EXISTS T_Students;"];
}
@end
