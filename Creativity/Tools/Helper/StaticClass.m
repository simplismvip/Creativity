//
//  StaticClass.m
//  Player
//
//  Created by lanouhn on 16/1/26.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "StaticClass.h"

@implementation StaticClass

static NSInteger _num;
static CGFloat _lineWidth;
static CGFloat _alpha;
static CGFloat _fontSize;
static UIColor *_lineColor;
static NSString *_fontName;
static NSInteger _fontType;

+ (void)setNumber:(NSInteger)number{

    _num = number;
}

+ (NSInteger)getNumber{

    return _num;
}

+ (void)setLineWidth:(CGFloat)linewidth
{
    _lineWidth = linewidth;
}
+ (CGFloat)getLineWidth
{    
    return _lineWidth;
}

+ (void)setColor:(UIColor *)color
{
    _lineColor = color;
}

+ (UIColor *)getColor
{
    return _lineColor;
}

+ (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
}
+ (CGFloat)getAlpha
{
    return _alpha;
}

// 设置字体大小
+ (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
}

+ (CGFloat)getFontSize
{
    return _fontSize;
}

// 设置字体名字
+ (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
}

+ (NSString *)getFontName
{
    return _fontName;
}

+ (void)setFontType:(NSInteger)fontType
{
    _fontType = fontType;
}

+ (NSInteger)getFontType
{
    return _fontType;
}

@end
