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
static NSInteger _paintType;
static BOOL _dashType;
static BOOL _fillType;
static NSString *_paintImage;
static NSString *_paintText;

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

// 设置笔画种类
+ (void)setPaintType:(NSInteger)paintType
{
    _paintType = paintType;
}

+ (NSInteger)getPaintType
{
    return _paintType;
}

// 设置填充，
+ (void)setFillType:(BOOL)fillType
{
    _fillType = fillType;
}

+ (BOOL)getFillType
{
    return _fillType;
}

// 虚线
+ (void)setDashType:(BOOL)dashType
{
    _dashType = dashType;
}

+ (BOOL)getDashType
{
    return _dashType;
}

// 设置填充，
+ (void)setPaintImage:(NSString *)paintImage
{
    _paintImage = paintImage;
}

+ (NSString *)getPaintImage
{
    return _paintImage;
}

// 虚线
+ (void)setPaintText:(NSString *)paintText
{
    _paintText = paintText;
}

+ (NSString *)getPaintText
{
    return _paintText;
}

@end
