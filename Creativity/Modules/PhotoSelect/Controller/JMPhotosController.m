//
//  JMPhotosController.m
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMPhotosController.h"
#import "JMPhotosLayout.h"
#import "JMPhotosCollectionCell.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"
@interface JMPhotosController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *selectSource;
@end

@implementation JMPhotosController

static NSString *const collectionID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectSource = [NSMutableArray array];
    self.leftImage = @"navbar_close_icon_black";
    self.rightTitle = @"完成";
    [self.view addSubview:self.collection];
}

- (void)leftImageAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightTitleAction:(UIBarButtonItem *)sender
{
    if (_selectSource.count>0) {
        
        if ([self.delegate respondsToSelector:@selector(pickerPhotosSuccess:)]) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self.delegate pickerPhotosSuccess:_selectSource];
        }
    }else{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"并未选择任何照片，是否退出！" preferredStyle:(UIAlertControllerStyleAlert)];
        
        // 创作
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        // 取消
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        if (IS_IPAD) {
            
            UIPopoverPresentationController *popover = alertController.popoverPresentationController;
            
            if (popover){
                popover.sourceView = self.navigationController.navigationBar;
                popover.sourceRect = self.navigationController.navigationBar.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
            }
        }        
    }
}

#pragma mark -- collectionView 方法
- (UICollectionView *)collection
{
    if (!_collection)
    {
        JMPhotosLayout *collectionLayout = [[JMPhotosLayout alloc] init];
        self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
        [_collection registerClass:[JMPhotosCollectionCell class] forCellWithReuseIdentifier:collectionID];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collection];
    }
    return _collection;
}

#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMPhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    TZAssetModel *model = self.models[indexPath.row];
    cell.model = model;
    return cell;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == ImageTypePhoto) {
        
        JMPhotosCollectionCell *cell = (JMPhotosCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        TZAssetModel *model = self.models[indexPath.row];
        model.type = TZAssetModelMediaTypePhoto;
        model.isSelect = !cell.isSelect;
        model.isHide = !model.isHide;
        
        if (!cell.isSelect) {
            
            model.image = cell.classImage.image;
            [self.selectSource addObject:model];
        }else{
            // 如果取消选择的照片indx小于选中数组元素index，说明取消的是中间个数，对大于数量之行减1
            for (TZAssetModel *model_old in _selectSource) {
                
                if (model_old.index > model.index) {model_old.index = model_old.index-1;}
            }
            
            // 如果取消选择的照片inde小于选中数组元素个数，说明取消的是中间个数，需要重新刷新界面
            if (model.index < _selectSource.count ) {[collectionView reloadData];}
            model.image = nil;
            [self.selectSource removeObject:model];
        }
        
        model.index = _selectSource.count;
        cell.model = model;
        
    }else if (self.type == 1){
    
        TZAssetModel *model = self.models[indexPath.row];
        model.type = TZAssetModelMediaTypeLivePhoto;
        
    }else if (self.type == 2){
        
        TZAssetModel *model = self.models[indexPath.row];
        model.type = TZAssetModelMediaTypeBursts;
        
    }else if (self.type == 3){
        
        TZAssetModel *model = self.models[indexPath.row];
        model.type = TZAssetModelMediaTypeGIF;
        [self.selectSource addObject:model];
        [[TZImageManager manager] getAllGifCompletion:model gifData:^(NSData *gifData) {
            
            if ([self.delegate respondsToSelector:@selector(pickerPhotosSuccess:)]) {
            
                model.image = [UIImage jm_animatedGIFWithData:gifData];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [self.delegate pickerPhotosSuccess:_selectSource];
            }
        }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
