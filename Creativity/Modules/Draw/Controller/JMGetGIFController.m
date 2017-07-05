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

@interface JMGetGIFController ()<JMGetGIFBottomViewDelegate>
{
    NSTimer *_aniTimer;
    BOOL _pause;
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMGetGIFController"];
}

- (JMGIFAnimationView *)animationView
{
    if (!_animationView) {
        
        JMGIFAnimationView *aniView = [[JMGIFAnimationView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
        aniView.backgroundColor = [UIColor whiteColor];
        aniView.center = self.view.center;
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
    frameView.delayTimer = _delayTime;
    frameView.layer.borderColor = JMBaseColor.CGColor;
    frameView.layer.borderWidth = 3;
    [self.view addSubview:frameView];
    self.frameView = frameView;
    
    // 底部菜单显示
    JMGetGIFBottomView *bsae = [[JMGetGIFBottomView alloc] initWithFrame:CGRectMake(0, kH, kW, 74)];
    bsae.subViews = @[@"filter", @"navbar_video_icon_disabled_black", @"gif", @"navbar_pause_icon_black", @"turn_Left", @"turn_Right"];
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
}

#pragma mark -- drawVC界面进入
- (void)setImagesFromDrawVC:(NSMutableArray *)imagesFromDrawVC
{
    _imagesFromDrawVC = imagesFromDrawVC;
    self.images = imagesFromDrawVC;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(Done:)];
    self.navigationItem.rightBarButtonItems = @[right];
}

#pragma mark -- home界面进入
- (void)setImagesFromHomeVC:(NSMutableArray *)imagesFromHomeVC
{
    _imagesFromHomeVC = imagesFromHomeVC;
    self.images = imagesFromHomeVC;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:(UIBarButtonItemStyleDone) target:self action:@selector(deleteBtn:)];
    UIBarButtonItem *editer = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(Editer:)];
    self.navigationItem.rightBarButtonItems = @[right, editer];
}

// 创作选项弹出，保存第一次生成GIF文件
- (void)Done:(UIBarButtonItem *)done
{
    [JMMediaHelper makeAnimatedGIF:self.filePath images:_images delayTime:(1.0-_delayTime)];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 1> 开始编辑
- (void)Editer:(UIBarButtonItem *)done
{
    JMDrawViewController *draw = [[JMDrawViewController alloc] init];
    [draw initPaintBoard:self images:_images];
    
    // 删除GIF文件
    NSString *string = [NSString stringWithFormat:@"/%@", [_filePath lastPathComponent]];
    draw.folderPath = [_filePath stringByReplacingOccurrencesOfString:string withString:@""];
    
    [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
    [self presentViewController:Nav animated:YES completion:nil];
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
    
    _delayTime = value;
    _frameView.delayTimer = 1-value;
    _animationView.delayer = _frameView.delayTimer;
    
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
    [self.showFps setTitle:[NSString stringWithFormat:@"%ld Fps", (NSInteger)(10*progress+1)] forState:(UIControlStateNormal)];
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

- (void)didSelectRowAtIndexPath:(NSInteger)index
{
    if (index == 1){
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSString *videoPath = [self.filePath stringByReplacingOccurrencesOfString:@"gif" withString:@"mp4"];
            
            [JMMediaHelper saveImagesToVideoWithImages:_images fps:(10*_delayTime+1) andVideoPath:videoPath completed:^(NSString *filePath) {
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:filePath] completionBlock:^(NSURL *assetURL, NSError *error) {

                    if (error) {

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [hud hideAnimated:YES];
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            hud.mode = MBProgressHUDModeCustomView;
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"navbar_close_icon_black"]];
                            hud.square = YES;
                            hud.label.text = @"失败";
                            [hud hideAnimated:YES afterDelay:1.5f];
                        });

                    } else {

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [hud hideAnimated:YES];
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            hud.mode = MBProgressHUDModeCustomView;
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                            hud.square = YES;
                            hud.label.text = @"完成";
                            [hud hideAnimated:YES afterDelay:1.5f];
                            [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
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
            
            [JMMediaHelper makeAnimatedGIF:_filePath images:_images delayTime:(1.0-_delayTime)];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                hud.square = YES;
                hud.label.text = @"完成";
                [hud hideAnimated:YES afterDelay:1.5f];
            });
        });
        
    }else if (index == 3){
        
        UIButton *btn = [self.bsae viewWithTag:index+200];
        
        if (_pause) {
        
            [btn setImage:[UIImage imageNamed:@"navbar_pause_icon_black"] forState:(UIControlStateNormal)];
            [_animationView restartAnimation];
            [_frameView restartAnimation];
        }else {
        
            [btn setImage:[UIImage imageNamed:@"navbar_play_icon"] forState:(UIControlStateNormal)];
            [_animationView pauseAnimation];
            [_frameView pauseAnimation];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JMFrameViewStopTimer" object:nil];
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
