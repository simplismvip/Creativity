//
//  JMEditerCollectionViewCell.h
//  Creativity
//
//  Created by 赵俊明 on 2017/7/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMEditerCollectionViewCellDelegate <NSObject>
- (void)deleteByIndexPath:(NSIndexPath *)indexPath;
@end

@interface JMEditerCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, weak) id<JMEditerCollectionViewCellDelegate> delegate;
@end
