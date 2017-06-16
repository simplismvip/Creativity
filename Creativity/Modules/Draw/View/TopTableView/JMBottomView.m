//
//  JMBottomView.m
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMBottomView.h"
#import "UIView+Extension.h"
#import "JMBottomCell.h"

@interface JMBottomView()
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger btnNumbers;

@property (nonatomic, strong) NSMutableArray *frameArr;
@property (nonatomic, strong) NSMutableDictionary *reuserCell;
@property (nonatomic, strong) NSMutableSet *dequeSet;

@end

@implementation JMBottomView

- (NSMutableArray *)frameArr
{
    if (_frameArr == nil) {
        self.frameArr = [NSMutableArray array];
    }
    return _frameArr;
}

- (NSMutableDictionary *)reuserCell
{
    if (_reuserCell == nil) {
        self.reuserCell = [NSMutableDictionary dictionary];
    }
    return _reuserCell;
}


- (NSMutableSet *)dequeSet
{
    if (_dequeSet == nil) {
        self.dequeSet = [NSMutableSet set];
    }
    return _dequeSet;
}

/*
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
    NSLog(@"加载数据");
}
 */

- (void)reloadData
{
    [self.frameArr removeAllObjects];
    
    // 每个分区cell个数
    NSUInteger numberOfCell = [self.dataSource numberOfRows];
    
    // cell列数
    NSInteger cellRow = [self.dataSource numberOfColumn];
    
    // cell行数, 这里有个小小注意点, 这里需要进位
    NSInteger cellColumn = numberOfCell/cellRow;
    
    CGFloat h = 34.0;
    CGFloat e = 5.0;
    CGFloat w = (kW-(cellColumn+1)*e)/cellColumn;
    
    for (int i = 0; i< cellRow; i++) {
        
        for (int j = 0; j < cellColumn; j ++) {
            
            // 计算每个分区下cell的frame
            CGRect cellFrame = CGRectMake((w+e)*j+e, e+i*(h+e), w, h);
            [self.frameArr addObject:[NSValue valueWithCGRect:cellFrame]];
        }
    }
}

/**
 * 重用cell标识
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block JMBottomCell *reuseCell = nil;
    
    // 从集合中遍历除cell
    [self.dequeSet enumerateObjectsUsingBlock:^(JMBottomCell *cell, BOOL * _Nonnull stop) {
        
        // 如果重用标识相等, 从缓冲池中取出
        if ([cell.indetifiel isEqualToString:identifier]) {
            
            reuseCell = cell;
            *stop = YES;
        }
    }];
    
    // 如果已经从缓存池中取出就可以删除
    if (reuseCell) {
        [self.dequeSet removeObject:reuseCell];
    }
    return reuseCell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 向数据源所要对应位置的cell
    NSUInteger numberOfCells = self.frameArr.count;
    for (int i = 0; i < numberOfCells; i ++) {
        
        // 首先取出frame
        CGRect cellFrame = [self.frameArr[i] CGRectValue];
        
        // 从字典中取出cell
        JMBottomCell *cell = self.reuserCell[@(i)];
        
        if (cell == nil) {
            
            cell = [self.dataSource tableView:self index:i];
            [cell addTarget:self action:@selector(select:) forControlEvents:(UIControlEventTouchUpInside)];
            cell.frame = cellFrame;
            [self addSubview:cell];
            
            // 添加cell到字典中
            self.reuserCell[@(i)] = cell;
        }else{
            // 从scrollView上和字典中移除
            [cell removeFromSuperview];
            [self.reuserCell removeObjectForKey:@(i)];
            
            // 放进缓存池
            [self.dequeSet addObject:cell];
        }
        cell.tag = i+baseTag;
    }
}

- (void)select:(JMBottomCell *)selectCell
{
    [self.delegate tableView:self didSelectRowAtIndex:selectCell.tag-baseTag];
}

- (JMBottomCell *)cellByIndex:(NSInteger)index
{
    if (self.subviews.count>index) {
        
        return self.subviews[index];
    }
    
    return nil;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
