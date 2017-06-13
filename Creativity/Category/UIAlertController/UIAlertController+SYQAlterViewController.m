//
//  UIAlertController+SYQAlterViewController.m
//
//  Created by JM Zhao on 16/7/01.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UIAlertController+SYQAlterViewController.h"

@implementation UIAlertController (SYQAlterViewController)

+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:( NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle textFilfPlaceHolders:(NSArray<NSString *> *) placeholders  confirmHandel:(void(^)(NSArray <NSString *>* alterTextFs)) confirmHandel cancelHandel:(void(^)()) canelHander{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    UIAlertAction *shureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandel) {
            NSMutableArray *temArr = [NSMutableArray array];
            [alertC.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [temArr addObject:obj.text];
            }];
            confirmHandel([temArr copy]);
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (canelHander) {
            canelHander();
        }
    }];
    
    [alertC addAction:shureAction];
    [alertC addAction:cancelAction];
    
    [placeholders enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholders[idx];
        }];

    }];
//    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = placeholders[0];
//    }];
//    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = placeholders[1];
//    }];
    return alertC;
}


+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:( NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle confirmHandel:(void(^)()) confirmHandel cancelHandel:(void(^)())cancelHandel{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIAlertAction *shureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandel) {
            confirmHandel();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandel) {
            cancelHandel();
        }
    }];
    [alertC addAction:shureAction];
    [alertC addAction:cancelAction];    
    return alertC;
}


@end
