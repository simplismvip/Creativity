//
//  JMTabBar.m
//  YaoYao
//
//  Created by JM Zhao on 16/9/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "JMTabBar.h"
#import "NSObject+PYThemeExtension.h"

@implementation JMTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self py_addToThemeColorPool:@"tintColor"];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
//        // view.backgroundColor = JMNavTabBackGround;
//        [[UITabBar appearance] insertSubview:view atIndex:0];
//        self.tintColor = JMColor(90, 200, 93);// [UIColor greenColor];
//        
//        
////        [[UILabel appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor greenColor]];
//        
////        self.backgroundColor = JMTabBackGround;
////        UIImage *bgImg = [[UIImage alloc] init];
////        [self setBackgroundImage:bgImg];
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
