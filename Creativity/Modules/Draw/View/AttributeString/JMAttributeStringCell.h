//
//  JMAttributeStringCell.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMAttributeStringContentView;
@interface JMAttributeStringCell : UITableViewCell
@property (nonatomic, weak) UILabel *fontName;
@property (nonatomic, weak) UILabel *fontShow;
@property (nonatomic, weak) JMAttributeStringContentView *contentV;
@end
