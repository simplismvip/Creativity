//
//  JMFiltersView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMFiltersView.h"
#import "JMFilterItem.h"
#import "JMFilterModel.h"
#import "UIImage+Filters.h"
#import "SDImageCache.h"

@implementation JMFiltersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    for (int i = 0; i < titles.count; i++) {
        
        JMFilterModel *model = titles[i];
        JMFilterItem *subView = [[JMFilterItem alloc] init];
        
        [[SDImageCache sharedImageCache] diskImageExistsWithKey:model.title completion:^(BOOL isInCache) {
            
            if (isInCache) {
                
                subView.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.title];
            }else{
                
                UIImage *origin = [[UIImage imageNamed:model.image] setFiltersByIndex:i];
                UIImage *newimage = [origin imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
                [[SDImageCache sharedImageCache] storeImage:newimage forKey:model.title completion:^{
                    
                    subView.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.title];
                }];
            }
        }];
        
        subView.title = model.title;
        subView.vip = model.vip;
        subView.tag = 200 + i;
        subView.tinColor = [UIColor whiteColor];
        [subView addTarget:self action:@selector(filterViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:subView];
    }
}

- (void)filterViewAction:(UIButton *)sender
{
    if (self.filter) {
    
        JMFilterModel *model = _titles[sender.tag-200];
        
        BOOL isVip;
        if ([model.vip isEqualToString:@"super-user"]) {
            
            isVip = YES;
        }else{
        
            isVip = NO;
        }
        
        self.filter(sender.tag-200, isVip);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat m = 5;
    CGFloat h = self.bounds.size.height;
    CGFloat w = (self.contentSize.width-(count+1)*m)/count;
    
    int index = 0;
    for (UIView *subView in self.subviews) {
        
        subView.frame = CGRectMake(index*(m+w), 0, w, h);
        index ++;
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
