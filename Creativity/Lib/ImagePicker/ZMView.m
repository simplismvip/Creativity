//
//  ViewController.m
//  PhotoPicter
//
//  Created by 岳利超 on 16/6/24.
//  Copyright © 2016年 mac003-20130924. All rights reserved.
//

#import "ZMView.h"

@implementation ZMView
#pragma mark - 把图片保存到本地路径
- (NSString *)saveImageToLocalimage:(UIImage*)image filename:(NSString*)filename{
    
    NSString* path = nil;
    path = [self getChatFilePathIgnoreSame:filename];
    if(![self isFileExist:path]){
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:path atomically:YES];
    }
    return path;
    
}

- (BOOL)isFileExist:(NSString *)filePath
{
    BOOL ret = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ret = [fileManager fileExistsAtPath:filePath];
    
    return ret;
}
#pragma mark -获取可写路径
- (NSString*)getChatFilePathIgnoreSame:(NSString*)name{
    
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                     NSUserDomainMask,
                                                                     YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSMutableString* path = [[NSMutableString alloc]initWithString:documentDirectory];
    [path appendString:@"//"];
    [path appendString:@"images"];
    
    BOOL isDirectory = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory])
    {
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(success)
        {
            NSLog(@"创建成功");
        }
    }
    [path appendString:@"//"];
    [path appendString:name];
    
    return path;
}

@end
