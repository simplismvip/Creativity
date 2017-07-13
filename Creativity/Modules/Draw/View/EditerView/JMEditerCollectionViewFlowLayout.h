//
//  JMEditerCollectionViewFlowLayout.h
//  Creativity
//
//  Created by 赵俊明 on 2017/7/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JMEditerCollectionViewFlowLayoutDelegate <NSObject>

@optional
/**
 * 改变编辑状态
 */
- (void)didChangeEditState:(BOOL)inEditState;

/**
 * 更新数据源
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;

@end

@interface JMEditerCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, assign) id<JMEditerCollectionViewFlowLayoutDelegate> delegate;
@end
