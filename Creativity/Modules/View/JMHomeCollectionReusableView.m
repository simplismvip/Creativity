//
//  JMHomeCollectionReusableView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMHomeCollectionReusableView.h"

@interface JMHomeCollectionReusableView ()
@property (nonatomic, weak) UIView *view;
@end

@implementation JMHomeCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = JMTabViewBaseColor;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = JMColor(224, 224, 224);
        [self addSubview:view];
        self.view = view;
        
        UILabel *text = [[UILabel alloc] init];
        text.textAlignment = NSTextAlignmentLeft;
        text.font = [UIFont systemFontOfSize:14];
        text.textColor = JMColor(115, 115, 155);
        [self addSubview:text];
        self.text = text;
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.tintColor = JMColor(224, 224, 224);
        [button setImage:[UIImage imageWithTemplateName:@"arrow_carrot-right"] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(headerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        self.headerBtn = button;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _view.frame = CGRectMake(5, 5, 5, self.height-10);
    _text.frame = CGRectMake(15, 0, 120, self.height);
    _headerBtn.frame = CGRectMake(self.width-self.height-5, 0, self.height, self.height);
}

- (void)headerBtnAction:(UIButton *)sender
{
    NSLog(@"开始点击按钮");
}
@end
