//
//  Tool_FMDBGetDatabase.h
//  FMDB封装
//
//  Created by Yang on 16/3/24.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface Tool_FMDBGetDatabase : NSObject

@property(nonatomic,strong,readonly)FMDatabaseQueue *dbQueue;

+ (instancetype)shareTool_FMDBGetDatabase;

// 创建文件夹，拼接数据库路径（此时数据库还没创建）
+ (NSString *)dbPath;
@end
