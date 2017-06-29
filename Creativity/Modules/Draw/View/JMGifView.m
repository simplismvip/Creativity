//
//  JMGifView.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMGifView.h"

@implementation JMGifView

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGFloat rate = _image.size.width/_image.size.height;
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    UIImage *imageNew;
    if (rate>1) {
        
        // w > h
        imageNew = [_image compressOriginalImage:_image toSize:CGSizeMake(w, w/rate)];
        
    }else if (rate<1){
        
        // w < h
        imageNew = [_image compressOriginalImage:_image toSize:CGSizeMake(w*rate, w)];
        
    }else{
        // w == h
        imageNew = [_image compressOriginalImage:_image toSize:CGSizeMake(w, w)];
    }
    
    CGRect imageRect = CGRectMake(w/2-imageNew.size.width/2, h/2-imageNew.size.height/2, imageNew.size.width, imageNew.size.height);
    [imageNew drawInRect:imageRect];
}

@end
