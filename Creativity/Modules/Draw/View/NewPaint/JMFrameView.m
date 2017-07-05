//
//  JMFrameView.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMFrameView.h"
#import "NSTimer+JMAddition.h"

@interface JMFrameView()
@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JMFrameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _delayTimer = 0.8;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"JMFrameViewStopTimer" object:nil];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 8, self.height)];
        leftView.backgroundColor = JMBaseColor;
        [self addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.width-20, 0, 8, self.height)];
        rightView.backgroundColor = JMBaseColor;
        [self addSubview:rightView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 5, self.height-2)];
        view.backgroundColor = [UIColor redColor];
        [self addSubview:view];
        self.view = view;
    }
    
    return self;
}

- (void)setDelayTimer:(CGFloat)delayTimer
{
    _delayTimer = delayTimer;
    
    [_timer invalidate];
    _timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_delayTimer*_images.count+0.5 target:self selector:@selector(changeLocation) userInfo:nil repeats:YES];
}

- (void)pauseAnimation
{
    [_timer pause];
}

- (void)restartAnimation
{
    [_timer resume];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    int i = 0;
    CGFloat margin = 20;
    CGFloat w = (self.width-margin*2)/images.count;
    for (UIImage *image in images) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(margin+w*i, 1, w, self.height-2);
        i ++;
    }
}

- (void)changeLocation
{
    [UIView animateWithDuration:_delayTimer*_images.count animations:^{
        
        _view.frame = CGRectMake(self.width-20, 1, 5, self.height-2);
        
    } completion:^(BOOL finished) {
        
        _view.frame = CGRectMake(20, 1, 5, self.height-2);
    }];
    
//    CGFloat x = _delayTimer*(self.width/_images.count);
//    if (x<self.width+5) {
//    
//        [UIView animateWithDuration:_delayTimer*_images.count animations:^{
//         
//            _view.frame = CGRectMake(x-6, 1, 5, self.height-2);
//        }];
//    }else{
//    
//        _delayTimer = _base;
//    }
//    
//    _delayTimer += _base;
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc
{
    NSLog(@"JMFrameView 销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JMFrameViewStopTimer" object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
