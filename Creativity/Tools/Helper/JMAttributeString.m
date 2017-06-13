//
//  JMAttributeString.m
//  AttributeName-富文本
//
//  Created by JM Zhao on 2017/5/19.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMAttributeString.h"
#import "StaticClass.h"

@implementation JMAttributeString

+ (NSDictionary *)attributeString:(NSInteger)type color1:(UIColor *)color1 color2:(UIColor *)color2 fontSize:(CGFloat)size fontName:(NSString *)fontName
{
    NSParagraphStyle *paragraph = [NSParagraphStyle defaultParagraphStyle];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowColor = [UIColor blueColor];
    shadow.shadowOffset = CGSizeMake(1, 3);
    
    NSDictionary *dic;
    
    switch (type) {
        case 0:
            
            dic = @{
                    NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                    NSForegroundColorAttributeName:color1
                    };
            
            break;
            
        case 1:
            
            dic = @{
                      NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                      NSForegroundColorAttributeName:color1,
                      NSParagraphStyleAttributeName:paragraph,
                      NSStrokeWidthAttributeName:@(-3),
                      NSStrokeColorAttributeName:color2
                      };
            break;
            
        case 2:
            
            dic = @{
                      NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                      NSForegroundColorAttributeName:color1,
                      NSParagraphStyleAttributeName:paragraph,
                      NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                      };
            break;
            
        case 3:
            
            dic = @{
                      NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                      NSForegroundColorAttributeName:color1,
                      NSParagraphStyleAttributeName:paragraph,
                      NSShadowAttributeName:shadow,
                      NSVerticalGlyphFormAttributeName:@(0)
                      };
            break;
            
        case 4:
            
            dic = @{
                      NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                      NSForegroundColorAttributeName:color1,
                      NSParagraphStyleAttributeName:paragraph,
                      NSShadowAttributeName:shadow,
                      NSVerticalGlyphFormAttributeName:@(0),
                      NSObliquenessAttributeName:@1
                      };
            break;
            
        case 5:
            
            dic = @{
                    NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                    NSForegroundColorAttributeName:color1,
                    NSParagraphStyleAttributeName:paragraph,
                    NSStrokeWidthAttributeName:@3,
                    NSStrokeColorAttributeName:color2
                    };            
            break;

        case 6:
            
            dic = @{
                    NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                    NSForegroundColorAttributeName:color1,
                    NSParagraphStyleAttributeName:paragraph,
                    NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)
                    };
            break;
            
        default:
            break;
    }
    
    return dic;
}

+ (NSMutableArray *)attributeStringColor1:(UIColor *)color1 color2:(UIColor *)color2 fontSize:(CGFloat)size fontName:(NSString *)fontName
{
    NSParagraphStyle *paragraph = [NSParagraphStyle defaultParagraphStyle];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowColor = [UIColor blueColor];
    shadow.shadowOffset = CGSizeMake(1, 3);
    NSMutableArray *fonts = [NSMutableArray array];
    
    NSDictionary *dic0 = @{
            NSFontAttributeName:[UIFont systemFontOfSize:14],
            NSForegroundColorAttributeName:color1
            };
    
    NSDictionary *dic = @{
                          
              NSFontAttributeName:[UIFont fontWithName:fontName size:size],
              NSParagraphStyleAttributeName:paragraph,
              NSForegroundColorAttributeName:color1,
              NSStrokeWidthAttributeName:@3,
              NSStrokeColorAttributeName:color2
              };
    
    NSDictionary *dic1 = @{
                          
            NSFontAttributeName:[UIFont fontWithName:fontName size:size],
            NSParagraphStyleAttributeName:paragraph,
            NSForegroundColorAttributeName:color1,
            NSStrokeWidthAttributeName:@(-3),
            NSStrokeColorAttributeName:color2
            };
    
    
    NSDictionary *dic2 = @{
                           
            NSFontAttributeName:[UIFont fontWithName:fontName size:size],
            NSParagraphStyleAttributeName:paragraph,
            NSForegroundColorAttributeName:color1,
            NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
            };
    
    NSDictionary *dic3 = @{
                           
            NSFontAttributeName:[UIFont fontWithName:fontName size:size],
            NSParagraphStyleAttributeName:paragraph,
            NSForegroundColorAttributeName:color1,
            NSShadowAttributeName:shadow,
            NSVerticalGlyphFormAttributeName:@(0)
            };
    
    NSDictionary *dic4 = @{
                           
            NSFontAttributeName:[UIFont fontWithName:fontName size:size],
            NSParagraphStyleAttributeName:paragraph,
            NSForegroundColorAttributeName:color1,
            NSShadowAttributeName:shadow,
            NSVerticalGlyphFormAttributeName:@(0),
            NSObliquenessAttributeName:@1
            };

    NSDictionary *dic5 = @{
                           
                           NSFontAttributeName:[UIFont fontWithName:fontName size:size],
                           NSParagraphStyleAttributeName:paragraph,
                           NSForegroundColorAttributeName:color1,
                           NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)
                           };
    
    [fonts addObject:dic0];
    [fonts addObject:dic];
    [fonts addObject:dic1];
    [fonts addObject:dic2];
    [fonts addObject:dic3];
    [fonts addObject:dic4];
    [fonts addObject:dic5];
    
    return fonts;
}


@end
