//
//  JMAttributeString.h
//  AttributeName-富文本
//
//  Created by JM Zhao on 2017/5/19.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMAttributeString : NSObject
+ (NSDictionary *)attributeString:(NSInteger)type color1:(UIColor *)color1 color2:(UIColor *)color2 fontSize:(CGFloat)size fontName:(NSString *)fontName;
+ (NSMutableArray *)attributeStringColor1:(UIColor *)color1 color2:(UIColor *)color2 fontSize:(CGFloat)size fontName:(NSString *)fontName;
@end
