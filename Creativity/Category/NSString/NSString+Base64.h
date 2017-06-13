//
//  NSString+Base64.h
//  PageShare
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 Oneplus Smartware. All rights reserved.
//


#import <Foundation/Foundation.h>
@interface NSString (Base64)
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;
@end
