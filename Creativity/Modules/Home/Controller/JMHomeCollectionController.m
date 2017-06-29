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
#import "ZMView.h"
#import "JMGifView.h"

@interface JMHomeCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JMHomeCollectionViewFlowLayoutDelegate, JMHomeCollectionViewCellDelegate, TZImagePickerControllerDelegate>
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        JMHomeModel *model = self.dataSource[indexPath.row];
        UIImage *image = [UIImage jm_animatedGIFWithData:[NSData dataWithContentsOfFile:model.folderPath]];
        JMGetGIFController *GIF = [[JMGetGIFController alloc] init];
        GIF.filePath = model.folderPath;
        GIF.delayTime = image.duration/image.images.count;
        
        NSMutableArray *newImages = [NSMutableArray array];
        for (UIImage *ima in image.images) {
            
            JMGifView *gif = [[JMGifView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
            gif.backgroundColor = [UIColor whiteColor];
            gif.image = ima;
            UIImage *newIma = [UIImage imageWithCaptureView:gif rect:CGRectMake(0, 0, self.view.width, self.view.width)];
            [newImages addObject:newIma];
        }
        
        GIF.images = newImages;
        GIF.imageView.image = image;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            [self.navigationController pushViewController:GIF animated:YES];
        });
    });
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [_collection reloadData];
}

#pragma mark -- left right UIBarButtonItem
- (void)setItem:(UIBarButtonItem *)sender
{
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:[[JMMeViewController alloc] init]];
    [self presentViewController:Nav animated:YES completion:nil];
}

- (void)newItem:(UIBarButtonItem *)sender
{
    [self getImageFromLibrary];
}

- (void)getImageFromLibrary
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择画板来源" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    // 相机
    [alertController addAction:[UIAlertAction actionWithTitle:@"创作" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
        [JMFileManger creatDir:gifPath];
        JMDrawViewController *draw = [[JMDrawViewController alloc] init];
        draw.folderPath = gifPath;
        [draw addNewPaintView];
        JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
        [self presentViewController:Nav animated:YES completion:nil];
    }]];
    
    // 相册
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:50 delegate:self];
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingVideo = NO;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
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


#pragma mark -- TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    if (photos.count> 2) {
      
        JMGetGIFController *draw = [[JMGetGIFController alloc] init];
        NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
        [JMFileManger creatDir:gifPath];
        draw.filePath = [gifPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
        
        NSMutableArray *newImages = [NSMutableArray array];
        for (UIImage *image in photos) {
            
            JMGifView *gif = [[JMGifView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
            gif.backgroundColor = [UIColor whiteColor];
            NSData *imageData = [image compressOriginalImage:image toMaxDataSizeKBytes:1024*100];
            gif.image = [UIImage imageWithData:imageData];
            UIImage *image = [UIImage imageWithCaptureView:gif rect:CGRectMake(0, 0, self.view.width, self.view.width)];
            [newImages addObject:image];
        }
        
        draw.images = [newImages mutableCopy];
        JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self presentViewController:Nav animated:YES completion:nil];
        });
    
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"生成Gif/Video所需照片必须大于1" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
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

- (UIImage *)newImage:(UIImage *)oldImage
{
    CGFloat rate = oldImage.size.width/oldImage.size.height;
    CGFloat w = kW;
    
    UIImage *imageNew;
    if (rate>1) {
        
        // w > h
        imageNew = [oldImage compressOriginalImage:oldImage toSize:CGSizeMake(w, w/rate)];
        
    }else if (rate<1){
        
        // w < h
        imageNew = [oldImage compressOriginalImage:oldImage toSize:CGSizeMake(w*rate, w)];
        
    }else{
        // w == h
        imageNew = [oldImage compressOriginalImage:oldImage toSize:CGSizeMake(w, w)];
    }
    
    return imageNew;
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
