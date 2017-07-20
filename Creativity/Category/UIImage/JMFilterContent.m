//
//  JMFilterContent.m
//  PhotoFilters
//
//  Created by JM Zhao on 2017/7/20.
//  Copyright © 2017年 Icoms. All rights reserved.
//

#import "JMFilterContent.h"

@implementation JMFilterContent
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JMFilterContent *ne_authorizeManager = nil;
    dispatch_once(&onceToken, ^{
        ne_authorizeManager = [[JMFilterContent alloc] init];
    });
    return ne_authorizeManager;
}

@end
