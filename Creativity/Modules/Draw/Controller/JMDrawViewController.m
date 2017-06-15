//
//  JMDrawViewController.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/9.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMDrawViewController.h"
#import "JMPaintView.h"
#import "JMWriteView.h"
#import "JMGetGIFController.h"
#import "JMCreatPaintView.h"
#import "UIImage+JMImage.h"
#define kMargin 5.0

@interface JMDrawViewController ()<JMCreatPaintViewDelegate>
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, weak) JMPaintView *paintView;
@property (nonatomic, weak) JMCreatPaintView *paint;

@property (nonatomic, strong) NSMutableArray *subViews;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *paintData;
@property (nonatomic, strong) NSMutableArray *paintBuff;
@end

@implementation JMDrawViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    // 首先创建画图View, 创建接收消息方法
    self.subViews = [NSMutableArray array];
    self.paintBuff = [NSMutableArray array];
    self.paintData = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.leftImage = @"navbar_close_icon_black";
    self.rightImage = @"navbar_next_icon_black";
}

- (void)creatGifNew
{
    JMPaintView *pView = [[JMPaintView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.paint.frame)+kMargin, self.view.width, self.view.width)];
    pView.drawType = JMPaintToolTypePen;
    pView.lineDash = NO;
    self.paintView = pView;
    [self.view addSubview:pView];
    [self.subViews addObject:pView];
    [self.paint reloadData:pView.image];
}

- (void)creatGif:(NSArray *)images
{
    [self.view addSubview:self.paint];
    for (UIImage *image in images) {
        
        JMPaintView *pView = [[JMPaintView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.paint.frame)+kMargin, self.view.width, self.view.width)];
        pView.drawType = JMPaintToolTypePen;
        pView.lineDash = NO;
        pView.image = image;
        self.paintView = pView;
        [self.view addSubview:pView];
        [self.subViews addObject:pView];
        [self.paint reloadData:image];
    }
}

- (void)setItem:(UIBarButtonItem *)sender
{
//    JMPaintView *paint = self.paintView;
//    UIImage *image = [UIImage imageWithCaptureView:self.view rect:paint.frame];
//    UIImage *thubim = [image imageCompressForSize:image targetSize:CGSizeMake(64, 106)];
//    NSData *data = UIImageJPEGRepresentation(thubim, 0.1);
//    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)newItem:(UIBarButtonItem *)sender
{
    JMGetGIFController *gif = [[JMGetGIFController alloc] init];
    gif.folderPath = self.folderPath;
    
    NSMutableArray *images = [NSMutableArray array];
    for (JMPaintView *paint in self.subViews) {
        
        if (paint.image) {
        
            [images addObject:paint.image];
        }else{
        
//            UIImage *image = [UIImage];
            [images addObject:paint.image];
        }
    }
    
    gif.images = images;
    [self.navigationController pushViewController:gif animated:YES];
}

- (void)newCallback
{
    [self creatGifNew];
}

- (void)touchItem:(NSInteger)index
{
    [self.view bringSubviewToFront:self.subViews[index]];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    JMLog(@"内存警告 -- didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    JMLog(@"JMDrawViewController - 销毁");
}

- (JMCreatPaintView *)paint
{
    if (!_paint) {
        
        JMCreatPaintView *paint = [[JMCreatPaintView alloc] initWithFrame:CGRectMake(0, 44+kMargin, self.view.width, 44)];
        paint.delegate = self;
        paint.backgroundColor = [UIColor grayColor];
        [self.view addSubview:paint];
        self.paint = paint;
    }
    
    return _paint;
}

/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
