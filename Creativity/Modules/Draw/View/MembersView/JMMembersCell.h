//
//  JMMembersCell.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/28.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMMembersCellDelegate <NSObject>

- (void)editerCell;
- (void)hideView:(NSInteger)index isHide:(BOOL)isHide;

@end

@interface JMMembersCell : UITableViewCell
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIButton *showAndHide;
@property (nonatomic, strong) UILabel *name;

@property (nonatomic, weak) id<JMMembersCellDelegate> delegate;

+ (JMMembersCell *)initWithMemberCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
