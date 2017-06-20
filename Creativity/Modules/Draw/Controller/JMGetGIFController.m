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

@interface JMGetGIFController ()
@property (nonatomic, weak) UIImageView *birdImage;
@property (nonatomic, assign) CGFloat delayTime;
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
    
    [self configUI];
    [self showGif];
}

// 编辑完成
- (void)Done:(UIBarButtonItem *)done
{
    [self creatGIF:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)Editer:(UIBarButtonItem *)done
{
    JMDrawViewController *draw = [[JMDrawViewController alloc] init];
    [draw creatGif:_images];
    
    // 删除GIF文件
    NSString *string = [NSString stringWithFormat:@"/%@", [_filePath lastPathComponent]];
    draw.folderPath = [_filePath stringByReplacingOccurrencesOfString:string withString:@""];
    
    [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
    [self presentViewController:Nav animated:YES completion:nil];
}

- (void)deleteBtn:(UIBarButtonItem *)done
{
    NSString *string = [NSString stringWithFormat:@"/%@", [_filePath lastPathComponent]];
    [JMFileManger removeFileByPath:[_filePath stringByReplacingOccurrencesOfString:string withString:@""]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUI
{
    if (_isHome) {
    
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:(UIBarButtonItemStyleDone) target:self action:@selector(deleteBtn:)];
        UIBarButtonItem *editer = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(Editer:)];
        self.navigationItem.rightBarButtonItems = @[right, editer];
        
    }else{
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(Done:)];
        self.navigationItem.rightBarButtonItems = @[right];
    }
    
    self.delayTime = 0.5;
    UIImageView *birdImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height/2)];
    [self.view addSubview:birdImage];
    self.birdImage = birdImage;
    
    UISlider *slide = [[UISlider alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(birdImage.frame), self.view.width-60, 30)];
    slide.value = 0.5;
    [slide addTarget:self action:@selector(changeDelayTime:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:slide];
    
    UIButton *video = [UIButton buttonWithType:(UIButtonTypeSystem)];
    video.backgroundColor = [UIColor redColor];
    video.frame = CGRectMake(self.view.width/2-100-20, CGRectGetMaxY(slide.frame)+20, 100, 100);
    [video setTitle:@"导出GIF" forState:(UIControlStateNormal)];
    [video addTarget:self action:@selector(creatGIF:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:video];
    
    UIButton *gif = [UIButton buttonWithType:(UIButtonTypeSystem)];
    gif.backgroundColor = [UIColor redColor];
    gif.frame = CGRectMake(self.view.width/2+20, CGRectGetMaxY(slide.frame)+20, 100, 100);
    [gif setTitle:@"导出Video" forState:(UIControlStateNormal)];
    [gif addTarget:self action:@selector(creatVideo:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:gif];
}

// 修改gif帧数
- (void)changeDelayTime:(UISlider *)slider
{
    _delayTime = 1.0f - (slider.value*1.0+0.01);
    [self showGif];
}

- (void)showGif
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [JMMediaHelper makeAnimatedGIF:self.filePath images:_images delayTime:_delayTime];
        
        UIImage *image = [UIImage jm_animatedGIFWithData:[NSData dataWithContentsOfFile:self.filePath]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.birdImage.image = image;
        });
    });
}

#pragma mark -----------生成文件------
// 创建Gif文件
- (void)creatGIF:(UIButton *)sender
{
    [JMMediaHelper makeAnimatedGIF:self.filePath images:_images delayTime:_delayTime];
}

// 创建Video文件
- (void)creatVideo:(UIButton *)sender
{
    [self.filePath stringByReplacingOccurrencesOfString:@"gif" withString:@"mp4"];
    [JMMediaHelper saveImagesToVideoWithImages:_images andVideoPath:self.filePath completed:^(NSString *filePath) {
        
        NSLog(@"成功--%@", filePath);
        
    } andFailed:^(NSError *error) {
        
        NSLog(@"失败--%@", error);
    }];
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
