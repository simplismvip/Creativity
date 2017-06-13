//
//  JMFmdbManger.h
//  YaoYao
//
//  Created by JM Zhao on 2016/12/1.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
//数据库类型
#define JMTEXT    @"TEXT"
#define JMREAL    @"REAL"
#define JMBLOB    @"BLOB"
#define JMNULL    @"NULL"
#define JMINTEGER  @"INTEGER"

#define PrimaryKey  @"primary key"
#define primaryId   @"pk"
#define JMMODEL   @"MODEL"   //sqlite没有model这个数据类型，这只是为了与数组进行区分

@interface JMFmdbManger : NSObject

@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic,strong,readonly) FMDatabaseQueue *dbQueue;

+ (instancetype)shareDBManger;
- (BOOL)creatDB:(NSString *)path;
- (BOOL)creatDBQueue:(NSString *)path;
//- (BOOL)insertDB:(NSDictionary *)fieldDic;

// 创建表, 字点key为数据类型, value为字段名.
- (BOOL)creatTable:(NSString *)name fields:(NSArray<NSDictionary *>*)fields;

// 增
- (BOOL)insertDB:(NSArray<NSDictionary *>*)fields;

// 删, 根据字段删除和根据主键删除, 先检查字段, 如果字段为空检测主键, 只要有字段不检查主键
- (BOOL)deleteDB:(NSInteger)ids;

// 改
- (BOOL)changeDB:(NSArray *)fields;


// 查
- (BOOL)selectDB:(NSArray *)fields;

- (BOOL)dropTable;

@end
