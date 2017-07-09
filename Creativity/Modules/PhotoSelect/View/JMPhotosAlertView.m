//
//  JMPhotosAlertView.m
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMPhotosAlertView.h"

@implementation JMPhotosAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        NSArray *array = @[@"本地创建", @"连拍快照", @"相册", @"livePhotos", @"GIF", @"取消"];
        
        int i = 0;
        for (NSString *name in array) {
            
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            btn.tag = i + 200;
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 8;
            btn.layer.masksToBounds = YES;
            
            [btn setTitle:name forState:(UIControlStateNormal)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTintColor:[UIColor redColor]];
            [btn addTarget:self action:@selector(btnTargenAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btn];
            i ++;
        }
    }
    return self;
}

- (void)btnTargenAction:(UIButton *)sender
{
    if (sender.tag < 205) {
        
        if ([self.delegate respondsToSelector:@selector(photoFromSource:)]) {
            
            [self.delegate photoFromSource:sender.tag];
        }
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = CGRectMake(0, kH, kW, self.height);
        self.superview.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.superview removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat margin = 4;
    for (UIView *view in self.subviews) {
        
        view.frame = CGRectMake(20, margin+(44+margin)*i, self.bounds.size.width-40, 44);
        i ++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
