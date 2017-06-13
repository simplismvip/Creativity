//
//  UINavigationBar+JMNavigationBar.m
//  PageShare
//
//  Created by JM Zhao on 2017/3/10.
//  Copyright © 2017年 Oneplus Smartware. All rights reserved.
//

#import "UINavigationBar+JMNavigationBar.h"

@implementation UINavigationBar (JMNavigationBar)

- (void)setNavigationBarLine:(CGFloat)alpha
{
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            
            [[obj subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[UIImageView class]]) {
                    
                    obj.alpha = alpha;
                }
            }];
        }
    }];
}

@end
