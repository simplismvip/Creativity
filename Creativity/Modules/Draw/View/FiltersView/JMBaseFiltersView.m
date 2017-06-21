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
        
        NSArray *array = @[
                      @{@"title":@"原图", @"image":@"FullSizeRender"},
                      @{@"title":@"LOMO", @"image":@"FullSizeRender"},
                      @{@"title":@"黑白", @"image":@"FullSizeRender"},
                      @{@"title":@"复古", @"image":@"FullSizeRender"},
                      @{@"title":@"哥特", @"image":@"FullSizeRender"},
                      @{@"title":@"锐化", @"image":@"FullSizeRender"},
                      @{@"title":@"淡雅", @"image":@"FullSizeRender"},
                      @{@"title":@"酒红", @"image":@"FullSizeRender"},
                      @{@"title":@"清宁", @"image":@"FullSizeRender"},
                      @{@"title":@"浪漫", @"image":@"FullSizeRender"},
                      @{@"title":@"光晕", @"image":@"FullSizeRender"},
                      @{@"title":@"蓝调", @"image":@"FullSizeRender"},
                      @{@"title":@"梦幻", @"image":@"FullSizeRender"},
                      @{@"title":@"夜色", @"image":@"FullSizeRender"}
                      ];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            JMFilterModel *model = [[JMFilterModel alloc] init];
            model.title = dic[@"title"];
            model.image = dic[@"image"];
            [arr addObject:model];
        }
        
        JMFiltersView *filter = [[JMFiltersView alloc] init];
        filter.filter = ^(NSInteger type) {
         
            if ([self.delegate respondsToSelector:@selector(baseFiltersSelectIndex:)]) {
                
                [self.delegate baseFiltersSelectIndex:type];
            }
        };
        
        filter.tinColor = [UIColor redColor];
        filter.titles = [arr copy];
        filter.contentSize = CGSizeMake(70*12, 65);
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
