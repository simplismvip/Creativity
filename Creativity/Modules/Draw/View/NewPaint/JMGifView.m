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

@end
