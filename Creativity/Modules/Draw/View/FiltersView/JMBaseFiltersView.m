//
//  JMBaseFiltersView.m
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMBaseFiltersView.h"
#import "JMFiltersView.h"
#import "JMFilterModel.h"
@interface JMBaseFiltersView ()
@property (nonatomic, weak) JMFiltersView *filter;
@property (nonatomic, weak) UIButton *button;
@end

@implementation JMBaseFiltersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 33
        NSArray *array = @[
                      @{@"title":@"原图", @"image":@"FullSizeRender", @"vip":@"0"},
                      @{@"title":@"LOMO", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"黑白", @"image":@"FullSizeRender", @"vip":@"0"},
                      @{@"title":@"复古", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"哥特", @"image":@"FullSizeRender", @"vip":@"0"},
                      @{@"title":@"锐化", @"image":@"FullSizeRender", @"vip":@"0"},
                      @{@"title":@"淡雅", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"酒红", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"清宁", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"浪漫", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"光晕", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"梦幻", @"image":@"FullSizeRender", @"vip":@"0"},
                      @{@"title":@"夜色", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"清宁", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"浪漫", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"光晕", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"蓝调", @"image":@"FullSizeRender", @"vip":@"0"},
                      @{@"title":@"梦幻", @"image":@"FullSizeRender", @"vip":@"0"},
                      @{@"title":@"夜色", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Noir", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Transfer", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Tonal", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Process", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Mono", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Instant", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Fade", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Chrome", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Alpha", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Posterize", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Invert", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Adjust", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Linear", @"image":@"FullSizeRender", @"vip":@"super-user"},
                      @{@"title":@"Curve", @"image":@"FullSizeRender", @"vip":@"super-user"}
                      ];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            JMFilterModel *model = [[JMFilterModel alloc] init];
            model.title = dic[@"title"];
            model.image = dic[@"image"];
            model.vip = dic[@"vip"];
            [arr addObject:model];
        }
        
        JMFiltersView *filter = [[JMFiltersView alloc] init];
        filter.filter = ^(NSInteger type ,BOOL isVip) {
         
            if ([self.delegate respondsToSelector:@selector(baseFiltersSelectIndex:isVip:)]) {
                
                [self.delegate baseFiltersSelectIndex:type isVip:isVip];
            }
        };
        
        filter.tinColor = [UIColor redColor];
        filter.titles = [arr copy];
        filter.contentSize = CGSizeMake(70*array.count, 65);
        [self addSubview:filter];
        self.filter = filter;
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button addTarget:self action:@selector(remove:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTintColor:[UIColor redColor]];
        [button setImage:[UIImage imageNamed:@"navbar_down_icon_black"] forState:(UIControlStateNormal)];
        
        [self addSubview:button];
        self.button = button;
        
    }
    return self;
}

- (void)remove:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
     
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.bounds.size.width, 90);
        
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(removeSelf)]) {
            
            [self removeFromSuperview];
            [self.delegate removeSelf];
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _filter.frame = CGRectMake(0, 0, self.bounds.size.width, 65);
    _button.frame = CGRectMake(self.bounds.size.width/2-22, CGRectGetMaxY(_filter.frame)+10, 44, 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
