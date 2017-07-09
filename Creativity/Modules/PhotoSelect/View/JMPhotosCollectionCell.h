//
//  JMPhotosCollectionCell.h
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMPhotosModel;
@interface JMPhotosCollectionCell : UICollectionViewCell
- (void)selec:(BOOL)isSelect Index:(NSInteger)index;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) JMPhotosModel *model;
@end
