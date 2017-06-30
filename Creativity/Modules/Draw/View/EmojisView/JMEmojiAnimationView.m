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
@property (nonatomic, weak) UIView *coverView;
@end

@implementation JMEmojiAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(kW/2, 80, 0, kH-160)];
        coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        coverView.layer.cornerRadius = 10;
        coverView.layer.masksToBounds = YES;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        //
        UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        close.tintColor = JMBaseColor;
        [close setImage:[UIImage imageWithTemplateName:@"navbar_close_icon_black"] forState:(UIControlStateNormal)];
        [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            coverView.frame = CGRectMake(kW*0.1, 120, kW*0.8, kH*0.6);
            
        } completion:^(BOOL finished) {
            
            [coverView addSubview:close];
            [self addsubEmojiViews];
        }];
    }
    return self;
}

- (void)addsubEmojiViews
{
    JMSelectEmojiView *emojiView = [[JMSelectEmojiView alloc] initWithFrame:CGRectMake(10, 0, _coverView.width-20, _coverView.height)];
    emojiView.modelBlock = ^(id model) {if (self.animationBlock) {self.animationBlock(model);}};
    [self.coverView insertSubview:emojiView atIndex:0];
    self.emojiView = emojiView;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
    NSArray *emojis = [JMHelper readJsonByPath:jsonPath][@"emoji"];
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *dic in emojis) {[data addObject:[JMSubImageModel objectWithDictionary:dic]];}
    [emojiView reloadData:data];
}

- (void)closeView:(UIButton *)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        
        _emojiView.alpha = 0.0;
        sender.transform = CGAffineTransformMakeRotation(M_PI);
        sender.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _coverView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
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
