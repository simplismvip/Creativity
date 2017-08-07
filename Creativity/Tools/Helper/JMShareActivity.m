//
//  JMShareActivity.m
//  dsaf
//
//  Created by JM Zhao on 2017/8/7.
//  Copyright © 2017年 huaban. All rights reserved.
//

#import "JMShareActivity.h"

@implementation JMShareActivity

- (instancetype)initWithTitle:(NSString *)title type:(NSString *)types
{
    if (self = [super init]) {
        
        self.title = title;
        self.type = types;
    }
    return self;
}

- (NSString *)activityTitle
{
    return self.title;
}

- (NSString *)activityType
{
    return self.type;
}

- (UIImage *)activityImage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"share_weChat" ofType:@"png"];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:path] scale:2.0];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    
}

- (void)performActivity
{
    if ([self.delegate respondsToSelector:@selector(share:)]) {
        
        [self.delegate share:self.type];
    }
}

@end
