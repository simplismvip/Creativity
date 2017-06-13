//
//  SetTableViewCell.h
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetModel;
@interface SetTableViewCell : UITableViewCell
+ (instancetype)setCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath model:(SetModel *)model;
@end
