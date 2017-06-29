//
//  JMFrameView.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMFrameView.h"

@interface JMFrameView()
@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat base;
@end

@implementation JMFrameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delayTimer = 0.8;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"JMFrameViewStopTimer" object:nil];
    }
    return self;
}

- (void)setDelayTimer:(CGFloat)delayTimer
{
    _delayTimer = delayTimer;
    _base = _delayTimer;
    
    [_timer invalidate];
    _timer = nil;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_delayTimer target:self selector:@selector(changeLocation) userInfo:nil repeats:YES];
    
    NSLog(@"%f", delayTimer);
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    int i = 0;
    CGFloat w = (self.width/images.count);
    
    for (UIImage *image in images) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(w*i, 1, w, self.height-2);
        i ++;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 5, self.height-2)];
    view.backgroundColor = [UIColor redColor];
    [self addSubview:view];
    self.view = view;
}

- (void)changeLocation
{
    CGFloat x = _delayTimer*(self.width/_images.count);
    
    if (x<self.width+5) {
    
        _view.frame = CGRectMake(x, 1, 5, self.height-2);
    }else{
    
        _delayTimer = _base;
    }
    
    _delayTimer += _base;
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
