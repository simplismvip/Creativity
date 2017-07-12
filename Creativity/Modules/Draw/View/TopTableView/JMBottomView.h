//
//  JMBottomView.h
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMBottomCell;
@class JMBottomView;
@protocol JMBottomViewDataSourceDelegate <NSObject>

@optional
/**
 * 返回多少个cell
 */
- (NSUInteger)numberOfRows;
@required
/**
 * 返回多少列, 用来计算行数
 */
- (NSUInteger)numberOfColumn;
/**
 * 返回cell个数
 */
- (JMBottomCell *)tableView:(JMBottomView *)tableView index:(NSInteger)index;
@end

/**
 * 代理方法
 */
@protocol JMBottomViewDelegate <UIScrollViewDelegate>

@optional
/**
 * 选中cell方法
 */
- (void)tableView:(JMBottomView *)tableView didSelectRowAtIndex:(NSInteger)index;
@end

@interface JMBottomView : UIView

@property (nonatomic, weak) id <JMBottomViewDataSourceDelegate> dataSource;
@property (nonatomic, weak) id <JMBottomViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
- (void)reloadData;
/**
 *  根据标识去缓存池查找可循环利用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (JMBottomCell *)cellByIndex:(NSInteger)index;
@end
