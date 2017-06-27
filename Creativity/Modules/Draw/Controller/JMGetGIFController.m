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

@interface JMGetGIFController ()<JMGetGIFBottomViewDelegate>
@property (nonatomic, weak) UIButton *showFps;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JMGetGIFBottomView *bsae = [[JMGetGIFBottomView alloc] initWithFrame:CGRectMake(0, kH, kW, 74)];
    bsae.subViews = @[@"color_32-1", @"navbar_video_icon_disabled_black", @"gif_32px_1136116", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black"];
    bsae.delegate = self;
    bsae.sliderA.value = _delayTime;
    [self.view addSubview:bsae];
    [UIView animateWithDuration:0.3 animations:^{bsae.frame = CGRectMake(0, kH-74, kW, 74);}];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.view.center;
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
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
    
    if (_delayTime>0) {
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:(UIBarButtonItemStyleDone) target:self action:@selector(deleteBtn:)];
        UIBarButtonItem *editer = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(Editer:)];
        self.navigationItem.rightBarButtonItems = @[right, editer];
        
    }else{
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(Done:)];
        self.navigationItem.rightBarButtonItems = @[right];
        
        // 创建GIF文件
        [self creatNewGIF:_filePath];
    }
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
    [draw presentDrawViewController:self images:_images];
    
    // 删除GIF文件
    NSString *string = [NSString stringWithFormat:@"/%@", [_filePath lastPathComponent]];
    draw.folderPath = [_filePath stringByReplacingOccurrencesOfString:string withString:@""];
    
    [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
    [self presentViewController:Nav animated:YES completion:nil];
}

// JMDrawViewController点击编辑界面完成返回JMGetGIFController界面
- (void)dismissFromDrawViewController
{
    [self creatNewGIF:_filePath];
}

// 编辑界面，删除GIF文件
- (void)deleteBtn:(UIBarButtonItem *)done
{
    NSString *string = [NSString stringWithFormat:@"/%@", [_filePath lastPathComponent]];
    [JMFileManger removeFileByPath:[_filePath stringByReplacingOccurrencesOfString:string withString:@""]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatNewGIF:(NSString *)GIFPath
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [JMMediaHelper makeAnimatedGIF:GIFPath images:_images delayTime:(1.0-_delayTime)];
        UIImage *image = [UIImage jm_animatedGIFWithData:[NSData dataWithContentsOfFile:GIFPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.imageView.image = image;
        });
    });
}

#pragma mark -----------生成文件------
- (void)creatGIF:(UIButton *)sender
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSData dataWithContentsOfFile:self.filePath]] applicationActivities:nil];
    
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        
        if (IS_IPAD) {
            
            UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
            if (popover){popover.sourceView = sender;popover.sourceRect = sender.bounds;}
            
        }else{
            
            activityViewController.popoverPresentationController.sourceView = self.view;
        }
    }
    
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

#pragma mark -- JMGetGIFBottomViewDelegate
- (void)changeValue:(CGFloat)value
{
    NSLog(@"%f", value);
    
    _delayTime = value;
    [self creatNewGIF:_filePath];
    [UIView animateWithDuration:.5 animations:^{
        
        _showFps.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        _showFps.hidden = YES;
        _showFps.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)changeValueSerial:(CGFloat)progress
{
    _showFps.hidden = NO;
    [self.showFps setTitle:[NSString stringWithFormat:@"%ld Fps", (NSInteger)(10*progress+1)] forState:(UIControlStateNormal)];
}

- (void)filtersDidSelectRowAtIndexPath:(NSInteger)index
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        _images = [self filters:_images type:index];
        [JMMediaHelper makeAnimatedGIF:self.filePath images:[_images copy] delayTime:(1.0-_delayTime)];
        UIImage *image = [UIImage jm_animatedGIFWithData:[NSData dataWithContentsOfFile:self.filePath]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = image;
        });
    });
}

- (void)didSelectRowAtIndexPath:(NSInteger)index
{
    if (index == 0) {
        
    }else if (index == 1){
    
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
                            [hud hideAnimated:YES afterDelay:1.f];
                        });

                    } else {

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [hud hideAnimated:YES];
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            hud.mode = MBProgressHUDModeCustomView;
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                            hud.square = YES;
                            hud.label.text = @"完成";
                            [hud hideAnimated:YES afterDelay:1.f];
                            [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                            
                        });
                    }
                }];
                
            } andFailed:^(NSError *error) {
                
                NSLog(@"fail");
            }];
        });
        
    }else if (index == 2){
        
        [self creatNewGIF:_filePath];
        
    }else if (index == 3){
        
    }
}

- (NSMutableArray *)filters:(NSMutableArray *)images type:(NSInteger)type
{
    NSMutableArray *newImages = [NSMutableArray array];
    
    if (type<14) {
       
        for (UIImage *originImage in images) {
            NSLog(@"%@", NSStringFromCGSize(originImage.size));
            UIImage *filterImage = [UIImage returnImage:type image:originImage];
            NSLog(@"%@", NSStringFromCGSize(filterImage.size));
            [newImages addObject:filterImage];
        }
    }else{
    
        for (UIImage *originImage in images) {
            
            NSLog(@"%@", NSStringFromCGSize(originImage.size));
            UIImage *filterImage = [images.firstObject defaultFilter:type-14];
            
            NSData *data = UIImageJPEGRepresentation(filterImage, 0.5);
            [data writeToFile:[NSString stringWithFormat:@"/Users/mac/Desktop/home/%ld.jpg", type-14] atomically:YES];
            
            NSLog(@"%@", NSStringFromCGSize(filterImage.size));
            
            [newImages addObject:filterImage];
        }
    }
    
    return newImages;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    // Dispose of any resources that can be recreated.
}

//            [JMMediaHelper compressImages:_images inputPath:videoPath fps:_delayTime completion:^(NSURL *outurl) {
//

//            }];

/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
