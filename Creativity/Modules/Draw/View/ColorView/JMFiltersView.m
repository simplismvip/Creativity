//
//  JMFiltersView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMFiltersView.h"
#import "JMFilterSubView.h"

@implementation JMFiltersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    for (int i = 0; i < titles.count; i++) {
        
        NSDictionary *dic = titles[i];
        
        JMFilterSubView *subView = [[JMFilterSubView alloc] init];
        subView.backgroundColor = [UIColor clearColor];
        subView.image = [UIImage imageNamed:dic[@"image"]];
        subView.title = dic[@"title"];
        subView.tag = baseTag + i;
        if (_tinColor) {subView.tinColor = _tinColor;}
        [subView addTarget:self action:@selector(filterViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:subView];
    }
    
}

- (void)filterViewAction:(UIButton *)sender
{
    if (self.filter) {
        
        self.filter(sender.tag - baseTag); 
    }
    
    JMLog(@"%ld", sender.tag - baseTag);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat m = 5;
    CGFloat h = self.height;
    CGFloat w = (self.contentSize.width - (count+1)*m)/count;
    
    int index = 0;
    for (UIView *subView in self.subviews) {
        
        subView.frame = CGRectMake(index*(m+w), 0, w, h);
        index ++;
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
