//
//  JMEditerController.m
//  Creativity
//
//  Created by 赵俊明 on 2017/7/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMEditerController.h"
#import "JMEditerCollectionViewCell.h"
#import "JMEditerCollectionViewFlowLayout.h"
#import "JMEditerModel.h"
#import "JMEditerDetailController.h"
@interface JMEditerController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JMEditerCollectionViewFlowLayoutDelegate, JMEditerCollectionViewFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) JMEditerCollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) NSMutableArray *dataSource;
// 是否处于编辑状态
@property (nonatomic, assign) BOOL inEditState;

@end

@implementation JMEditerController

static NSString *const collectionID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    for (UIImage *image in _editerImages) {
        
        JMEditerModel *model = [[JMEditerModel alloc] init];
        model.showImage = image;
        model.deleteName = @"navbar_close_icon_black";
        [_dataSource addObject:model];
    }
    
    [_collection reloadData];
    
    self.leftImage = @"navbar_close_icon_black";
    self.rightImage = @"navbar_next_icon_black";
    
    self.collectionLayout = [[JMEditerCollectionViewFlowLayout alloc] init];
    self.collectionLayout.delegate = self;
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionLayout];
    _collection.backgroundColor = JMTabViewBaseColor;
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collection];
    
    // 注册
    [_collection registerClass:[JMEditerCollectionViewCell class] forCellWithReuseIdentifier:collectionID];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataSource removeAllObjects];
}

#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMEditerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.collection = collectionView;
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark UICollectionViewDelegat

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMEditerModel *model = self.dataSource[indexPath.row];
    JMEditerDetailController *detail = [[JMEditerDetailController alloc] init];
    detail.title = self.title;
    detail.editerImage = model.showImage;
    [self.navigationController pushViewController:detail animated:YES];
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
            
//            JMEditerModel *homeModel = self.dataSource[indexPath.row];
//            [[NSFileManager defaultManager] removeItemAtPath:[JMAccountPath stringByAppendingPathComponent:homeModel.folderName] error:nil];
//            
//            [self.collection deleteItemsAtIndexPaths:@[indexPath]];
//            [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
            
        } completion:nil];
        
    }else if([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = (self.view.width-20)/3;
    return CGSizeMake(rows, rows);
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
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
- (void)deleteByIndexPath:(NSIndexPath *)indexPath
{
    [self.collection performBatchUpdates:^{
        
//        JMEditerModel *homeModel = self.dataSource[indexPath.row];
//        [[NSFileManager defaultManager] removeItemAtPath:[JMAccountPath stringByAppendingPathComponent:homeModel.folderName] error:nil];
//        
//        [self.collection deleteItemsAtIndexPaths:@[indexPath]];
//        [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
        
        
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collection reloadData];
        });
    }];
}

#pragma mark -- ClassListCollectionCellDelegate

// 改变数据源中model的位置
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath
{
    JMEditerModel *model = self.dataSource[formPath.row];
    
    // 先把移动的这个model移除
    [_dataSource removeObject:model];
    
    // 再把这个移动的model插入到相应的位置
    [_dataSource insertObject:model atIndex:toPath.row];
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
