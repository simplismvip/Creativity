//
//  JMGifView.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMGifView.h"

@implementation JMGifView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGFloat rate = _image.size.width/_image.size.height;
    CGFloat w = kW;
    CGFloat h = kW;
    
    CGSize imageSize;
    if (rate>1) {
        
        // w > h
        imageSize = CGSizeMake(w, w/rate);
        
    }else if (rate<1){
        
        // w < h
        imageSize = CGSizeMake(w*rate, w);
        
    }else{
        // w == h
        imageSize = CGSizeMake(w, w);
    }
    
    CGRect imageRect = CGRectMake(w/2-imageSize.width/2, h/2-imageSize.height/2, imageSize.width, imageSize.height);
    
    
    
    [_image drawInRect:imageRect];
}

-(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
