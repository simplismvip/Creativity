//
//  JMGetGIFController.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMGetGIFController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface JMGetGIFController ()
@property (nonatomic, weak) UIImageView *birdImage;
@property (nonatomic, assign) CGFloat delayTime;
@end

@implementation JMGetGIFController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.delayTime = 1.0;
    UIImageView *birdImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height/2)];
    birdImage.contentMode = UIViewContentModeScaleAspectFit;
    [birdImage setAnimationImages:_images];
    birdImage.animationRepeatCount = 0;
    birdImage.animationDuration = 1.0;
    [birdImage startAnimating];
    
    [self.view addSubview:birdImage];
//    birdImage.backgroundColor = [UIColor grayColor];
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
    [gif setTitle:@"导出GIF" forState:(UIControlStateNormal)];
    [gif addTarget:self action:@selector(creatVideo:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:gif];
}

- (void)creatGIF:(UIButton *)sender
{
    [self makeAnimatedGIF:@"animation.gif" images:_images delayTime:_delayTime];
}

- (void)creatVideo:(UIButton *)sender
{
    [self makeAnimatedGIF:@"animation.gif" images:_images delayTime:_delayTime];
}

- (void)changeDelayTime:(UISlider *)slider
{
    _birdImage.animationRepeatCount = 0;
    _birdImage.animationDuration = 2.0f - (slider.value*2.0+0.01);
    _delayTime = 2.0f - (slider.value*2.0+0.01);
    [_birdImage startAnimating];
}

- (NSURL *)makeAnimatedGIF:(NSString *)name images:(NSArray *)images delayTime:(CGFloat)delayTime
{
    NSUInteger const kFrameCount = images.count;
    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:@{(__bridge id)kCGImagePropertyGIFLoopCount: @0,}};
    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:@{(__bridge id)kCGImagePropertyGIFDelayTime: [NSNumber numberWithFloat:delayTime],}};
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:name];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (UIImage *imagePath in images) {
        
        CGImageDestinationAddImage(destination, imagePath.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        
        NSLog(@"destination");
    }
    
    CFRelease(destination);
    return fileURL;
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
