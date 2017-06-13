//
//  JMHudManger.h
//  YaoYao
//
//  Created by JM Zhao on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHudManger : NSObject

/**
 *  刷新进度
 *
 *  @param view    进度条添加的View
 *  @param progress  只要添加的hudView有progress参数就必须调用这个方法舒心进度
 */
+ (void)refreshProgress:(CGFloat)progress view:(UIView *)view;
/**
 *  添加自定义显示进度
 *
 *  @param view    进度条添加的View
 *  @param       imageName 自定义的View的照片名字
 *  @param message  如果参数为nil显示进度动画没有任何文字提示, 如果参数不为nil显示文字和进度动画
 */
+ (void)hudCustomViewAddTo:(UIView *)view imageName:(NSString *)imageName message:(NSString *)message;
/**
 *  需要设置progress
 *
 *  @param view    进度条添加的View
 *  @param progress  如果参数为nil显示进度动画没有任何文字提示, 如果参数不为nil显示文字和进度动画
 */
+ (void)hudProgressViewAddTo:(UIView *)view progress:(CGFloat)progress;
/**
 *  需要设置progress
 *
 *  @param view    进度条添加的View
 *  @param message  如果参数为nil显示进度动画没有任何文字提示, 如果参数不为nil显示文字和进度动画
 */
+ (void)hudBarProgressAddTo:(UIView *)view progress:(CGFloat)progress message:(NSString *)message;

/**
 *  显示进度
 *
 *  @param view    进度条添加的View
 *  @param message  如果参数为nil显示进度动画没有任何文字提示, 如果参数不为nil显示文字和进度动画
 */
+ (void)hudProgressAddTo:(UIView *)view message:(NSString *)message;
/**
 *  显示消息
 *
 *  @param view    消息添加的View
 *  @param message 如果参数为nil显示进度动画没有任何文字提示, 如果参数不为nil则只显示文字, 不显示进度动画
 */
+ (void)hudAddTo:(UIView *)view message:(NSString *)message;

/**
 *  隐藏进度条
 *
 *  @param view  进度添加的View
 *  @param delay 延迟移除的时间
 */
+ (void)hudHide:(UIView *)view afterDelay:(NSTimeInterval)delay;
/**
 *  隐藏进度条
 *
 *  @param 进度添加的View
 */
+ (void)hudHide:(UIView *)view;

+ (void)hudAddTo:(UIView *)view message:(NSString *)message afterDelay:(NSTimeInterval)delay;

@end
