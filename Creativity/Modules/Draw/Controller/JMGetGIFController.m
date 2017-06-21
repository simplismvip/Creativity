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
//#import "ImageUtil.h"
//#import "ColorMatrix.h"

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
        
    JMGetGIFBottomView *bsae = [[JMGetGIFBottomView alloc] initWithCount:@[@"color_32-1", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black", @"navbar_emoticon_icon_black"]];
    bsae.delegate = self;
    [self.view addSubview:bsae];
    
    [UIView animateWithDuration:0.3 animations:^{bsae.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-74, [UIScreen mainScreen].bounds.size.width, 74);
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

- (void)didSelectRowAtIndexPath:(NSInteger)index
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [JMMediaHelper makeAnimatedGIF:self.filePath images:[self filters:_images type:0] delayTime:_delayTime];
        UIImage *image = [UIImage jm_animatedGIFWithData:[NSData dataWithContentsOfFile:self.filePath]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.birdImage.image = image;
        });
    });
}

- (NSMutableArray *)filters:(NSMutableArray *)images type:(NSInteger)type
{
    NSMutableArray *newImages = [NSMutableArray array];
//    for (UIImage *originImage in images) {
//        
//        UIImage *filterImage = [ImageUtil imageWithImage:originImage withColorMatrix:colormatrix_heibai];
//        [newImages addObject:filterImage];
//    }
    return newImages;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 
 
 
 NSString *str = @"";
 switch (index) {
 case 0:
 str = @"原图";
 self.birdImage.image = [UIImage imageNamed:@"bianjitupian.png"];
 break;
 case 1:
 str = @"LOMO";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_lomo];
 break;
 case 2:
 str = @"黑白";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_heibai];
 break;
 case 3:
 str = @"复古";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_huajiu];
 break;
 case 4:
 str = @"哥特";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_gete];
 break;
 case 5:
 str = @"锐化";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_ruise];
 break;
 case 6:
 str = @"淡雅";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_danya];
 break;
 case 7:
 str = @"酒红";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_jiuhong];
 break;
 case 8:
 str = @"清宁";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_qingning];
 break;
 case 9:
 str = @"浪漫";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_langman];
 break;
 case 10:
 str = @"光晕";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_guangyun];
 break;
 case 11:
 str = @"蓝调";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_landiao];
 break;
 case 12:
 str = @"梦幻";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_menghuan];
 break;
 case 13:
 str = @"夜色";
 self.birdImage.image = [ImageUtil imageWithImage:[UIImage imageNamed:@"bianjitupian.png"] withColorMatrix:colormatrix_yese];
 break;
 
 default:
 break;
 }

 
 
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
