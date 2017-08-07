//
//  JMEmojiAnimationView.m
//  YaoYao
//
//  Created by 赵俊明 on 2017/5/4.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMEmojiAnimationView.h"
#import "JMSelectEmojiView.h"
#import "JMFiltersView.h"
#import "JMSubImageModel.h"
#import "NSObject+JMProperty.h"

@interface JMEmojiAnimationView ()
@property (nonatomic, weak) JMFiltersView *filter;
@property (nonatomic, weak) JMSelectEmojiView *emojiView;
@end

@implementation JMEmojiAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8];
        
        //
        UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(20, 64, 40, 40)];
        close.tintColor = JMBaseColor;
        [close setImage:[UIImage imageWithTemplateName:@"navbar_close_icon_black"] forState:(UIControlStateNormal)];
        [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close];
    
        JMSelectEmojiView *emojiView = [[JMSelectEmojiView alloc] initWithFrame:CGRectMake(20, 120, kW-40, kH*0.6)];
        emojiView.modelBlock = ^(id model) {if (self.animationBlock) {self.animationBlock(model);}};
        [self addSubview:emojiView];
        self.emojiView = emojiView;

    }
    return self;
}

- (void)closeView:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _emojiView.alpha = 0.0;
        sender.transform = CGAffineTransformMakeRotation(M_PI);
        sender.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
