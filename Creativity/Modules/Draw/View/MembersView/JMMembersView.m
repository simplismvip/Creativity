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
#import "JMPaintView.h"

@interface JMMembersView() <UITableViewDelegate, UITableViewDataSource, JMMembersCellDelegate>

@property (nonatomic, weak) UITableView *tabView;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, assign) BOOL editer;
@end

@implementation JMMembersView

+ (void)initMemberDataArray:(NSMutableArray *)dataArray isEditer:(BOOL)isEditer addDelegate:(id)delegate
{
    NSMutableArray *array = [NSMutableArray array];
    for (JMPaintView *paint in dataArray) {
        
        JMMemberModel *model = [JMMemberModel new];
        model.showAndHide = @"icons8-visible";
        model.thumbnailImage = paint.image;
        [array addObject:model];
    }
    
    CGFloat h = 45*dataArray.count;
    if (h> kH/2) {h = kW;}
    
    JMMembersView *base = [[self alloc] initWithFrame:CGRectMake(0, kH, kW, h)];
    base.memberArray = array;
    base.editer = isEditer;
    base.delegate = delegate;
    [[JMGestureButton creatGestureButton] addSubview:base];
    [UIView animateWithDuration:0.3 animations:^{base.frame = CGRectMake(0, kH-h, kW, h);}];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.width, self.height-5) style:(UITableViewStylePlain)];
        [tabView registerClass:[JMMembersCell class] forCellReuseIdentifier:@"memberCell"];
        tabView.delegate = self;
        tabView.dataSource = self;
        tabView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        tabView.separatorColor = tabView.backgroundColor;
        
        tabView.showsVerticalScrollIndicator = NO;
        tabView.allowsSelection = NO;
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){tabView.cellLayoutMarginsFollowReadableWidth = NO;}
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMMembersCell *cell = [JMMembersCell initWithMemberCell:tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    JMMemberModel *model = self.memberArray[indexPath.row];
    cell.header.image = model.thumbnailImage;
    cell.name.text = [NSString stringWithFormat:@"%ld", indexPath.row];;
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
        if ([self.delegate respondsToSelector:@selector(removeCoverageAtIndex:)]) {
            
            [self.memberArray removeObjectAtIndex:indexPath.row];
            [self.tabView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.delegate removeCoverageAtIndex:indexPath.row];
        }
    }
}

// 移动
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([self.delegate respondsToSelector:@selector(moveCoverageAtIndexPath:toIndex:)]) {
        
        [self.delegate moveCoverageAtIndexPath:fromIndexPath.row toIndex:toIndexPath.row];
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
    if ([self.delegate respondsToSelector:@selector(hideCoverageAtIndex:isHide:)]) {
        
        [self.delegate hideCoverageAtIndex:index isHide:isHide];
    }
}

@end
