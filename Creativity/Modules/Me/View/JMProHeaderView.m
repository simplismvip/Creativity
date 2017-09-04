//
//  JMProHeaderView.m
//  Creativity
//
//  Created by 赵俊明 on 2017/6/20.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMProHeaderView.h"

@interface JMProHeaderView()
@property (nonatomic, weak) UILabel *frist;
@property (nonatomic, weak) UILabel *sec;
@property (nonatomic, weak) UIButton *button;
@end

@implementation JMProHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *frist = [[UILabel alloc] init];
//        frist.textColor = JMBaseColor;
        frist.textAlignment = NSTextAlignmentCenter;
        frist.font = [UIFont systemFontOfSize:26];
        [self addSubview:frist];
        self.frist = frist;
        
        UILabel *sec = [[UILabel alloc] init];
        sec.textAlignment = NSTextAlignmentCenter;
//        sec.textColor = [UIColor whiteColor];
        sec.font = [UIFont systemFontOfSize:16];
        [self addSubview:sec];
        self.sec = sec;
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.layer.borderColor = JMBaseColor.CGColor;
        button.layer.borderWidth = 2;
        button.layer.cornerRadius = 20;
        [button addTarget:self action:@selector(buyPro:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTintColor:[UIColor redColor]];
        [self addSubview:button];
        self.button = button;
        
        if ([JMBuyHelper isVip]) {
            
            frist.text = NSLocalizedString(@"gif.BuyPro.headerGetVip.VIP", "");
            sec.text = NSLocalizedString(@"gif.BuyPro.headerGetVipSubTitle.VIP", "");
            button.userInteractionEnabled = NO;
            [button setTitle:NSLocalizedString(@"gif.BuyPro.headerGetSuperUser.VIP", "") forState:(UIControlStateNormal)];
            
        }else{
        
            frist.text = NSLocalizedString(@"gif.BuyPro.headerGetVip.ProUpgrade", "");
            sec.text = NSLocalizedString(@"gif.BuyPro.headerGetVipSubTitle.description", "");
            [button setTitle:NSLocalizedString(@"gif.BuyPro.headerGetSuperUser.NOVIP", "") forState:(UIControlStateNormal)];
        }
    }
    return self;
}

- (void)buyPro:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(buyPro)]) {
        
        [self.delegate buyPro];
    }
}

- (void)refruseView
{
    _frist.text = NSLocalizedString(@"gif.BuyPro.headerGetVip.VIP", "");
    _sec.text = NSLocalizedString(@"gif.BuyPro.headerGetVipSubTitle.VIP", "");
    _button.userInteractionEnabled = NO;
    [_button setTitle:NSLocalizedString(@"gif.BuyPro.headerGetSuperUser.VIP", "") forState:(UIControlStateNormal)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _frist.frame = CGRectMake(0, self.height*0.1, self.width, self.height*0.2);
    _sec.frame = CGRectMake(0, CGRectGetMaxY(_frist.frame)+10, self.width, self.height*0.2);
    _button.frame = CGRectMake(self.width*0.15, CGRectGetMaxY(_sec.frame)+20, self.width*0.7, self.height*0.15);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
