//
//  JMHomeCollectionController.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMHomeCollectionController.h"
#import "JMHomeModel.h"
#import "JMHomeCollectionViewCell.h"
#import "JMHomeCollectionReusableView.h"
#import "JMHomeCollectionViewFlowLayout.h"
#import "NSObject+JMProperty.h"
// #import "JMDrawViewController.h"
#import "UserDefaultTools.h"

@interface JMHomeCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JMHomeCollectionViewFlowLayoutDelegate, JMHomeCollectionViewCellDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) JMHomeCollectionViewFlowLayout *collectionLayout;

// 是否处于编辑状态
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL inEditState;
@end

@implementation JMHomeCollectionController

static NSString *const collectionID = @"cell";
static NSString *const footerID = @"footer";
static NSString *const headerID = @"header";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataSource = [NSMutableArray arrayWithArray:@[@[@"", @"", @""], @[@"", @"", @""], @[@"", @"", @""], @[@"", @"", @""], @[@"", @"", @""]]];
    [self.collection reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataSource removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.key = @"001";
    [self.view addSubview:self.collection];
}

- (UICollectionView *)collection
{
    if (!_collection)
    {
        self.collectionLayout = [[JMHomeCollectionViewFlowLayout alloc] init];
        self.collectionLayout.delegate = self;
        self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionLayout];
        _collection.backgroundColor = JMTabViewBaseColor;
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collection];
        
        // 注册
        [_collection registerClass:[JMHomeCollectionViewCell class] forCellWithReuseIdentifier:collectionID];
        [_collection registerClass:[JMHomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
        [_collection registerClass:[JMHomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    }
    return _collection;
}


#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    /*
    cell.collection = collectionView;
    cell.isGrid = [UserDefaultTools readBoolByKey:self.key];
    cell.inEditState = _inEditState;
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    cell.delegate = self;
     */
    return cell;
}

// 返回辅助视图工具
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JMHomeCollectionReusableView *header;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        header.text.text = [NSString stringWithFormat:@"section %ld", indexPath.section+1];
        if (header == nil) {header = [[JMHomeCollectionReusableView alloc] init];}
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerID forIndexPath:indexPath];
        if (header == nil) {header = [[JMHomeCollectionReusableView alloc] init];}
    }
    
    return header;
}

#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    return NO;
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        
        [_collection performBatchUpdates:^{
            
            JMHomeModel *homeModel = self.dataSource[indexPath.section][indexPath.row];
            [[NSFileManager defaultManager] removeItemAtPath:[JMAccountPath stringByAppendingPathComponent:homeModel.folderName] error:nil];
            
            [self.collection deleteItemsAtIndexPaths:@[indexPath]];
            [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
            
        } completion:nil];
        
    }else if([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UserDefaultTools readBoolByKey:self.key]) {
        
        NSInteger rows = (self.view.width-10*4)/3;
        return CGSizeMake(rows, rows+40);
        
    } else {
        return CGSizeMake(self.view.width-20, (self.view.width-6)/4+20);
    }
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

// 动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.width, 25);
}

// 动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}

#pragma mark -- 私有方法
- (void)refreshData
{
    [self.collection reloadData];
}

- (void)leftSwitchEditerStatus
{
    // 点击了管理
    if (!self.inEditState) {
        
        self.inEditState = YES;
        self.collection.allowsSelection = NO;
        
    } else { // 点击了完成
        
        self.inEditState = NO;
        self.collection.allowsSelection = YES;
    }
    
    // 进入或退出编辑状态
    [self.collectionLayout setInEditState:self.inEditState];
}


#pragma mark -- JMHomeCollectionViewCellDelegate
- (void)showRoomMembers:(NSIndexPath *)indexPath currentPoint:(CGPoint)currentPoint
{
    
}

- (void)deleteByIndexPath:(NSIndexPath *)indexPath
{
    [self.collection performBatchUpdates:^{
        
        JMHomeModel *homeModel = self.dataSource[indexPath.section][indexPath.row];
        [[NSFileManager defaultManager] removeItemAtPath:[JMAccountPath stringByAppendingPathComponent:homeModel.folderName] error:nil];
        
        [self.collection deleteItemsAtIndexPaths:@[indexPath]];
        [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
        
        
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collection reloadData];
        });
    }];
}

- (void)share:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- ClassListCollectionCellDelegate
- (void)didChangeEditState:(BOOL)inEditState
{
    self.inEditState = inEditState;
    for (JMHomeCollectionViewCell *cell in self.collection.visibleCells) {
        
        cell.inEditState = inEditState;
    }
}

// 改变数据源中model的位置
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath
{
    NSMutableArray *sections = self.dataSource[formPath.section];
    JMHomeModel *model = sections[formPath.row];
    
    // 先把移动的这个model移除
    [sections removeObject:model];
    
    // 再把这个移动的model插入到相应的位置
    [sections insertObject:model atIndex:toPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
