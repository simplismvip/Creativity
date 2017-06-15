//
//  JMGestureButton.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/19.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMGestureButton.h"

@implementation JMGestureButton

+ (JMGestureButton *)creatGestureButton
{
    JMGestureButton *gesture = [self buttonWithType:(UIButtonTypeSystem)];
    gesture.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    gesture.backgroundColor = [UIColor clearColor];
    [gesture addTarget:gesture action:@selector(rem_GestureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [[[UIApplication sharedApplication] keyWindow] addSubview:gesture];
    return gesture;
}
    
+ (JMGestureButton *)creatGestureButton:(UIView *)suView
{
    JMGestureButton *gesture = [self buttonWithType:(UIButtonTypeSystem)];
    gesture.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    gesture.backgroundColor = [UIColor clearColor];
    [gesture addTarget:gesture action:@selector(rem_GestureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [suView addSubview:gesture];
    return gesture;
}

- (void)rem_GestureBtn:(JMGestureButton *)sender
{
    for (UIView *v in self.subviews) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            v.frame = CGRectMake(v.x, self.height, v.width, v.height);
            
        } completion:^(BOOL finished) {
            
            [sender removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(didRemove)]) {[self.delegate didRemove];}
        }];
    }
}

+ (JMGestureButton *)getGestureButton
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    JMGestureButton *gesBen;
    for (UIView *view in keyWindow.subviews) {
        
        if ([view isKindOfClass:[JMGestureButton class]]) {
            
            gesBen = (JMGestureButton *)view;
        }
    }
    
    return gesBen;
}


/*
 
 // 命中测试
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}
*/

@end
