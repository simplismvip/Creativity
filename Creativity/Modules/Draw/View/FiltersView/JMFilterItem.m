//
//  JMFilterItem.m
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMFilterItem.h"

@interface JMFilterItem ()
@property (nonatomic, weak) UIButton *filterBtn;
@property (nonatomic, weak) UILabel *btnTitle;
@property (nonatomic, weak) UIImageView *vipView;
@end

@implementation JMFilterItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        UIButton *filterBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:filterBtn];
        self.filterBtn = filterBtn;
        
        UILabel *btnTitle = [[UILabel alloc] init];
        btnTitle.textAlignment = NSTextAlignmentCenter;
        btnTitle.font = [UIFont systemFontOfSize:7.0];
        [self addSubview:btnTitle];
        self.btnTitle = btnTitle;
        
        if (![JMBuyHelper isVip]) {
            
            UIImageView *vip = [[UIImageView alloc] init];
            vip.hidden = YES;
            [self addSubview:vip];
            self.vipView = vip;
        }

    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.filterBtn.tag = self.tag;
    [self.filterBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [_filterBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _btnTitle.text = title;
}

- (void)setVip:(NSString *)vip
{
    _vip = vip;
    _vipView.image = [UIImage imageWithRenderingName:vip];
    _vipView.hidden = NO;
}

- (void)setTinColor:(UIColor *)tinColor
{
    _tinColor = tinColor;
    _btnTitle.textColor = tinColor;
//    _filterBtn.tintColor = tinColor;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _vipView.frame = CGRectMake(self.width-13, 3, 10, 10);
    _filterBtn.frame = CGRectMake(0, 0, self.width, self.height-12);
    _btnTitle.frame = CGRectMake(0, CGRectGetMaxY(_filterBtn.frame), self.width, 10);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
