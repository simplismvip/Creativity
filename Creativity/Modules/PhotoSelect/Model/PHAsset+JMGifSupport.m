//
//  PHAsset+JMGifSupport.m
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "PHAsset+JMGifSupport.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation PHAsset (JMGifSupport)

- (BOOL)isGif
{
    return [self valueForKey:@"filename"];;
}

@end
