//
//  JMTopTableView.m
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMTopTableView.h"
#import "JMBottomCell.h"
#import "UIView+Extension.h"
#import "JMTopBarModel.h"
#import "JMBottomModel.h"
#import "JMGestureButton.h"
#import "JMHelper.h"
#import "Masonry.h"
#import "JMBaseBottomView.h"

@interface JMTopTableView()<JMBaseBottomViewDelegate>
@property (nonatomic, assign) NSInteger section;
@end

@implementation JMTopTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    int i = 0;
    for (JMTopBarModel *model in dataSource) {
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [btn setTitle:model.title forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:model.image] forState:(UIControlStateNormal)];
        btn.backgroundColor = JMColor(33, 33, 33);
        [btn setTintColor:[UIColor whiteColor]];
        btn.tag = i+baseTag;
        [btn addTarget:self action:@selector(topBarAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        i ++;
    }
}

- (void)topBarAction:(UIButton *)sender
{
    self.section = sender.tag-baseTag;
    
    JMTopBarModel *tModel = self.dataSource[_section];
    if (tModel.models.count == 1) {
     
        if ([self.delegate respondsToSelector:@selector(topTableView:didSelectRowAtIndexPath:)]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.section];
            [self.delegate topTableView:self.section didSelectRowAtIndexPath:indexPath];
        }
        
    }else{
    
        JMGestureButton *gesture = [JMGestureButton creatGestureButton];
        JMBaseBottomView *bsae = [[JMBaseBottomView alloc] initWithCount:tModel.models];
        bsae.delegate = self;
        [gesture addSubview:bsae];
    }
}

- (void)didSelectRowAtIndexPath:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(topTableView:didSelectRowAtIndexPath:)]) {
        
        JMGestureButton *ges = [JMGestureButton getGestureButton];
        [ges removeFromSuperview];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:self.section];
        [self.delegate topTableView:self.section didSelectRowAtIndexPath:indexPath];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat w = self.width/self.dataSource.count;
    for (UIView *view in self.subviews) {
        
        view.frame = CGRectMake(i*w, 0, w, self.height);
        i ++;
    }
}


@end
