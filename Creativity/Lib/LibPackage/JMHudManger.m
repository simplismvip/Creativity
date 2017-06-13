//
//  JMHudManger.m
//  YaoYao
//
//  Created by JM Zhao on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "JMHudManger.h"
#import "MBProgressHUD.h"

@implementation JMHudManger

+ (MBProgressHUD *)hudAddTo:(UIView *)view
{
    return [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (MBProgressHUD *)hudForView:(UIView *)view
{
    return [MBProgressHUD HUDForView:view];
}

+ (void)hudHide:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self hudForView:view] hideAnimated:YES];
    });
}

+ (void)hudHide:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self hudForView:view] hideAnimated:YES afterDelay:delay];
    });
}

+ (void)hudAddTo:(UIView *)view message:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    [self hudAddTo:view message:message];
    [self hudHide:view afterDelay:delay];
}

+ (void)hudAddTo:(UIView *)view message:(NSString *)message
{
    MBProgressHUD *hud = [self hudAddTo:view];
    
    if (message != nil) {
        
        hud.mode = MBProgressHUDModeText;
        hud.label.text = message;
    }
}

+ (void)hudProgressAddTo:(UIView *)view message:(NSString *)message
{
    MBProgressHUD *hud = [self hudAddTo:view];
    hud.label.text = message;
}

+ (void)hudCustomViewAddTo:(UIView *)view imageName:(NSString *)imageName message:(NSString *)message
{
    MBProgressHUD *hud = [self hudAddTo:view];
    
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1.f];
}

+ (void)hudProgressViewAddTo:(UIView *)view progress:(CGFloat)progress
{
    MBProgressHUD *hud = [self hudAddTo:view];
    hud.mode = MBProgressHUDModeDeterminate;
}

+ (void)hudBarProgressAddTo:(UIView *)view progress:(CGFloat)progress message:(NSString *)message
{
    MBProgressHUD *hud = [self hudAddTo:view];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = message;
}

+ (void)refreshProgress:(CGFloat)progress view:(UIView *)view
{
    [self hudAddTo:view].progress = progress;
}

@end
