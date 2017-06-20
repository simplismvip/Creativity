//
//  JMBaseBottomView.m
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMBaseBottomView.h"
#import "JMBottomCell.h"
#import "JMBottomModel.h"

@implementation JMBaseBottomView

- (instancetype)initWithCount:(NSArray *)subViews
{
    JMBaseBottomView *bsae = [[JMBaseBottomView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        bsae.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
    }];
    
    int i = 0;
    for (JMBottomModel *bottomModel in subViews) {
        
        JMBottomCell *btn = [[JMBottomCell alloc] init];
        [btn setTitle:bottomModel.title forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageWithTemplateName:bottomModel.image] forState:(UIControlStateNormal)];
        btn.backgroundColor = JMColor(31, 31, 31);
        [btn setTintColor:JMBaseColor];
        btn.tag = i+200;
        [btn addTarget:self action:@selector(select:) forControlEvents:(UIControlEventTouchUpInside)];
        [bsae addSubview:btn];
        i ++;
    }
    
    return bsae;
}

- (void)select:(UIButton *)selectCell
{
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
    
        [UIView animateWithDuration:0.3 animations:^{
            
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 44);
            
        } completion:^(BOOL finished) {
         
            [self.delegate didSelectRowAtIndexPath:selectCell.tag-200];
            [self removeFromSuperview];
        }];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width/self.subviews.count;
    int i = 0;
    for (UIView *view in self.subviews) {
        
        view.frame = CGRectMake(i*w, 0, w, self.bounds.size.height);
        i ++;
    }
}


@end
