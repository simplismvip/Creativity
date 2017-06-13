//
//  NSString+Reglx.m
//  Text-图文混排
//
//  Created by Mac on 16/3/8.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "NSString+Reglx.h"

@implementation NSString (Reglx)
- (BOOL)isQQ
{
    // 制定的规则
    NSString *patten = @"^[1-9]\\d{4,10}$";
    
    return  [self match:patten];
}

- (BOOL)isPhoneNumber
{
    // 制定的规则
    NSString *patten = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    return  [self match:patten];
}

- (BOOL)isEmail
{
    // 制定的规则
    NSString *patten = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    return  [self match:patten];
}

- (BOOL)isIpAddress
{
    // 制定的规则
    NSString *patten = @"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$";
    
    return  [self match:patten];
}

- (BOOL)isUrl
{
    // 制定的规则
    NSString *patten = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    
    // NSString *patten1 = @"^(http://|https://)?((?:[A-Za-z0-9]+-[A-Za-z0-9]+|[A-Za-z0-9]+)\.)+([A-Za-z]+)[/\?\:]?.*$";
    
    return  [self match:patten];
}


- (BOOL)match:(NSString *)patten
{
    // 匹配规则
    NSRegularExpression *regul = [NSRegularExpression regularExpressionWithPattern:patten options:0 error:nil];
    
    // 返回匹配结果
    NSArray *result = [regul matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return  result.count > 0;
}


@end
