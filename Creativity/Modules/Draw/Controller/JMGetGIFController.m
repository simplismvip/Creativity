//
//  JMGetGIFController.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMGetGIFController.h"
#import "JMHelper.h"
#import "JMMediaHelper.h"
#import "JMDrawViewController.h"
#import "JMMainNavController.h"
#import <UMMobClick/MobClick.h>
#import <UShareUI/UShareUI.h>
#import "JMFileManger.h"
#import "UIImage+JMImage.h"
#import "JMGetGIFBottomView.h"
#import "JMFilterItem.h"
#import "JMButtom.h"
#import "JMFrameView.h"
#import "NSTimer+JMAddition.h"
#import "JMGIFAnimationView.h"
#import "JMEditerController.h"
#import "TZImageManager.h"
#import "JMPhotosAlertView.h"
#import "UIImage+Filters.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIImage+Rotate.h"

@interface JMGetGIFController ()<JMGetGIFBottomViewDelegate, JMPhotosAlertViewDelegate, UMSocialShareMenuViewDelegate>
{
    NSTimer *_aniTimer;
    BOOL _pause;
    BOOL _isSave;
    CGFloat rotation;
}

@property (nonatomic, weak) UIButton *showFps;
@property (nonatomic, weak) JMFrameView *frameView;
@property (nonatomic, weak) JMGIFAnimationView *animationView;
@property (nonatomic, weak) JMGetGIFBottomView *bsae;
@end

@implementation JMGetGIFController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = JMColor(41, 41, 41);
    [MobClick beginLogPageView:@"JMGetGIFController"];
    if (_delayTime>0) {
        
        [_animationView setDelayer:_delayTime];
    }else{
        [_animationView setDelayer:0.7];
        _delayTime = 0.7;
    }
    
    _bsae.sliderA.value = _animationView.delayer;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_animationView stopAnimation];
    [MobClick endLogPageView:@"JMGetGIFController"];
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pause = NO;
    
    JMSelf(ws);
    JMGIFAnimationView *aniView = [[JMGIFAnimationView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
    aniView.backgroundColor = [UIColor whiteColor];
    aniView.center = self.view.center;
    aniView.frameChange = ^(NSInteger index) {[ws.frameView refrashLocation:index];};
    aniView.imageSource = [_images copy];
    [self.view addSubview:aniView];
    self.animationView = aniView;
    
    // 顶部动画显示
    JMFrameView *frameView = [[JMFrameView alloc] initWithFrame:CGRectMake(10, 84, kW-20, 40)];
    frameView.images = _images;
    frameView.layer.borderColor = JMBaseColor.CGColor;
    frameView.layer.borderWidth = 3;
    [self.view addSubview:frameView];
    self.frameView = frameView;
    
    // 底部菜单显示
    JMGetGIFBottomView *bsae = [[JMGetGIFBottomView alloc] initWithFrame:CGRectMake(0, kH, kW, 74)];
    bsae.subViews = @[@"filters", @"navbar_video_icon_disabled_black", @"gif", @"navbar_pause_icon_black", @"turnaroundback", @"turnaroundgo"];
    bsae.delegate = self;
    [self.view addSubview:bsae];
    self.bsae = bsae;
    [UIView animateWithDuration:0.3 animations:^{bsae.frame = CGRectMake(0, kH-74, kW, 74);}];

    // 滑动slider时显示帧数
    JMButtom *showFps = [[JMButtom alloc] init];
    showFps.layer.cornerRadius = 10;
    [showFps setImage:[[UIImage imageNamed:@"ellopse_32"] imageWithColor:JMBaseColor] forState:(UIControlStateNormal)];
    showFps.titleLabel.font = [UIFont systemFontOfSize:14.0];
    showFps.titleLabel.textColor = [UIColor whiteColor];
    showFps.frame = CGRectMake(0, 0, 100, 100);
    showFps.center = self.view.center;
    showFps.hidden = YES;
    showFps.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    [self.view addSubview:showFps];
    self.showFps = showFps;
    
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

#pragma mark -- drawVC界面进入
- (void)setImagesFromDrawVC:(NSMutableArray *)imagesFromDrawVC
{
    _imagesFromDrawVC = imagesFromDrawVC;
    self.images = imagesFromDrawVC;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"gif.base.alert.done", "") style:(UIBarButtonItemStyleDone) target:self action:@selector(Done:)];
    self.navigationItem.rightBarButtonItems = @[right];
}

