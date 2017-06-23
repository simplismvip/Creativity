//
//  JMGetGIFBottomView.m
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMGetGIFBottomView.h"
#import "JMBaseFiltersView.h"
#import "JMSlider.h"

@interface JMGetGIFBottomView()<JMBaseFiltersViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation JMGetGIFBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = JMColor(33, 33, 33);
        
        UISlider *sliderA = [[UISlider alloc] init];
        [sliderA setMinimumTrackImage:[[UIImage imageNamed:@"prgbar_unread"] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [sliderA setMaximumTrackImage:[[UIImage imageNamed:@"prgbar_read"] imageWithColor:JMBaseColor] forState:UIControlStateNormal];
        [sliderA setThumbImage:[[UIImage imageNamed:@"prgbar_icon"] imageWithColor:JMBaseColor] forState:UIControlStateHighlighted];
        [sliderA setThumbImage:[[UIImage imageNamed:@"prgbar_icon"] imageWithColor:JMBaseColor] forState:UIControlStateNormal];
        [sliderA addTarget:self action:@selector(changerValues:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sliderA];
        self.sliderA = sliderA;
        
    }
    return self;
}

- (void)setSubViews:(NSArray *)subViews
{
    _subViews = subViews;
    
    int i = 0;
    for (NSString *icon in subViews) {
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [btn setImage:[UIImage imageNamed:icon] forState:(UIControlStateNormal)];
        [btn setTintColor:JMBaseColor];
        btn.tag = i+200;
        [btn addTarget:self action:@selector(select:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        i ++;
    }
}

- (void)changerValues:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(changeValue:)]) {
        
        [self.delegate changeValue:(1.0f - (slider.value*1.0+0.1))];
    }
}

#pragma mark -- JMBaseFiltersViewDelegate 回调
- (void)baseFiltersSelectIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        
        [self.delegate didSelectRowAtIndexPath:index];
    }
}

- (void)removeSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, kH-74, self.width, 74);
    }];
}

// 弹出子菜单
- (void)select:(UIButton *)selectCell
{
    if (selectCell.tag == 200) {
        
        JMBaseFiltersView *filter = [[JMBaseFiltersView alloc] initWithFrame:CGRectMake(0, kH, self.width, 100)];
        filter.delegate = self;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.frame = CGRectMake(0, kH, self.width, 74);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                filter.frame = CGRectMake(0, kH-100, self.width, 100);
            }];
        }];
        
        [self.superview addSubview:filter];
        
    }else{
    
        if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
            
            [self.delegate didSelectRowAtIndexPath:selectCell.tag - 200];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width/(self.subviews.count-1);
    int i = 0;
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            view.frame = CGRectMake(i*w, 30, w, self.bounds.size.height-30);
            i ++;
            
        }else if ([view isKindOfClass:[UIView class]]){
            
            view.frame = CGRectMake(30, 0, self.bounds.size.width-60, 30);
        }
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
