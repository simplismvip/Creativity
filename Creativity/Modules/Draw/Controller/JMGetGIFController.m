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
#import "JMFileManger.h"
#import "UIImage+JMImage.h"
#import "JMGetGIFBottomView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JMFilterItem.h"
#import "JMButtom.h"
#import "JMFrameView.h"
#import "NSTimer+JMAddition.h"
#import "JMGIFAnimationView.h"
#import "JMEditerController.h"

@interface JMGetGIFController ()<JMGetGIFBottomViewDelegate>
{
    NSTimer *_aniTimer;
    BOOL _pause;
    BOOL _isSave;
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
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_animationView stopAnimation];
    [MobClick endLogPageView:@"JMGetGIFController"];
    _frameView.images = nil;
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (JMGIFAnimationView *)animationView
{
    if (!_animationView) {
        
        JMSelf(ws);
        JMGIFAnimationView *aniView = [[JMGIFAnimationView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
        aniView.backgroundColor = [UIColor whiteColor];
        aniView.center = self.view.center;
        aniView.frameChange = ^(NSInteger index) {
            
            [ws.frameView refrashLocation:index];
        };
        
        [self.view insertSubview:aniView belowSubview:_showFps];
        self.animationView = aniView;
    }
    
    return _animationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pause = NO;
    
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
    bsae.sliderA.value = _delayTime;
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
}

- (void)setImages:(NSMutableArray *)images
{
    _images = images;
    self.animationView.imageSource = [images copy];
    _animationView.delayer = _delayTime;
    _frameView.images = self.animationView.imageSource;
}

#pragma mark -- drawVC界面进入
- (void)setImagesFromDrawVC:(NSMutableArray *)imagesFromDrawVC
{
    _imagesFromDrawVC = imagesFromDrawVC;
    
    NSMutableArray *images = [NSMutableArray array];
    for (id model in imagesFromDrawVC) {[images addObject:[model image]];}
    self.images = images;
    
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
    if (_isSave) {
       
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"gif.base.alert.fileNotSave", "") message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *buyVip = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.cancle", "") style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:cancle];
        [alertController addAction:buyVip];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
    NSLog(@"%f", value);
    
    _delayTime = 2-value;
    _animationView.delayer = 2-value;
    
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

- (void)filtersDidSelectRowAtIndexPath:(NSInteger)index
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableArray *newImages = [NSMutableArray array];
        for (UIImage *originImage in _images) {
            
            UIImage *filterImage = [UIImage returnImage:index image:originImage];
            [newImages addObject:filterImage];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            self.images = newImages;
        });
    });
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
            NSMutableArray *newImages = [NSMutableArray array];
            for (UIImage *image in _images) {
                
                if (image.size.width == image.size.width == kW) {
                    
                    [newImages addObject:image]; 
                }else{
                
                    UIImage *newImage = [image drawRectNewImage];
                    [newImages addObject:newImage];
                }
            }
            
            // 总时间
            [JMMediaHelper saveImagesToVideoWithImages:newImages fps:1/_delayTime+1 andVideoPath:videoPath completed:^(NSString *filePath) {
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:filePath] completionBlock:^(NSURL *assetURL, NSError *error) {

                    if (error) {

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [hud hideAnimated:YES];
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            hud.mode = MBProgressHUDModeCustomView;
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"navbar_close_icon_black"]];
                            hud.square = YES;
                            hud.label.text = NSLocalizedString(@"gif.base.alert.Failed", "");
                            [hud hideAnimated:YES afterDelay:1.5f];
                        });

                    } else {

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [hud hideAnimated:YES];
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            hud.mode = MBProgressHUDModeCustomView;
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                            hud.square = YES;
                            hud.label.text = NSLocalizedString(@"gif.base.alert.done", "");
                            [hud hideAnimated:YES afterDelay:1.5f];
                            [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                            _isSave = YES;
                        });
                    }
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
            
            [JMMediaHelper makeAnimatedGIF:_filePath images:_images delayTime:_delayTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                hud.square = YES;
                hud.label.text = NSLocalizedString(@"gif.base.alert.done", "");
                [hud hideAnimated:YES afterDelay:1.5f];
                _isSave = YES;
            });
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
        
        // _imageView.transform = CGAffineTransformMakeScale(-1, 1);
        
    }else if (index == 5){
    
        // _imageView.transform = CGAffineTransformMakeScale(1, -1);
    }
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