#pragma mark -- home界面进入
- (void)setImagesFromHomeVC:(NSMutableArray *)imagesFromHomeVC
{
    _imagesFromHomeVC = imagesFromHomeVC;
    self.images = imagesFromHomeVC;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_delete_icon_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(deleteBtn:)];
    UIBarButtonItem *editer = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"gif.base.alert.editer", "") style:(UIBarButtonItemStyleDone) target:self action:@selector(Editer:)];
    self.navigationItem.rightBarButtonItems = @[right, editer];
}

// 创作选项弹出，保存第一次生成GIF文件
- (void)Done:(UIBarButtonItem *)done
{
    _isSave ? [self.navigationController dismissViewControllerAnimated:YES completion:nil] : [self showAlert];
}

- (BOOL)navigationShouldPopOnBackButton
{
    if (!_isSave) {[self showAlert];}
    return YES;
}

- (void)showAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"gif.base.alert.fileNotSave", "") message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *buyVip = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        _imagesFromHomeVC ? [self.navigationController popViewControllerAnimated:YES] : [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.cancle", "") style:(UIAlertActionStyleDefault) handler:nil];
    [alertController addAction:cancle];
    [alertController addAction:buyVip];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 1> 开始编辑
- (void)Editer:(UIBarButtonItem *)done
{
    JMSelf(ws);
    JMEditerController *editer = [[JMEditerController alloc] init];
    editer.title = NSLocalizedString(@"gif.base.alert.editer", "");
    editer.editerImages = _images;
    editer.editerDone = ^(NSMutableArray *images) {
    
        ws.images = images;
        ws.animationView.imageSource = [images copy];
        ws.frameView.images = images;
    };
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:editer];
    [self presentViewController:Nav animated:YES completion:nil];
    
    // 删除GIF文件
    // [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
}

// 编辑界面，删除GIF文件
- (void)deleteBtn:(UIBarButtonItem *)done
{
    NSString *string = [NSString stringWithFormat:@"/%@", [_filePath lastPathComponent]];
    [JMFileManger removeFileByPath:[_filePath stringByReplacingOccurrencesOfString:string withString:@""]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- JMGetGIFBottomViewDelegate
- (void)changeValue:(CGFloat)value
{
    _delayTime = value;
    _animationView.delayer = value;
    
    [UIView animateWithDuration:.8 animations:^{
        
        _showFps.transform = CGAffineTransformMakeScale(0.01, 0.01);
        _showFps.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        _showFps.transform = CGAffineTransformMakeScale(1, 1);
        _showFps.hidden = YES;
        _showFps.alpha = 1.0;
    }];
}

- (void)changeValueSerial:(CGFloat)progress
{    
    _showFps.hidden = NO;
    [self.showFps setTitle:[NSString stringWithFormat:@"%ld 秒", (NSInteger)(progress*_images.count)] forState:(UIControlStateNormal)];
}

#pragma mark -- 添加滤镜效果
- (void)filtersDidSelectRowAtIndexPath:(NSInteger)index isVip:(BOOL)isVip
{
    if ([JMBuyHelper isVip]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSMutableArray *newImages = [NSMutableArray array];
            for (UIImage *originImage in _images) {
                
                [newImages addObject:[originImage setFiltersByIndex:index]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                _images = newImages;
                _animationView.imageSource = [newImages copy];
            });
        });
    }else{
        if (isVip) {
            
            JMBuyProViewController *pro = [[JMBuyProViewController alloc] init];
            pro.title = NSLocalizedString(@"gif.set.sectionZero.rowZero", "");
            JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:pro];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                
                NSMutableArray *newImages = [NSMutableArray array];
                for (UIImage *originImage in _images) {
                    
                    [newImages addObject:[originImage setFiltersByIndex:index]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [hud hideAnimated:YES];
                    _images = newImages;
                    _animationView.imageSource = [newImages copy];
                });
            });
        }
    }
}

