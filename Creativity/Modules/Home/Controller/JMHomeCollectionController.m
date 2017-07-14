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
#import "JMGifView.h"
#import "JMPhotosAlertView.h"
#import "JMPhotosController.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
#import <UShareUI/UShareUI.h>
#import "ShareTool.h"
#import <Social/Social.h>

@interface JMHomeCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JMHomeCollectionViewCellDelegate, JMPhotosAlertViewDelegate ,UMSocialShareMenuViewDelegate>
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMHomeCollectionController

static NSString *const collectionID = @"cell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataSource = [JMFileManger homeModels];
    [self.collection reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataSource removeAllObjects];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [_collection reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"gif.home.navigation.title", "");
    self.leftImage = @"toolbar_setting_icon_black";
    self.rightImage = @"navbar_plus_icon_black";
    
    JMHomeCollectionViewFlowLayout *collectionLayout = [[JMHomeCollectionViewFlowLayout alloc] init];
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
    [self.view addSubview:collection];
    [collection registerClass:[JMHomeCollectionViewCell class] forCellWithReuseIdentifier:collectionID];
    collection.backgroundColor = JMColor(41, 41, 41);
    collection.dataSource = self;
    collection.delegate = self;
    collection.showsVerticalScrollIndicator = NO;
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {make.edges.mas_equalTo(self.view);}];
    self.collection = collection;
    
    
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Sina),]];
    
    [UMSocialUIManager setShareMenuViewDelegate:self];
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
        GIF.title = NSLocalizedString(@"gif.home.VC.title.gifBoart", "");
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

//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType shareImage:(id)shareImage
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareEmotionObject *gif = [UMShareEmotionObject shareObjectWithTitle:@"来自GIF大师的分享" descr:@"哈哈哈🙃🙃🙃" thumImage:[UIImage imageNamed:@"text"]];
    gif.emotionData = shareImage;
    messageObject.shareObject = gif;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark -- JMHomeCollectionViewCellDelegate
- (void)share:(NSIndexPath *)indexPath
{
    JMHomeModel *model = self.dataSource[indexPath.row];

//    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
//    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
//    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        
//        [self shareImageAndTextToPlatformType:platformType shareImage:[NSData dataWithContentsOfFile:model.folderPath]];
//    }];
    
//    [[ShareTool alloc] shareWithTitle:@"来自GIF Master的分享" description:@"" url:@"" completionHandler:^(UIActivityType  _Nullable activityType, BOOL completed) {
        
        
//    }];
    
//    NSMutableArray *items = [NSMutableArray array];
//    [items addObject:@"来自GIF Master的分享"];
//    [items addObject:[NSData dataWithContentsOfFile:model.folderPath]];
//    [items addObject:@"https://www.baidu.com"];
    
    NSURL *url = [NSURL fileURLWithPath:model.folderPath];
    
    // 38773
    // 180957
    // 57348
    // 2590754
    NSData *data = [NSData dataWithContentsOfFile:model.folderPath];
    
//    // 1.判断平台是否可用
//    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
//        NSLog(@"查看您是否设置了新浪微博帐号,设置界面-->新浪微博-->配置帐号");
//    }
//    
//    // 2.创建SLComposeViewController
//    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//    
//    // 2.1.添加分享文字
//    [composeVc setInitialText:@"做人如果没有梦想,跟咸鱼有什么区别"];
//    
//    // 2.2.添加分享图片
//    [composeVc addURL:url];
//    
//    // 3.弹出分享界面
//    [self presentViewController:composeVc animated:YES completion:nil];
//    
//    
//    // 4.设置block属性
//    composeVc.completionHandler = ^(SLComposeViewControllerResult result) {
//        if (result == SLComposeViewControllerResultCancelled) {
//            NSLog(@"用户点击了取消");
//        } else {
//            NSLog(@"用户点击了发送");
//        }
//    };
    
    // UIActivityTypeAirDrop, 
    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToTwitter]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    activityViewController.excludedActivityTypes = excludedActivityTypes;
    
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"%@  ----   %@", activityType, returnedItems);
    };
    
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

#pragma mark -- left right UIBarButtonItem
- (void)leftImageAction:(UIBarButtonItem *)sender
{
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:[[JMMeViewController alloc] init]];
    [self presentViewController:Nav animated:YES completion:nil];
}

- (void)rightImageAction:(UIBarButtonItem *)sender
{
    NSArray *array = @[
                       NSLocalizedString(@"gif.home.bottom.alert.board", ""),
                       NSLocalizedString(@"gif.home.bottom.alert.album", ""),
                       NSLocalizedString(@"gif.home.bottom.alert.gif", ""),
                       NSLocalizedString(@"gif.base.alert.cancle", "")];
    JMPhotosAlertView *alert = [[JMPhotosAlertView alloc] initWithFrame:CGRectMake(0, kH, kW, alertHeight)];
    alert.titles = array;
    alert.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:backView];
    [backView addSubview:alert];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        alert.frame = CGRectMake(0, kH-(12+alertHeight*array.count), kW, 12+alertHeight*array.count);
    }];
}

#pragma mark --
- (void)photoFromSource:(NSInteger)sourceType
{
    if (sourceType == 200) {
        
        NSString *gifPath = [JMDocumentsPath stringByAppendingPathComponent:[JMHelper timerString]];
        [JMFileManger creatDir:gifPath];
        
        JMDrawViewController *draw = [[JMDrawViewController alloc] init];
        draw.title = NSLocalizedString(@"gif.home.VC.title.gifBoart", "");
        draw.folderPath = gifPath;
        [draw initPaintBoard:nil images:nil];
        JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
        [self presentViewController:Nav animated:YES completion:nil];
        
    }else if (sourceType == 201){
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        JMPhotosController *photos = [[JMPhotosController alloc] init];
        photos.rightImage = @"navbar_next_icon_black";
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            photos.type = ImageTypePhoto;
            [[TZImageManager manager] getAllAlbumPhotosCompletion:^(NSArray<TZAssetModel *> *models) {
                
                photos.models = models;
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                photos.title = NSLocalizedString(@"gif.home.VC.title.CameraRoll", "");
                JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:photos];
                [self presentViewController:nav animated:YES completion:nil];
            });
        });
        
    }else if (sourceType == 202){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        JMPhotosController *photos = [[JMPhotosController alloc] init];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            photos.type = ImageTypePhotoGIF;
            [[TZImageManager manager] getAllGifCompletion:^(NSMutableArray<TZAssetModel *> *models) {
            
                photos.models = [models copy];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                photos.title = NSLocalizedString(@"gif.home.VC.title.gifAlbum", "");
                JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:photos];
                [self presentViewController:nav animated:YES completion:nil];
            });
        });
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
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
