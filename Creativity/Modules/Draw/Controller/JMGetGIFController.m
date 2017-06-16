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

@interface JMGetGIFController ()
@property (nonatomic, weak) UIImageView *birdImage;
@property (nonatomic, assign) CGFloat delayTime;
@end

@implementation JMGetGIFController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self configUI];
}

- (void)creatGIF:(UIButton *)sender
{
    NSString *gifName = [NSString stringWithFormat:@"%@.gif", [JMHelper timerString]];
    [JMMediaHelper makeAnimatedGIF:[self.folderPath stringByAppendingPathComponent:gifName] images:_images delayTime:_delayTime];
}

- (void)creatVideo:(UIButton *)sender
{
    NSString *gifName = [NSString stringWithFormat:@"%@.mp4", [JMHelper timerString]];
    [JMMediaHelper saveImagesToVideoWithImages:_images andVideoPath:[self.folderPath stringByAppendingPathComponent:gifName] completed:^(NSString *filePath) {
        
        NSLog(@"成功--%@", filePath);
        
    } andFailed:^(NSError *error) {
        
        NSLog(@"失败--%@", error);
    }];
}

- (void)Done:(UIBarButtonItem *)done
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)Editer:(UIBarButtonItem *)done
{
    JMDrawViewController *draw = [[JMDrawViewController alloc] init];
    draw.folderPath = _folderPath;
    draw.fromGif = YES;
    [draw creatGifNew];
    JMMainNavController *Nav = [[JMMainNavController alloc] initWithRootViewController:draw];
    [self presentViewController:Nav animated:YES completion:nil];
}

- (void)changeDelayTime:(UISlider *)slider
{
    _birdImage.animationRepeatCount = 0;
    _birdImage.animationDuration = 2.0f - (slider.value*2.0+0.01);
    _delayTime = 2.0f - (slider.value*2.0+0.01);
    [_birdImage startAnimating];
}

- (void)configUI
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(Done:)];
    if (_isHome) {
    
        UIBarButtonItem *editer = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(Editer:)];
        self.navigationItem.rightBarButtonItems = @[right, editer];
    }else{
        self.navigationItem.rightBarButtonItems = @[right];
    }
    
    self.delayTime = 1.0;
    UIImageView *birdImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height/2)];
    birdImage.contentMode = UIViewContentModeScaleAspectFit;
    [birdImage setAnimationImages:_images];
    birdImage.animationRepeatCount = 0;
    birdImage.animationDuration = 1.0;
    [birdImage startAnimating];
    [self.view addSubview:birdImage];
    
    birdImage.backgroundColor = [UIColor redColor];
    self.birdImage = birdImage;
    
    UISlider *slide = [[UISlider alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(birdImage.frame), self.view.width-60, 30)];
    [slide addTarget:self action:@selector(changeDelayTime:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slide];
    
    UIButton *video = [UIButton buttonWithType:(UIButtonTypeSystem)];
    video.backgroundColor = [UIColor grayColor];
    video.frame = CGRectMake(self.view.width/2-100-20, CGRectGetMaxY(slide.frame), 100, 100);
    [video setTitle:@"导出GIF" forState:(UIControlStateNormal)];
    [video addTarget:self action:@selector(creatGIF:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:video];
    
    UIButton *gif = [UIButton buttonWithType:(UIButtonTypeSystem)];
    gif.backgroundColor = [UIColor grayColor];
    gif.frame = CGRectMake(self.view.width/2+20, CGRectGetMaxY(slide.frame), 100, 100);
    [gif setTitle:@"导出Video" forState:(UIControlStateNormal)];
    [gif addTarget:self action:@selector(creatVideo:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:gif];
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
