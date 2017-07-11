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
        NSArray *array = @[
                           NSLocalizedString(@"gif.home.bottom.alert.board", ""),
                           NSLocalizedString(@"gif.home.bottom.alert.album", ""),
                           NSLocalizedString(@"gif.home.bottom.alert.gif", ""),
                           NSLocalizedString(@"gif.base.alert.cancle", "")];
        
        int i = 0;
        for (NSString *name in array) {
            
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            btn.tag = i + 200;
//            btn.layer.borderColor = JMColor(230, 230, 230).CGColor;
//            btn.layer.borderWidth = 1;
//            btn.layer.cornerRadius = 10;
//            btn.layer.masksToBounds = YES;
            
            [btn setTitle:name forState:(UIControlStateNormal)];
            btn.backgroundColor = JMColor(100, 100, 100);
            [btn setTintColor:[UIColor whiteColor]];
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
    for (UIView *view in self.subviews) {
        
        CGFloat y;
        if (i<3) {y = (alertHeight+1)*i;
        }else{y = self.height-alertHeight;}
        view.frame = CGRectMake(0, y, kW, alertHeight);
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
