//
//  JMLicenceCell.h
//  Creativity
//
//  Created by 赵俊明 on 2017/6/24.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMLicenceModel;
@class JMLicenceViewModel;
@interface JMLicenceCell : UITableViewCell
@property (nonatomic, strong) JMLicenceModel *model;
@property (nonatomic, strong) JMLicenceViewModel *viewModel;
@end
