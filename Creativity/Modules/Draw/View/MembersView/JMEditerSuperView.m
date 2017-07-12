//
//  JMEditerSuperView.m
//  Creativity
//
//  Created by JM Zhao on 2017/7/12.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMEditerSuperView.h"
#import "JMPaintView.h"

@interface JMEditerSuperView()
@property (nonatomic, weak) JMPaintView *imageView;
@end

@implementation JMEditerSuperView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        // 这里点击开始编辑选中页
        JMPaintView *pView = [[JMPaintView alloc] initWithFrame:frame];
        pView.center = self.center;
        pView.drawType = (JMPaintToolType)[StaticClass getPaintType];
        pView.lineDash = [StaticClass getDashType];
        pView.paintText = [StaticClass getPaintText];
        pView.paintImage = [StaticClass getPaintImage];
        [self addSubview:pView];
        self.imageView = pView;
    }
    return self;
}

- (void)setImageRect:(CGRect)imageRect
{
    _imageRect = imageRect;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
    _imageView.frame = _imageRect;
    CGFloat rate = image.size.width/image.size.height;
    [UIView animateWithDuration:0.5 animations:^{
       
        _imageView.frame = CGRectMake(0, 0, self.width, self.width/rate);
        _imageView.center = self.center;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _imageView.frame = _imageRect;
        
    } completion:^(BOOL finished) {
        
        if (self.editerDone) {
            // UIImage *imageNew = [UIImage imageWithCaptureView:_imageView rect:CGRectMake(0, 0, kW, kW)];
            self.editerDone(_imageView.image);
        }
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
