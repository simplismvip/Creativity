//
//  JMSlider.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/26.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMSlider.h"

@interface JMSlider()
@end

@implementation JMSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 左右轨的图片
        UISlider *sliderA=[[UISlider alloc] init];
        sliderA.backgroundColor = [UIColor clearColor];
        sliderA.value=0.0f;
        sliderA.minimumValue=0.0f;
        sliderA.maximumValue=1.0f;
        
        [sliderA setMinimumTrackImage:[UIImage imageNamed:@"prgbar_unread"] forState:UIControlStateNormal];
        [sliderA setMaximumTrackImage:[UIImage imageNamed:@"prgbar_read"] forState:UIControlStateNormal];
        [sliderA setThumbImage:[UIImage imageNamed:@"prgbar_icon"] forState:UIControlStateHighlighted];
        [sliderA setThumbImage:[UIImage imageNamed:@"prgbar_icon"] forState:UIControlStateNormal];
        
        // 滑块拖动时的事件
        [sliderA addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [sliderA addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:sliderA];
        self.slider = sliderA;
        
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:9.0];
        title.hidden = YES;
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = JMColor(160, 160, 160);
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        self.title = title;
    }
    return self;
}

- (void)sliderDragUp:(UISlider *)slider
{
    _title.hidden = YES;
}

- (void)sliderValueChanged:(UISlider *)slider
{
    _title.hidden = NO;
    _title.center = CGPointMake(self.width*slider.value, 0);
    _title.text = [NSString stringWithFormat:@"%.2f", slider.value];
    _sValue = slider.value;
    self.value(self);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _slider.frame = CGRectMake(0, self.bounds.size.height*0.4, self.bounds.size.width, 10);
    _title.frame = CGRectMake(0, CGRectGetMinY(self.slider.frame)-15, 28, 15);
}

- (void)setSValue:(CGFloat)sValue
{
    _sValue = sValue;
    
    if (sValue > 1) {
    
        _slider.value = sValue/20.0;
        
    }else{
    
        _slider.value = sValue;
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
