//
//  JMBuyHelper.m
//  Creativity
//
//  Created by JM Zhao on 2017/7/6.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMBuyHelper.h"
#import "JMUserDefault.h"

#define kVIP @"superUser"

@implementation JMBuyHelper

+ (BOOL)setVIP
{
    return [JMUserDefault setBool:YES forKey:kVIP];
}

+ (BOOL)isVip
{
    return [JMUserDefault readBoolByKey:kVIP];
}

@end
