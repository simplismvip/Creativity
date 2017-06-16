//
//  JMFilterSubView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMFilterSubView.h"

@interface JMFilterSubView ()
@property (nonatomic, weak) UIButton *filterBtn;
@property (nonatomic, weak) UILabel *btnTitle;
@end

@implementation JMFilterSubView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIButton *filterBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:filterBtn];
        self.filterBtn = filterBtn;
        
        UILabel *btnTitle = [[UILabel alloc] init];
        btnTitle.textAlignment = NSTextAlignmentCenter;
        btnTitle.font = [UIFont systemFontOfSize:7.0];
        [self addSubview:btnTitle];
        self.btnTitle = btnTitle;
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
    [_filterBtn setImage:image forState:(UIControlStateNormal)];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _btnTitle.text = title;
}

- (void)setTinColor:(UIColor *)tinColor
{
    _tinColor = tinColor;
    _btnTitle.textColor = tinColor;
    _filterBtn.tintColor = tinColor;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _filterBtn.frame = CGRectMake(0, 0, self.width, self.height-10);
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
