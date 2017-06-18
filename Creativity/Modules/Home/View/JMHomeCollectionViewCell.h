//
//  JMHomeCollectionViewCell.h
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMHomeCollectionViewCellDelegate <NSObject>
@optional
- (void)deleteByIndexPath:(NSIndexPath *)indexPath;
- (void)share:(NSIndexPath *)indexPath;
@end

@class JMHomeModel;
@interface JMHomeCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JMHomeModel *model;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, weak) id<JMHomeCollectionViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL inEditState; //是否处于编辑状态
@end
