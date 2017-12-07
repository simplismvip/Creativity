//
//  JMHeaderFooterView.h
//  ebookReader
//
//  Created by JM Zhao on 2017/9/30.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMHeaderFooterModel;
@interface JMHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) JMHeaderFooterModel *model;
+ (instancetype)initHeaderFooterWithTableView:(UITableView *)tableView;
@end
