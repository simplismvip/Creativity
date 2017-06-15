//
//  JMMembersView.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/28.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMMembersView.h"
#import "JMMembersCell.h"
#import "JMMemberModel.h"
#import "NSObject+JMProperty.h"
#import "JMGestureButton.h"

@interface JMMembersView() <UITableViewDelegate, UITableViewDataSource, JMMembersCellDelegate>

@property (nonatomic, weak) UITableView *tabView;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, assign) BOOL editer;
@end

@implementation JMMembersView

+ (void)initMemberDataArray:(NSMutableArray *)dataArray isEditer:(BOOL)isEditer addDelegate:(id)delegate
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        
        JMMemberModel *model = [JMMemberModel new];
        
        if ([dic[@"fm"] isEqualToString:@"textNote"]) {
            
            model.Thumbnail = @"pencle";
            
        }else if ([dic[@"fm"] isEqualToString:@"mp3Note"]) {
            
            model.Thumbnail = @"horm_32";
            
        }else if ([dic[@"fm"] isEqualToString:@"emojiNote"]) {
            
            model.Thumbnail = dic[@"filePath"];
        }
        
        model.content = dic[@"fm"];
        model.index = [dic[@"index"] integerValue];
        [array addObject:model];
    }
    
    JMMembersView *base = [[self alloc] initWithFrame:CGRectMake(0, kH, kW, kH*0.418)];
    base.memberArray = array;
    base.editer = isEditer;
    base.delegate = delegate;
    [[JMGestureButton creatGestureButton] addSubview:base];
    [UIView animateWithDuration:0.4 animations:^{base.frame = CGRectMake(0, kH-kH*0.418, kW, kH*0.418);}];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.width, self.height-5) style:(UITableViewStylePlain)];
        [tabView registerClass:[JMMembersCell class] forCellReuseIdentifier:@"memberCell"];
        tabView.delegate = self;
        tabView.dataSource = self;
        tabView.alpha = 0.95;
        tabView.separatorColor = tabView.backgroundColor;
        tabView.showsVerticalScrollIndicator = NO;
        tabView.allowsSelection = NO;
        [self addSubview:tabView];
        self.tabView = tabView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tabView.frame = self.bounds;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
 if (!model.isHide) {
 
 
 }else{
 
 [cell.showAndHide setImage:[UIImage imageWithRenderingName:@"05"] forState:(UIControlStateNormal)];
 }

 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMMembersCell *cell = [JMMembersCell initWithMemberCell:tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    JMMemberModel *model = self.memberArray[indexPath.row];
    cell.name.text = model.content;
    cell.header.image = [UIImage imageNamed:model.Thumbnail];
    [cell.showAndHide setImage:[UIImage imageWithTemplateName:model.showAndHide] forState:(UIControlStateNormal)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        if ([self.delegate respondsToSelector:@selector(removeCoverageAtIndex:from:)]) {
            
            [self.memberArray removeObjectAtIndex:indexPath.row];
            [self.tabView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.delegate removeCoverageAtIndex:indexPath.row from:YES];
        }
    }
}

// 移动
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([self.delegate respondsToSelector:@selector(moveCoverageAtIndexPath:toIndex:from:)]) {
        
        [self.delegate moveCoverageAtIndexPath:fromIndexPath.row toIndex:toIndexPath.row from:YES];
        JMMemberModel *model = self.memberArray[fromIndexPath.row];
        [self.memberArray removeObjectAtIndex:fromIndexPath.row];
        [self.memberArray insertObject:model atIndex:toIndexPath.row];
    }
}
// 设置哪些行可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 限制跨区移动的方法
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section == proposedDestinationIndexPath.section) {
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
}

// 设置可以多行删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
    // return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark -- JMMembersCellDelegate
- (void)editerCell
{
    self.tabView.editing = !self.tabView.editing;
    [self.tabView setEditing:self.tabView.editing animated:YES];
}

- (void)hideView:(NSInteger)index isHide:(BOOL)isHide;
{
    if ([self.delegate respondsToSelector:@selector(hideCoverageAtIndex:isHide:from:)]) {
        
        [self.delegate hideCoverageAtIndex:index isHide:isHide from:YES];
    }
}

@end
