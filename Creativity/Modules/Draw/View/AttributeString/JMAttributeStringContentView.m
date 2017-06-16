//
//  JMAttributeStringContentView.m
//  YaoYao
//
//  Created by 赵俊明 on 2017/6/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMAttributeStringContentView.h"
#import "JMAttributeString.h"

@implementation JMAttributeStringContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setType:(NSInteger)type
{
    _type = type;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    NSDictionary *dic = [JMAttributeString attributeString:_type color1:[UIColor redColor] color2:[UIColor blackColor] fontSize:18 fontName:@"AlNile"];
    NSString *string = @"展示使用：      YaoYao";
    CGRect rectA = CGRectMake(30, 10, self.width-20, self.width-20);
    [string drawInRect:rectA withAttributes:dic];
}


@end
