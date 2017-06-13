//
//  JMHomeCollectionViewFlowLayout.h
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMHomeCollectionViewFlowLayoutDelegate <NSObject>

/**
 * 改变编辑状态
 */
- (void)didChangeEditState:(BOOL)inEditState;

/**
 * 更新数据源
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;

@end

@interface JMHomeCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, assign) id<JMHomeCollectionViewFlowLayoutDelegate> delegate;
@end

