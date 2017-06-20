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

@interface JMGetGIFController ()<JMGetGIFBottomViewDelegate>
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
    [JMMediaHelper makeAnimatedGIF:self.filePath images:_images delayTime:_delayTime];
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
    UIImageView *birdImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*1.2)];
    birdImage.contentMode = UIViewContentModeScaleAspectFit;
    birdImage.center = self.view.center;
    birdImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:birdImage];
    self.birdImage = birdImage;
        
    JMGetGIFBottomView *bsae = [[JMGetGIFBottomView alloc] initWithCount:@[@"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black"]];
    bsae.delegate = self;
    [self.view addSubview:bsae];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        bsae.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-74, [UIScreen mainScreen].bounds.size.width, 74);
    }];
    
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

// 创建Video文件
- (void)creatVideo:(UIButton *)sender
{
    [self.filePath stringByReplacingOccurrencesOfString:@"gif" withString:@"mp4"];
    
    NSMutableArray *paths = [NSMutableArray array];
    for (UIImage *image in _images) {
        
        NSString *path = [NSString stringWithFormat:@"%@/%@.png", JMDocumentsPath, [JMHelper timerString]];
        [paths addObject:path];
        
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
    
    [JMMediaHelper saveImagesToVideoWithImages:paths completed:^(NSString *filePath) {
        
        NSLog(@"成功--%@", filePath);
        
    } andFailed:^(NSError *error) {
        
        NSLog(@"失败--%@", error);
    }];
}

- (void)changeValue:(CGFloat)value
{
    _delayTime = value;
    [self showGif];
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
