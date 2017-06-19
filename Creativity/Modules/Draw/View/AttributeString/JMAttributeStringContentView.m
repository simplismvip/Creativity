//
//  JMAttributeStringContentView.m
//  YaoYao
//
//  Created by 赵俊明 on 2017/6/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMAttributeStringContentView.h"
#import "JMAttributeString.h"
#import "NSString+Extension.h"

@implementation JMAttributeStringContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setType:(NSInteger)type
{
    _type = type;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    NSDictionary *dic = [JMAttributeString attributeString:_type color1:JMBaseColor color2:[UIColor whiteColor] fontSize:18 fontName:@"AlNile"];
    NSString *string = @"Creativity -- GIF";
    CGSize size = [string sizeWithFont:[UIFont fontWithName:@"AlNile" size:18.0]];
    
    CGRect rectA = CGRectMake(self.width/2-size.width/2, 10, size.width, size.height);
    [string drawInRect:rectA withAttributes:dic];
}


@end
