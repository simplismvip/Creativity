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
#import "SDImageCache.h"

@interface JMEditerController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JMEditerCollectionViewFlowLayoutDelegate, JMEditerCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) JMEditerCollectionViewFlowLayout *collectionLayout;

// 是否处于编辑状态
@property (nonatomic, assign) BOOL inEditState;

@end

@implementation JMEditerController

static NSString *const collectionID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftImage = @"navbar_close_icon_black";
    self.rightTitle = NSLocalizedString(@"gif.base.alert.done", "");
    
    self.collectionLayout = [[JMEditerCollectionViewFlowLayout alloc] init];
    _collectionLayout.delegate = self;
    
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionLayout];
    _collection.backgroundColor = JMTabViewBaseColor;
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collection];
    
    // 注册
    [_collection registerClass:[JMEditerCollectionViewCell class] forCellWithReuseIdentifier:collectionID];
}

- (void)leftImageAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightTitleAction:(UIBarButtonItem *)sender
{
    if (self.editerDone) {self.editerDone(_editerImages);}
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.editerImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMEditerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.collection = collectionView;
    cell.image = _editerImages[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark UICollectionViewDelegat

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMEditerDetailController *detail = [[JMEditerDetailController alloc] init];
    detail.title = self.title;
    detail.editerImage = _editerImages[indexPath.row];
    [_editerImages removeObjectAtIndex:indexPath.row];
    JMSelf(ws);
    detail.editerDetailDone = ^(UIImage *image) {
        
        [ws.editerImages insertObject:image atIndex:indexPath.row];
        [ws.collection reloadData];
    };
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = (self.view.width-30)/5;
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
    [_collection performBatchUpdates:^{
        
        [_collection deleteItemsAtIndexPaths:@[indexPath]];
        [_editerImages removeObjectAtIndex:indexPath.row];
        
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_collection reloadData];
        });
    }];
}

#pragma mark -- ClassListCollectionCellDelegate

// 改变数据源中model的位置
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath
{
    UIImage *image = _editerImages[formPath.row];
    [_editerImages removeObject:image];
    [_editerImages insertObject:image atIndex:toPath.row];
}

- (void)dealloc
{    
#ifdef DEBUG
    NSLog(@"JMEditerController = %s", __FUNCTION__);
#endif
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
