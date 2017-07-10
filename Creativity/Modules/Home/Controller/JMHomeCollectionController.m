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
#import "UIImage+JMImage.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "JMGifView.h"
#import "JMPhotosAlertView.h"
#import "JMPhotosController.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"

@interface JMHomeCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JMHomeCollectionViewFlowLayoutDelegate, JMHomeCollectionViewCellDelegate, TZImagePickerControllerDelegate, JMPhotosAlertViewDelegate, JMPhotosControllerDelegate>
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
    cell.delegate = self;
    cell.collection = collectionView;
    
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        JMHomeModel *model = self.dataSource[indexPath.row];
        UIImage *image = [UIImage jm_animatedGIFWithData:[NSData dataWithContentsOfFile:model.folderPath]];
        JMGetGIFController *GIF = [[JMGetGIFController alloc] init];
        GIF.filePath = model.folderPath;
        GIF.delayTime = 2-image.duration/image.images.count;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            GIF.imagesFromHomeVC = [image.images mutableCopy];
            [self.navigationController pushViewController:GIF animated:YES];
        });
    });
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = (self.view.width-5*3)/2;
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

#pragma mark -- JMHomeCollectionViewCellDelegate
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
    JMHomeModel *model = self.dataSource[indexPath.row];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSData dataWithContentsOfFile:model.folderPath]] applicationActivities:nil];
    
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        
        if (IS_IPAD) {
            
            UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
            
            if (popover){
                popover.sourceView = self.navigationController.navigationBar;
                popover.sourceRect = self.navigationController.navigationBar.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
            }
        }else{
        
            activityViewController.popoverPresentationController.sourceView = self.view;
        }
    }
    
    [self presentViewController:activityViewController animated:YES completion:NULL];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [_collection reloadData];
}

#pragma mark -- left right UIBarButtonItem
- (void)leftImageAction:(UIBarButtonItem *)sender
{
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:[[JMMeViewController alloc] init]];
    [self presentViewController:Nav animated:YES completion:nil];
}

- (void)rightImageAction:(UIBarButtonItem *)sender
{
    JMPhotosAlertView *alert = [[JMPhotosAlertView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 80+44*6)];
    alert.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:backView];
    [backView addSubview:alert];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        alert.frame = CGRectMake(0, self.view.bounds.size.height-(40+44*6), self.view.bounds.size.width, 40+44*6);
    }];
}

#pragma mark --
- (void)photoFromSource:(NSInteger)sourceType
{
    JMPhotosController *photos = [[JMPhotosController alloc] init];
    photos.delegate = self;

    if (sourceType == 200) {
        
        NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
        [JMFileManger creatDir:gifPath];
        
        JMDrawViewController *draw = [[JMDrawViewController alloc] init];
        draw.folderPath = gifPath;
        [draw initPaintBoard:nil images:nil];
        JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
        [self presentViewController:Nav animated:YES completion:nil];
        
    }else if (sourceType == 201){
    
        photos.type = ImageTypePhoto;
        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:YES completion:^(TZAlbumModel *model) {
            
            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                
                photos.models = models;
            }];
        }];
        
    }else if (sourceType == 202){
    
        photos.type = ImageTypePhotoLivePhoto;
        
    }else if (sourceType == 203){
        
        photos.type = ImageTypePhotoBursts;
        
    }else if (sourceType == 204){
        
        photos.type = ImageTypePhotoGIF;
        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:YES completion:^(TZAlbumModel *model) {
            
            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                
                NSMutableArray *gifs = [NSMutableArray array];
                for (TZAssetModel *model in models) {
                    
                    NSArray *resourceList = [PHAssetResource assetResourcesForAsset:model.asset];
                    [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        PHAssetResource *resource = obj;
                        if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
                            
                            [gifs addObject:model];
                        }
                    }];
                }
                
                photos.models = [gifs copy];
            }];
        }];
    }
    
    JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:photos];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- JMPhotosControllerDelegate
- (void)pickerPhotosSuccess:(NSArray *)photos
{
    TZAssetModel *model = photos.firstObject;
    if (model.type == TZAssetModelMediaTypePhoto) {
        
        NSMutableArray *images = [NSMutableArray array];
        for (TZAssetModel *model in photos) {
            
            JMGifView *gif = [[JMGifView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
            gif.image = model.image;
            UIImage *image = [UIImage imageWithCaptureView:gif rect:CGRectMake(0, 0, self.view.width, self.view.width)];
            [images addObject:image];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            JMGetGIFController *draw = [[JMGetGIFController alloc] init];
            NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
            [JMFileManger creatDir:gifPath];
            draw.filePath = [gifPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
            
            draw.delayTime = 0.5;
            draw.imagesFromDrawVC = images;
            JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
            
            [self presentViewController:Nav animated:YES completion:nil];
        });
        
    }else if (model.type == TZAssetModelMediaTypeLivePhoto){
    
        
    }else if (model.type == TZAssetModelMediaTypeBursts){
        
        
    }else if (model.type == TZAssetModelMediaTypeGIF){
        
        TZAssetModel *model = photos.firstObject;
        JMGetGIFController *GIF = [[JMGetGIFController alloc] init];
        NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
        [JMFileManger creatDir:gifPath];
        GIF.filePath = gifPath;
        GIF.delayTime = 2-model.image.duration/model.image.images.count;
        
        NSMutableArray *newImages = [NSMutableArray array];
        for (UIImage *ima in model.image.images) {
            
            JMGifView *gif = [[JMGifView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
            gif.image = ima;
            UIImage *newIma = [UIImage imageWithCaptureView:gif rect:CGRectMake(0, 0, self.view.width, self.view.width)];
            [newImages addObject:newIma];
        }
        GIF.imagesFromHomeVC = newImages;
        [self.navigationController pushViewController:GIF animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    // Dispose of any resources that can be recreated.
}

/*
 
 // 获取连拍快照
 - (void)getBursts:(NSArray<TZAlbumModel *> *)models
 {
 for (TZAlbumModel *model in models) {
 
 if ([model.name isEqualToString:@"Bursts"]) {
 
 [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
 
 for (TZAssetModel *model in models) {
 
 //                    [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:64 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
 //
 //                        NSLog(@"%@----Bursts----%@", photo, info);
 //                    }];
 
 NSArray *resourceList = [PHAssetResource assetResourcesForAsset:model.asset];
 [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 PHAssetResource *resource = obj;
 NSLog(@"---Bursts---%@", resource.uniformTypeIdentifier);
 
 //                        if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
 //
 //                            NSLog(@"---微博动图---%@", resource.uniformTypeIdentifier);
 //                        }
 }];
 }
 }];
 }
 }
 }
 
 // 获取livePhotos
 - (void)getLivePhotos:(NSArray<TZAlbumModel *> *)models
 {
 for (TZAlbumModel *model in models) {
 
 if ([model.name isEqualToString:@"Live Photos"]) {
 
 [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
 
 for (TZAssetModel *model in models) {
 
 NSArray *resourceList = [PHAssetResource assetResourcesForAsset:model.asset];
 [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 PHAssetResource *resource = obj;
 NSLog(@"---Live Photos---%@", resource.uniformTypeIdentifier);
 
 //                        if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
 //
 //                            NSLog(@"------%@", resource.uniformTypeIdentifier);
 //                        }
 }];
 
 //                    [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:64 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
 //
 //                        NSLog(@"%@----Live Photos----%@", photo, info);
 //
 //                    }];
 }
 }];
 }
 }
 }
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
