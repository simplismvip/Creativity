//
//  DeviceHelper.m
//  CollectionViewTest
//
//  Created by JM Zhao on 2017/6/19.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "DeviceHelper.h"
#import <UIKit/UIKit.h>

@implementation DeviceHelper

+ (NSDictionary *)deviceInfo
{
    // 设备名称  e.g. "My iPhone"
    NSString *strName = [[UIDevice currentDevice] name];
    
    // 系统名称 e.g. @"iOS"
    NSString *strSysName = [[UIDevice currentDevice] systemName];
    
    // 系统版本号 e.g. @"4.0"
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    
    // 设备类型 e.g. @"iPhone", @"iPod touch"
    NSString *strModel = [[UIDevice currentDevice] model];
    
    // 本地设备模式 localized version of model
    NSString *strLocModel = [[UIDevice currentDevice] localizedModel];
    
    // UUID 　可用于唯一地标识该设备
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    
    return @{@"deviceName":strName, @"SysName":strSysName, @"SysVersion":strSysVersion, @"deviceModel":strModel, @"strLocModel":strLocModel, @"uuid":identifierForVendor.UUIDString};
}

+ (void)addOrientationNotifications:(id)target notiName:(NSNotificationName)notiName object:(id)object
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(handleDeviceOrientationDidChange:) name:notiName object:object];
}

+ (void)removeOrientationNotifications:(id)target notiName:(NSNotificationName)notiName object:(id)object
{
    [[NSNotificationCenter defaultCenter] removeObserver:target name:UIDeviceOrientationDidChangeNotification object:object];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            NSLog(@"无法辨识");
            break;
    }
}

@end
