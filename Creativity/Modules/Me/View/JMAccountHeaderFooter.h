//
//  JMAccountHeaderFooter.h
//  YaoYao
//
//  Created by JM Zhao on 2017/3/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMAccountHeaderFooter : UITableViewHeaderFooterView
@property (nonatomic, weak) UILabel *name;
+ (instancetype)headViewWithTableView:(UITableView *)tableView;
@end
