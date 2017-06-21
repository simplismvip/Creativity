//
//  JMFiltersView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMFiltersView.h"
#import "JMFilterItem.h"
#import "JMFilterModel.h"


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
        
        JMFilterModel *model = titles[i];
        JMFilterItem *subView = [[JMFilterItem alloc] init];
        
        UIImage *origin = [UIImage returnImage:i image:[UIImage imageNamed:model.image]];
        UIImage *newimage = [origin imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];

        subView.image = newimage;
        subView.title = model.title;
        subView.tag = 200 + i;
        subView.tinColor = [UIColor whiteColor];
//        if (_tinColor) {subView.tinColor = _tinColor;}
        [subView addTarget:self action:@selector(filterViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:subView];
    }
}

- (void)filterViewAction:(UIButton *)sender
{
    if (self.filter) {self.filter(sender.tag-200);}
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat m = 5;
    CGFloat h = self.bounds.size.height;
    CGFloat w = (self.contentSize.width-(count+1)*m)/count;
    
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
