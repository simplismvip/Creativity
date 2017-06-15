//
//  JMCreatPaintView.m
//  DateDemo
//
//  Created by JM Zhao on 2017/6/14.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMCreatPaintView.h"
#import "UIView+Extension.h"

@interface JMCreatPaintView ()
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *addAction;
@end

@implementation JMCreatPaintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width-44, self.height)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIButton *addF = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [addF setImage:[UIImage imageNamed:@"newImage"] forState:(UIControlStateNormal)];
        [addF addTarget:self action:@selector(addItem:) forControlEvents:(UIControlEventTouchUpInside)];
        addF.frame = CGRectMake(0, 0, 44, self.height);
        [scrollView addSubview:addF];
        
        UIButton *add = [UIButton buttonWithType:(UIButtonTypeSystem)];
        add.backgroundColor = JMRandomColor;
        [add addTarget:self action:@selector(addTarget:) forControlEvents:(UIControlEventTouchUpInside)];
        add.frame = CGRectMake(44, 0, 44, self.height);
        [add setImage:[[UIImage imageNamed:@"navbar_plus_icon_black"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        [self addSubview:add];
        self.addAction = add;
    }
    return self;
}

- (void)reloadData:(UIImage *)newImage
{
    CGFloat margin = 5;
    UIButton *add = [UIButton buttonWithType:(UIButtonTypeSystem)];
    add.frame = CGRectMake((44+margin)*_scrollView.subviews.count, 0, 44, self.height);
    [add setImage:newImage forState:(UIControlStateNormal)];
    add.tag = self.scrollView.subviews.count;
    [add addTarget:self action:@selector(addItem:) forControlEvents:(UIControlEventTouchUpInside)];
    [_scrollView addSubview:add];
    
    NSInteger number = _scrollView.subviews.count;
    _scrollView.contentSize = CGSizeMake((44+margin)*number, 0);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat x = CGRectGetMaxX(_addAction.frame)+44 < self.width ? (44+margin)*number : self.width-44.0;
        _addAction.frame = CGRectMake(x, 0, 44, self.height);
    }];
    
    for (UIButton *btn in _scrollView.subviews) {

        NSLog(@"%@--%@--%f", btn, btn.backgroundColor, _scrollView.alpha);
    }
}

- (void)addItem:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(touchItem:)]) {
        
        [self.delegate touchItem:sender.tag];
    }
}

- (void)addTarget:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(newCallback)]) {
        
        [self.delegate newCallback];
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
