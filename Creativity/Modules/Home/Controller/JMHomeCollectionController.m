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
#import "JMMeViewController.h"
#import "JMMainNavController.h"
#import "JMDrawViewController.h"
#import "UserDefaultTools.h"
#import "JMFileManger.h"
#import "JMHelper.h"
#import "UIImage+GIF.h"
#import "JMGetGIFController.h"
#import "Masonry.h"
#import "FLAnimatedImageView+WebCache.h"

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
    NSError *error;
    
    self.dataSource = [NSMutableArray array];
    NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:JMDocumentsPath error:&error];
    
    for (NSString *path in dirs) {
        
        if (![path isEqualToString:@".DS_Store"]) {
            
            NSString *pngPath = [JMDocumentsPath stringByAppendingPathComponent:path];
            NSArray *pngs = [JMFileManger getFileFromDir:pngPath bySuffix:@"gif"];
            
            if (pngs.count>0) {
                
                NSDictionary *dic = @{
                                      @"folderPath":pngs.firstObject,
                                      @"creatDate":[JMHelper timestamp:path],
                                      @"size":@"1024"
                                      };
                
                JMHomeModel *model = [JMHomeModel objectWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }
    }
    
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
    self.title = @"我的动画";
    self.leftImage = @"toolbar_setting_icon_black";
    self.rightImage = @"navbar_plus_icon_black";
    [self.view addSubview:self.collection];
}

- (void)setItem:(UIBarButtonItem *)sender
{
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:[[JMMeViewController alloc] init]];
    [self presentViewController:Nav animated:YES completion:nil];
}

- (void)newItem:(UIBarButtonItem *)sender
{
    NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
    [JMFileManger creatDir:gifPath];
    JMDrawViewController *draw = [[JMDrawViewController alloc] init];
    draw.folderPath = gifPath;
    [draw creatGifNew];
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
    [self presentViewController:Nav animated:YES completion:nil];
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
    JMHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
//    cell.inEditState = _inEditState;
//    cell.delegate = self;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMHomeModel *model = self.dataSource[indexPath.row];
    JMGetGIFController *draw = [[JMGetGIFController alloc] init];
    draw.filePath = model.folderPath;
    draw.isHome = YES;
    UIImage *image = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:model.folderPath]];
    draw.images = [NSMutableArray arrayWithArray:image.images];
    [self.navigationController pushViewController:draw animated:YES];
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        
        [_collection performBatchUpdates:^{
            
            JMHomeModel *homeModel = self.dataSource[indexPath.section][indexPath.row];
            [[NSFileManager defaultManager] removeItemAtPath:[JMDocumentsPath stringByAppendingPathComponent:homeModel.folderPath] error:nil];
            
            [self.collection deleteItemsAtIndexPaths:@[indexPath]];
            [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
            
        } completion:nil];
        
    }else if([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = (self.view.width-10*3)/2;
    return CGSizeMake(rows, rows);
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 5, 10);
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
        [[NSFileManager defaultManager] removeItemAtPath:[JMDocumentsPath stringByAppendingPathComponent:homeModel.folderPath] error:nil];
        
        [self.collection deleteItemsAtIndexPaths:@[indexPath]];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        
        
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
    JMHomeModel *model = self.dataSource[formPath.row];
    
    // 先把移动的这个model移除
    [self.dataSource removeObject:model];
    
    // 再把这个移动的model插入到相应的位置
    [self.dataSource insertObject:model atIndex:toPath.row];
}

- (UICollectionView *)collection
{
    if (!_collection)
    {
        self.collectionLayout = [[JMHomeCollectionViewFlowLayout alloc] init];
        self.collectionLayout.delegate = self;
        self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionLayout];
        [_collection registerClass:[JMHomeCollectionViewCell class] forCellWithReuseIdentifier:collectionID];
        _collection.backgroundColor = JMColor(41, 41, 41);
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collection];
        
        [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(self.view);
            
        }];
    }
    return _collection;
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
