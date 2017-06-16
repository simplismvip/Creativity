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
#import "JMBottomView.h"
#import "JMTopBarModel.h"
#import "JMBottomModel.h"
#import "JMGestureButton.h"
#import "JMHelper.h"

@interface JMTopTableView()<JMBottomViewDataSourceDelegate, JMBottomViewDelegate>
@property (nonatomic, assign) NSInteger section;
@end

@implementation JMTopTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
//        NSArray * fontArrays = [[UIFont familyNames] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            
//            NSString *str1 = (NSString *)obj1;
//            NSString *str2 = (NSString *)obj2;
//            return [str1 compare:str2];
//        }];
//        
//        for(NSString *fontfamilyname in fontArrays)
//        {
//            NSLog(@"family:'%@'",fontfamilyname);
//            
//            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//            {
//                NSLog(@"\tfont:'%@'",fontName);
//            }
//            NSLog(@"-------------");
//        }
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
        btn.backgroundColor = JMTabViewBaseColor;
        [btn setTintColor:JMColor(85, 85, 85)];
        btn.tag = i+baseTag; // JMColor(52, 118, 237)
        [btn addTarget:self action:@selector(topBarAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        i ++;
    }
}

- (void)topBarAction:(UIButton *)sender
{
    self.section = sender.tag-baseTag;
    
    JMGestureButton *gesture = [JMGestureButton creatGestureButton];
    JMBottomView *bottom = [[JMBottomView alloc] initWithFrame:CGRectMake(0, self.superview.height, self.superview.width, 44)];
    [UIView animateWithDuration:0.1 animations:^{bottom.frame = CGRectMake(0, self.superview.height-44, self.superview.width, 44);}];
    bottom.dataSource = self;
    bottom.delegate = self;
    bottom.section = self.section;
    bottom.backgroundColor = JMColor(245, 245, 245);
    [bottom reloadData];
    [gesture addSubview:bottom];
}

#pragma mark -- TopBarDataSourceDelegate
- (NSUInteger)numberOfRows
{
    JMTopBarModel *tModel = self.dataSource[self.section];
    return tModel.models.count;
}

- (NSUInteger)numberOfColumn
{
    JMTopBarModel *tModel = self.dataSource[self.section];
    return tModel.column;
}

// 返回cell
- (JMBottomCell *)tableView:(JMBottomView *)tableView index:(NSInteger)index
{
    JMBottomModel *bModel = [self.dataSource[self.section] models][index];
    JMBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottom"];
    if (!cell) {cell = [[JMBottomCell alloc] init];}
    
    cell.isCellSelect = bModel.isSelect;
    cell.cellImage = bModel.image;
    cell.cellTitle = bModel.title;
    if (bModel.backgroundColor) {
        
        cell.cellTintColor = [JMHelper getColor:bModel.backgroundColor];
    }else{
    
        cell.cellTintColor = JMColor(105, 105, 105);
    }
    
    return cell;
}

#pragma mark -- TopBarDelegate
- (void)tableView:(JMBottomView *)tableView didSelectRowAtIndex:(NSInteger)index
{
    if (self.section != 1) {
        
        [self select:tableView index:index];
    }
    
    if ([self.delegate respondsToSelector:@selector(topTableView:didSelectRowAtIndexPath:)]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:tableView.section];
        [self.delegate topTableView:tableView.section didSelectRowAtIndexPath:indexPath];
    }
}

- (void)select:(JMBottomView *)tableView index:(NSInteger)index
{
    // 1> 先修改模型状态
    NSArray *models = [self.dataSource[self.section] models];
   
    JMBottomModel *bmodel = models[index];
    
    for (JMBottomModel *bModel in models) {
        
        if (bModel == bmodel) {
            
            bModel.isSelect = !bModel.isSelect;
            
        }else{
        
            bModel.isSelect = NO;
        }
    }
    
    // 2> 再修改cell状态
    JMBottomCell *bCell = [tableView cellByIndex:index];
    
    for (JMBottomCell *cell in tableView.subviews) {
        
        if (cell == bCell) {
            
            cell.isCellSelect = !cell.isCellSelect;
            
        }else{
        
            cell.isCellSelect = NO;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat w = self.width/self.dataSource.count;
    for (UIView *view in self.subviews) {
        
        view.frame = CGRectMake(i*w, 1, w, self.height);
        i ++;
    }
}


@end
