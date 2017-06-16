//
//  JMMembersView.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/28.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMMembersViewDelegate <NSObject>
- (void)moveCoverageAtIndexPath:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)removeCoverageAtIndex:(NSInteger)index;
- (void)hideCoverageAtIndex:(NSInteger)index isHide:(BOOL)isHide;
@end

@interface JMMembersView : UIView
@property (nonatomic, weak) id<JMMembersViewDelegate> delegate;
+ (void)initMemberDataArray:(NSMutableArray *)dataArray isEditer:(BOOL)isEditer addDelegate:(id)delegate;
@end
