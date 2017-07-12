//
//  JMMembersCell.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/28.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMMembersCellDelegate <NSObject>

- (void)editerView:(NSIndexPath *)indexPath frame:(CGRect)frame;

@end

@class JMMemberModel;
@interface JMMembersCell : UITableViewCell
@property (nonatomic, weak) id<JMMembersCellDelegate> delegate;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) JMMemberModel *model;
+ (JMMembersCell *)initWithMemberCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
