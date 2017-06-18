//
//  JMBottomCell.m
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMBottomCell.h"
#import "UIImage+JMImage.h"

@implementation JMBottomCell

- (id)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:7.0];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *0.75;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * 0.65;
    return CGRectMake(0, 0, imageW, imageH);
}

- (void)setIsCellSelect:(BOOL)isCellSelect
{
    _isCellSelect = isCellSelect;
    
    self.backgroundColor = JMColor(33, 33, 33);
    
//    if (isCellSelect) {
//        
//        self.backgroundColor = JMColor(205, 205, 205);
//    
//    }else{
//     
//        self.backgroundColor = JMColor(33, 33, 33);
//    }
}

- (void)setCellImage:(NSString *)cellImage
{
    _cellImage = cellImage;
    [self setImage:[UIImage imageWithTemplateName:cellImage] forState:0];
}

- (void)setCellTitle:(NSString *)cellTitle
{
    _cellTitle = cellTitle;
    [self setTitle:cellTitle forState:0];
}

- (void)setCellTintColor:(UIColor *)cellTintColor
{
    _cellTintColor = cellTintColor;
    [self setTitleColor:[UIColor whiteColor] forState:0];
    [self setTintColor:JMColor(217, 51, 58)];
}

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor
{
    _cellBackgroundColor = cellBackgroundColor;
    self.backgroundColor = cellBackgroundColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