// 总时间 = 张数 * 每张时间, fps = 1/每张时间
- (void)didSelectRowAtIndexPath:(NSInteger)index
{
    if (index == 1){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSString *videoPath = [self.filePath stringByReplacingOccurrencesOfString:@"gif" withString:@"mp4"];
            
            // 总时间
            [JMMediaHelper saveImagesToVideoWithImages:[self ramoteImage:_images] fps:1/_delayTime+1 andVideoPath:videoPath completed:^(NSString *filePath) {
                
                [[TZImageManager manager] saveGifOrVideoToMyAlbum:filePath isPhoto:NO completion:^(BOOL isSuccess) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [hud hideAnimated:YES];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.square = YES;
                        
                        if (isSuccess) {
                            
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                            
                            hud.label.text = NSLocalizedString(@"gif.base.alert.done", "");
                            [hud hideAnimated:YES afterDelay:1.5f];
                            [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                            _isSave = YES;
                            [self showShare];

                        }else{
                            
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"navbar_close_icon_black"]];
                            hud.label.text = NSLocalizedString(@"gif.base.alert.Failed", "");
                            [hud hideAnimated:YES afterDelay:1.5f];
                        }
                    });
                }];
                
            } andFailed:^(NSError *error) {
                
                NSLog(@"fail");
            }];
        });
        
    }else if (index == 2){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            [JMMediaHelper makeAnimatedGIF:_filePath images:[self ramoteImage:_images] delayTime:_delayTime];
            [[TZImageManager manager] saveGifOrVideoToMyAlbum:_filePath isPhoto:YES completion:^(BOOL isSuccess) {
             
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [hud hideAnimated:YES];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                    hud.square = YES;
                    hud.label.text = NSLocalizedString(@"gif.base.alert.done", "");
                    [hud hideAnimated:YES afterDelay:1.5f];
                    _isSave = YES;
                    [self showShare];
                });
            }];
        });
        
    }else if (index == 3){
        
        UIButton *btn = [self.bsae viewWithTag:index+200];
        if (_pause) {
            
            [btn setImage:[UIImage imageNamed:@"navbar_pause_icon_black"] forState:(UIControlStateNormal)];
            [_animationView restartAnimation];
        }else {
            
            [btn setImage:[UIImage imageNamed:@"navbar_play_icon"] forState:(UIControlStateNormal)];
            [_animationView pauseAnimation];
        }
        
        _pause = !_pause;
        
    }else if (index == 4){
        
        rotation += 90;
        _animationView.transform = CGAffineTransformMakeRotation(rotation*M_PI / 180.0);
        
    }else if (index == 5){
        
        rotation -= 90;
        _animationView.transform = CGAffineTransformMakeRotation(rotation*M_PI / 180.0);
    }
}

- (void)showShare
{
    NSArray *array = [JMBuyHelper isVip] ? @[@"分享", @"取消"]: @[@"去水印", @"分享", @"取消"];
    JMPhotosAlertView *alert = [[JMPhotosAlertView alloc] initWithFrame:CGRectMake(0, kH, kW, alertHeight)];
    alert.titles = array;
    alert.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:backView];
    [backView addSubview:alert];

    [UIView animateWithDuration:0.3 animations:^{

        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        alert.frame = CGRectMake(0, kH-(10+alertHeight*array.count), kW, 10+alertHeight*array.count);
    }];
}

- (void)photoFromSource:(NSInteger)sourceType
{
    if ([JMBuyHelper isVip]) {
        
        [self shareUM];
        
    }else{
        if (sourceType == 200) {
            
            JMBuyProViewController *pro = [[JMBuyProViewController alloc] init];
            JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:pro];
            [self presentViewController:nav animated:YES completion:nil];
        }else if(sourceType == 201){
            
            NSLog(@"non--VIP  分享到微信");
            [self shareUM];
        }
    }
}

#pragma mark -- JMHomeCollectionViewCellDelegate
- (void)shareUM
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareImageAndTextToPlatformType:platformType shareImage:[NSData dataWithContentsOfFile:_filePath]];
    }];
}

// 分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType shareImage:(id)shareImage
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareEmotionObject *gif = [UMShareEmotionObject shareObjectWithTitle:@"来自GifPlay的分享" descr:@"🙃🙃🙃" thumImage:[UIImage imageNamed:@"text"]];
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

- (NSMutableArray *)ramoteImage:(NSMutableArray *)images
{
    NSMutableArray *news = [NSMutableArray array];
    for (UIImage *image in _images) {
        
        [news addObject:[image imageRotatedByDegrees:rotation]];
    }
    
    return news;
}

- (NSMutableArray *)cutImage:(NSMutableArray *)images
{
    NSMutableArray *news = [NSMutableArray array];
    for (UIImage *image in _images) {
        
        [news addObject:[image imageRotatedByDegrees:rotation]];
    }
    
    return news;
}

- (void)dealloc
{
    NSLog(@"JMGetGIFController 销毁");
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
