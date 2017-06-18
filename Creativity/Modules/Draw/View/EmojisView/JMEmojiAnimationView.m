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
        coverView.backgroundColor = JMBaseColor;
        coverView.layer.cornerRadius = 10;
        coverView.layer.masksToBounds = YES;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            coverView.frame = CGRectMake(30, 120, kW-60, kW);
            
        } completion:^(BOOL finished) {
            
            [self addsubEmojiViews];
        }];
    }
    return self;
}

- (void)addsubEmojiViews
{
    JMSelectEmojiView *emojiView = [[JMSelectEmojiView alloc] initWithFrame:CGRectMake(10, 10, _coverView.width-20, _coverView.width)];
    emojiView.modelBlock = ^(id model) {
        
        if (self.animationBlock) {
            
            self.animationBlock(model);
        }
    };
    
    [self.coverView insertSubview:emojiView atIndex:0];
    self.emojiView = emojiView;
    
    JMFiltersView *filter = [[JMFiltersView alloc] initWithFrame:CGRectMake(10, _coverView.height-45, _coverView.width-20, 40)];
    filter.tinColor = [UIColor whiteColor];
    filter.titles = @[@{@"title":@"返回", @"image":@"close_icon_black"}, @{@"title":@"表情", @"image":@"emoji"}, @{@"title":@"心形", @"image":@"heart_32"}, @{@"title":@"搞笑", @"image":@"media_32"}, @{@"title":@"添加", @"image":@"moreInput"}];
    filter.contentSize = CGSizeMake(filter.width*0.63, 30);
    filter.filter = ^(NSInteger type) {
        
        NSMutableArray *data = [NSMutableArray array];
        NSArray *emojis;
        if (type == 0) {
            
            [self closeView];
            
        }else if (type == 1) {
            
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
            emojis = [JMHelper readJsonByPath:jsonPath][@"emoji"];
            
        }else if (type == 2) {
            
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"emojis" ofType:@"json"];
            emojis = [JMHelper readJsonByPath:jsonPath][@"emoji"];
        
        
        }else if (type == 3) {
            
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"emoji_03" ofType:@"json"];
            emojis = [JMHelper readJsonByPath:jsonPath][@"handwirte"];
       
        }else if (type == 4) {
            
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"alphaBate" ofType:@"json"];
            emojis = [JMHelper readJsonByPath:jsonPath][@"alphabate"];
        }
        
        for (NSDictionary *dic in emojis) {[data addObject:[JMSubImageModel objectWithDictionary:dic]];}
        [emojiView reloadData:data];
        
    };
    [self.coverView addSubview:filter];
    self.filter = filter;
}

- (void)closeView
{
    [UIView animateWithDuration:0.4 animations:^{
        
        _emojiView.alpha = 0.0;
        _filter.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _coverView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }];
}

/*
 
 {
 "资源":{
 "imageName":["pdf", "epub", "image", "txt"],
 "showName":["Pdf", "Epub", "Photo", "Txt"],
 "color":"0",
 "type":"6"
 }
 },

 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
