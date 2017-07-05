//
//  JMFrameView.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMFrameView.h"
#import "NSTimer+JMAddition.h"
#define kMargin 20

@interface JMFrameView()
@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JMFrameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 8, self.height)];
        leftView.backgroundColor = JMBaseColor;
        [self addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.width-20, 0, 8, self.height)];
        rightView.backgroundColor = JMBaseColor;
        [self addSubview:rightView];
    }
    
    return self;
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    int i = 0;
    CGFloat w = (self.width-kMargin*2)/images.count;
    for (UIImage *image in images) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(kMargin+w*i, 1, w, self.height-2);
        i ++;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = JMBaseColor;
    [self addSubview:view];
    self.view = view;
}

// 更新位置
- (void)refrashLocation:(NSInteger)index
{
    
    [UIView animateWithDuration:0.1 animations:^{
        
        CGFloat w = kMargin*1.5+(self.width-kMargin*2)/_images.count*index;
        _view.frame = CGRectMake(w, 1, 5, self.height-2);
    }];
}

- (void)dealloc
{
    NSLog(@"JMFrameView 销毁");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
