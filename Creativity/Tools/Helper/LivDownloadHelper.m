//
//  LivDownloadHelper.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/21.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "LivDownloadHelper.h"

@implementation LivDownloadHelper

+ (void)loadLIvFileWithUrl:(NSString *)urlString progress:(progressBlock)progress success:(downloadSuccess)success fail:(downloadFail)fail
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        CGFloat size = (CGFloat)downloadProgress.totalUnitCount/1048576.f;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progress) {progress(downloadProgress.fractionCompleted, size);}
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success([NSMutableArray arrayWithObjects:responseObject, nil]);}
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {fail(error);}
    }];
    
}

+ (void)downloadLIvFileWithUrl:(NSURL *)url progress:(progressBlock)progress success:(downloadSuccess)success fail:(downloadFail)fail
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        CGFloat pro = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progress) {progress(pro, 122);}
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (success) {success([NSMutableArray arrayWithObjects:filePath, nil]);}
    }];
}
@end
