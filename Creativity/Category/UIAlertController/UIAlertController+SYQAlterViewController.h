//
//  UIAlertController+SYQAlterViewController.h
//
//  Created by JM Zhao on 16/7/01.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (SYQAlterViewController)
/**
 *输入框
 *
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:( NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle textFilfPlaceHolders:(NSArray<NSString *> *) placeholders  confirmHandel:(void(^)(NSArray <NSString *>* alterTextFs)) confirmHandel cancelHandel:(void(^)()) canelHander;

/**
 *无输入框
 *
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:( NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle confirmHandel:(void(^)()) confirmHandel cancelHandel:(void(^)())cancelHandel;

@end
