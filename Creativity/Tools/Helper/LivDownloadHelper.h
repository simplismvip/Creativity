//
//  LivDownloadHelper.h
//  LivDownload
//
//  Created by JM Zhao on 2017/2/21.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^downloadSuccess)(NSMutableArray *success);
typedef void(^downloadFail)(NSError *fail);
typedef void(^progressBlock)(CGFloat progress, CGFloat sumSize);

@interface LivDownloadHelper : NSObject
+ (void)loadLIvFileWithUrl:(NSString *)urlString progress:(progressBlock)progress success:(downloadSuccess)success fail:(downloadFail)fail;
+ (void)downloadLIvFileWithUrl:(NSURL *)url progress:(progressBlock)progress success:(downloadSuccess)success fail:(downloadFail)fail;
@end
