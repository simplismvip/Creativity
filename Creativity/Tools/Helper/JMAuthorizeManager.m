//
//  JMAuthorizeManager.m
//  Creativity
//
//  Created by JM Zhao on 2017/7/20.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMAuthorizeManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation JMAuthorizeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JMAuthorizeManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[JMAuthorizeManager alloc] init];
    });
    return manager;
}

- (BOOL)requestPhotoAccessCompletionHandler:(void (^)(BOOL, NSError *))handler
{
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    if (authorizationStatus == PHAuthorizationStatusAuthorized){
    
        if (handler) {handler(YES, nil);}
    }else{
    
        if (PHAuthorizationStatusAuthorized == authorizationStatus || PHAuthorizationStatusDenied == authorizationStatus) {
            
            NSString *errMsg = NSLocalizedString(@"此应用需要访问相册，请设置", @"此应用需要访问相册，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(NO,error);
            return NO;
        }
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusDenied) {
                
                NSString *errMsg = NSLocalizedString(@"不允许访问相册", @"不允许访问相册");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                handler(NO,error);
            }
        }];
    };
    
    return YES;
}

- (BOOL)requestVideoAccessCompletionHandler:(void(^)(BOOL,NSError *))handler
{
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus){
        handler(YES,nil);
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(NO,error);
            return NO;
        }
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                NSString *errMsg = NSLocalizedString(@"不允许访问摄像头", @"不允许访问摄像头");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                handler(NO,error);
            }
        }];
    }
    return YES;
}

//应用程序需要事先申请音视频使用权限
- (BOOL)requestMediaCapturerAccessWithCompletionHandler:(void (^)(BOOL, NSError*))handler
{
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus && AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        handler(YES,nil);
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(NO,error);
            
            return NO;
        }
        
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问麦克风，请设置", @"此应用需要访问麦克风，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(NO,error);
            
            return NO;
        }
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        handler(YES,nil);
                    }else{
                        NSString *errMsg = NSLocalizedString(@"不允许访问麦克风", @"不允许访问麦克风");
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                        NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                        handler(NO,error);
                    }
                }];
            }else{
                NSString *errMsg = NSLocalizedString(@"不允许访问摄像头", @"不允许访问摄像头");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                handler(NO,error);
            }
        }];
        
    }
    return YES;
}

@end
