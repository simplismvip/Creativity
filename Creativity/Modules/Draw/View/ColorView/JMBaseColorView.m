//
//  JMBaseColorView.m
//  YaoYao
//
//  Created by 赵俊明 on 2017/6/6.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMBaseColorView.h"

@implementation JMBaseColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *colors = @[[UIColor blackColor], [UIColor whiteColor], [UIColor redColor], [UIColor grayColor], [UIColor cyanColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor], [UIColor darkGrayColor]];
        
        for (UIColor *color in colors) {
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            button.backgroundColor = color;
            button.layer.cornerRadius = 14;
            button.layer.borderWidth = 1;
            button.layer.borderColor = JMTabViewBaseColor.CGColor;
            [self addSubview:button];
            [button addTarget:self action:@selector(chouseColor:) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    return self;
}

- (void)chouseColor:(UIButton *)sender
{
    if (self.colorBlock) {self.colorBlock(sender.backgroundColor);}
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat margin = 5.0;
    CGFloat width = (self.width - margin*(self.subviews.count+1))/self.subviews.count;
    
    for (UIView *view in self.subviews) {
        
        view.frame = CGRectMake(margin + (margin + width) * i, 2, width, self.height-4);
        i ++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
