//
//  StaticClass.h
//  Player
//
//  Created by lanouhn on 16/1/26.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticClass : NSObject

+ (void)setNumber:(NSInteger)number;
+ (NSInteger)getNumber;

+ (void)setLineWidth:(CGFloat)linewidth;
+ (CGFloat)getLineWidth;

+ (void)setColor:(UIColor *)color;
+ (UIColor *)getColor;

+ (void)setAlpha:(CGFloat)alpha;
+ (CGFloat)getAlpha;

// 设置字体
+ (void)setFontSize:(CGFloat)fontSize;
+ (CGFloat)getFontSize;
+ (void)setFontName:(NSString *)fontName;
+ (NSString *)getFontName;
+ (void)setFontType:(NSInteger)fontType;
+ (NSInteger)getFontType;

// 设置笔画种类
+ (void)setPaintType:(NSInteger)paintType;
+ (NSInteger)getPaintType;

// 设置填充，
+ (void)setFillType:(BOOL)fillType;
+ (BOOL)getFillType;

// 虚线
+ (void)setDashType:(BOOL)dashType;
+ (BOOL)getDashType;

// 设置填充，
+ (void)setPaintImage:(NSString *)paintImage;
+ (NSString *)getPaintImage;

// 虚线
+ (void)setPaintText:(NSString *)paintText;
+ (NSString *)getPaintText;

@end
