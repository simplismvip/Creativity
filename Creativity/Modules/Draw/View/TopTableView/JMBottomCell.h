//
//  JMBottomCell.h
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBottomCell : UIButton
@property (nonatomic, copy) NSString *indetifiel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isCellSelect;
@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, copy) NSString *cellImage;
@property (nonatomic, strong) UIColor *cellTintColor;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@end
