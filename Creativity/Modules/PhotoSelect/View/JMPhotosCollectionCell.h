//
//  JMPhotosCollectionCell.h
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZAssetModel;
@interface JMPhotosCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *classImage;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) TZAssetModel *model;
@end
