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
#import "JMBuyHelper.h"
#import "JMGetGIFController.h"
#import "JMGifView.h"
#import "JMFileManger.h"
#import "NSGIF.h"

@import GoogleMobileAds;
@interface JMPhotosController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *selectSource;

/// The interstitial ad.
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation JMPhotosController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createAndLoadInterstitial];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.interstitial.isReady) {[self.interstitial presentFromRootViewController:self];}
}

static NSString *const collectionID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectSource = [NSMutableArray array];
    self.leftImage = @"navbar_close_icon_black";
    
    JMPhotosLayout *collectionLayout = [[JMPhotosLayout alloc] init];
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
    [_collection registerClass:[JMPhotosCollectionCell class] forCellWithReuseIdentifier:collectionID];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.backgroundColor = [UIColor whiteColor];
    _collection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collection];
}

- (void)leftImageAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}   

- (void)rightImageAction:(UIBarButtonItem *)sender
{
    if (_selectSource.count>0) {
        
        TZAssetModel *model = _selectSource.firstObject;
        if (model.type == TZAssetModelMediaTypePhoto) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                JMGetGIFController *draw = [[JMGetGIFController alloc] init];
                NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
                [JMFileManger creatDir:gifPath];
                draw.filePath = [gifPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
                
                NSMutableArray *images = [NSMutableArray array];
                dispatch_queue_t queue=dispatch_queue_create("com.privateQueue", NULL);
                
                //异步任务1加入队列中
                dispatch_async(queue, ^{
                
                    for (TZAssetModel *model in _selectSource) {[images addObject:model.image];}
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        draw.imagesFromDrawVC = images;
                        [self.navigationController pushViewController:draw animated:YES];
                    });
                });
            });
        }
    }else{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"gif.base.alert.NoChiosePicAndQuit", "") preferredStyle:(UIAlertControllerStyleAlert)];
        
        // 创作
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        // 取消
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.cancle", "") style:(UIAlertActionStyleDefault) handler:nil]];
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
            
            if (_selectSource.count<10) {
            
                [self.selectSource addObject:model];
                model.index = _selectSource.count;
                cell.model = model;

                [[TZImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            
                    if (!isDegraded) {model.image = [photo drawRectNewImage];}
                }];
            }else{
            
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"gif.base.alert.picLessTen", "") message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *buyVip = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.getVIP", "") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                    JMBuyProViewController *pro = [[JMBuyProViewController alloc] init];
                    pro.title = NSLocalizedString(@"gif.set.sectionZero.rowZero", "");
                    JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:pro];
                    [self presentViewController:nav animated:YES completion:nil];
                }];
                
                [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.cancle", "") style:(UIAlertActionStyleDefault) handler:nil]];
                [alertController addAction:buyVip];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }else{
            // 如果取消选择的照片indx小于选中数组元素index，说明取消的是中间个数，对大于数量之行减1
            for (TZAssetModel *model_old in _selectSource) {
                
                if (model_old.index > model.index) {model_old.index = model_old.index-1;}
            }
            
            // 如果取消选择的照片inde小于选中数组元素个数，说明取消的是中间个数，需要重新刷新界面
            if (model.index < _selectSource.count ) {[collectionView reloadData];}
            model.image = nil;
            [self.selectSource removeObject:model];
            model.index = _selectSource.count;
            cell.model = model;
        }
        
    }else if (self.type == 1){
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            TZAssetModel *model = self.models[indexPath.row];
            model.type = TZAssetModelMediaTypeLivePhoto;
            [[TZImageManager manager] getAllLivePhotosCompletion:model gifData:^(NSData *data) {
                
                UIImage *images = [UIImage jm_animatedGIFWithData:data];
                JMGetGIFController *GIF = [[JMGetGIFController alloc] init];
                NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
                [JMFileManger creatDir:gifPath];
                GIF.filePath = [gifPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
                GIF.delayTime = images.duration/images.images.count;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [hud hideAnimated:YES];
                    GIF.imagesFromDrawVC = [images.images mutableCopy];
                    [self.navigationController pushViewController:GIF animated:YES];
                });
            }];
        });
        
    }else if (self.type == 2){
        
        TZAssetModel *model = self.models[indexPath.row];
        model.type = TZAssetModelMediaTypeBursts;
        
        [[TZImageManager manager] getBurstsAlbumCompletion:model gifData:^(NSMutableArray *images) {
            
            JMGetGIFController *GIF = [[JMGetGIFController alloc] init];
            NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
            [JMFileManger creatDir:gifPath];
            GIF.filePath = [gifPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
            GIF.imagesFromDrawVC = images;
            [self.navigationController pushViewController:GIF animated:YES];
        }];
        
    }else if (self.type == 3){
        
        TZAssetModel *model = self.models[indexPath.row];
        model.type = TZAssetModelMediaTypeGIF;
        [[TZImageManager manager] getAllGifCompletion:model gifData:^(NSData *gifData) {
            
            UIImage *images = [UIImage jm_animatedGIFWithData:gifData];
            JMGetGIFController *GIF = [[JMGetGIFController alloc] init];
            NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
            [JMFileManger creatDir:gifPath];
            GIF.filePath = [gifPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
            GIF.delayTime = images.duration/images.images.count;
            GIF.imagesFromDrawVC = [images.images mutableCopy];
            [self.navigationController pushViewController:GIF animated:YES];
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

#pragma mark -- googleADS
- (void)createAndLoadInterstitial {
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:GoogleUtiID];
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
//    request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9a"];
    [self.interstitial loadRequest:request];
}

- (void)dealloc
{    
#ifdef DEBUG
    NSLog(@"JMPhotosController = %s", __FUNCTION__);
#endif
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
