//
//  JMPopView.m
//  Local_Notifacation
//
//  Created by JM Zhao on 2017/5/2.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMPopView.h"
#import "UIColor+Separate.h"

@interface JMPopView ()
@property (nonatomic, weak) UILabel *label;
@end

@implementation JMPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 0.6;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.cornerRadius = 32;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [StaticClass getColor];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        contentLabel.textColor = [[StaticClass getColor] reverseColor];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:contentLabel];
        self.label = contentLabel;
    }
    return self;
}

- (void)animationActive
{
    // 为了不影响缩小后的效果，提前将振动波视图缩小
    [UIView animateWithDuration:0.2 animations:^{
        
        self.transform = CGAffineTransformMakeScale(.5, .5);
        self.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 animations:^{
            
            self.transform = CGAffineTransformMakeScale(5, 5);
            self.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _label.text = content;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.bounds;
}

+ (void)popView:(UIView *)superView title:(NSString *)title
{
    JMPopView *pop = [[JMPopView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    pop.center = superView.center;
    pop.content = title;
    
    [superView addSubview:pop];
    [pop animationActive];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
