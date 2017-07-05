//
//  JMGIFAnimationView.m
//  Creativity
//
//  Created by JM Zhao on 2017/7/5.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMGIFAnimationView.h"
#import "NSTimer+JMAddition.h"

@interface JMGIFAnimationView ()
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation JMGIFAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.index = 0;
        
        UIImageView *imageview = [[UIImageView alloc] init];
        [self addSubview:imageview];
        self.imageView = imageview;
    }
    return self;
}

- (void)setDelayer:(CGFloat)delayer
{
    _delayer = delayer;
    [_timer invalidate];
    _timer = nil;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:delayer target:self selector:@selector(animationStart) userInfo:nil repeats:YES];
//    [_timer pause];
}

- (void)animationStart
{
    if (_index < self.imageSource.count) {
    
        if (self.frameChange) {self.frameChange(_index);}
        _imageView.image = self.imageSource[_index];
        _index += 1;
    }else{
        _index = 0;
    }
}

- (void)startAnimation:(NSTimeInterval)timeInterval
{
    [_timer resumeWithTimeInterval:timeInterval];
}

- (void)pauseAnimation
{
    [_timer pause];
}

- (void)restartAnimation
{
    [_timer resume];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
