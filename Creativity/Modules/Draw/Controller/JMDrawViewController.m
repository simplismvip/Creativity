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
#import "JMTopTableView.h"
#import "UIImage+JMImage.h"
#import "JMMembersView.h"
#import "JMHelper.h"
#import "JMMembersView.h"
#import "JMAttributeTextInputView.h"
#import "JMAnimationView.h"
#import "JMEmojiAnimationView.h"
#import "JMSubImageModel.h"
#import <UMMobClick/MobClick.h>
#import "JMPopView.h"
#import "JMTopBarModel.h"
#import "JMBottomModel.h"
#import "Masonry.h"
#import <UShareUI/UShareUI.h>
#import "JMSlider.h"

#define kMargin 10.0

@interface JMDrawViewController ()<JMTopTableViewDelegate,UMSocialShareMenuViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) JMPaintView *paintView;
@property (nonatomic, weak) JMSlider *slider;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, strong) JMGetGIFController *GIFController;
@property (nonatomic, strong) NSMutableArray *subViews;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *memberViewData;
@property (nonatomic, strong) NSMutableArray *memberViewBuff;
@end

@implementation JMDrawViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = JMColor(41, 41, 41);
    [MobClick beginLogPageView:@"JMDrawViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMDrawViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的画板";
    
    // 首先创建画图View, 创建接收消息方法
    self.subViews = [NSMutableArray array];
    self.memberViewBuff = [NSMutableArray array];
    self.memberViewData = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    
    JMSlider *slider = [[JMSlider alloc] initWithFrame:CGRectMake(10, (self.view.height/2-self.view.width/2+64)*0.5-15, self.view.width-20, 30)];
    slider.slider.value = 1.0;
    JMSelf(ws);
    slider.value = ^(JMSlider *value) {ws.paintView.alpha = value.sValue;};
    [self.view addSubview:slider];
    self.slider = slider;
    
    // 这里创建bottomView
    self.dataSource = [JMHelper getTopBarModel];
    JMTopTableView *topbar = [[JMTopTableView alloc] initWithFrame:CGRectMake(0, kH-44, kW, 44)];
    topbar.delegate = self;
    topbar.dataSource = _dataSource;
    [self.view addSubview:topbar];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    shareBtn.tintColor = JMBaseColor;
    shareBtn.layer.borderColor = JMColor(51, 51, 51).CGColor;
    shareBtn.layer.borderWidth = 2;
    shareBtn.backgroundColor = JMColor(31, 31, 31);
    shareBtn.layer.cornerRadius = 22;
    shareBtn.layer.masksToBounds = YES;
    [shareBtn setImage:[UIImage imageWithTemplateName:@"navbar_share_icon_black"] forState:(UIControlStateNormal)];
    shareBtn.frame = CGRectMake(10, CGRectGetMinY(topbar.frame)-74, 44, 44);
    [shareBtn addTarget:self action:@selector(shareCurrentImage:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:shareBtn];
    
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Sina),]];
    
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

- (void)initPaintBoard:(JMGetGIFController *)parentController images:(NSArray *)images
{
    if (parentController) {
        
        self.GIFController = parentController;
        self.rightTitle = @"完成";
        
        for (UIImage *image in images) {
            
            JMPaintView *pView = [[JMPaintView alloc] init];
            pView.drawType = (JMPaintToolType)[StaticClass getPaintType];
            pView.lineDash = [StaticClass getDashType];
            pView.paintText = [StaticClass getPaintText];
            pView.paintImage = [StaticClass getPaintImage];
            pView.image = image;
            self.paintView = pView;
            [self.view addSubview:pView];
            [self.subViews addObject:pView];
            
            [pView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
                make.width.height.mas_equalTo(self.view.width);
            }];
        }
    }else{
        self.leftImage = @"navbar_close_icon_black";
        self.rightImage = @"navbar_next_icon_black";
        JMPaintView *pView = [[JMPaintView alloc] init];
        pView.drawType = (JMPaintToolType)[StaticClass getPaintType];
        pView.lineDash = [StaticClass getDashType];
        pView.paintText = [StaticClass getPaintText];
        pView.paintImage = [StaticClass getPaintImage];
        self.paintView = pView;
        [self.view addSubview:pView];
        [self.subViews addObject:pView];
        
        [pView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(self.view.width);
        }];
    }
}

- (void)leftImageAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 完成按钮
- (void)rightTitleAction:(UIBarButtonItem *)sender
{
    NSMutableArray *images = [NSMutableArray array];
    for (JMPaintView *memberView in self.subViews) {
        
        UIImage *imageNew = [UIImage imageWithCaptureView:memberView rect:CGRectMake(0, 0, kW, kW)];
        [images addObject:imageNew];
    }
    
    self.GIFController.imagesFromDrawVC = images;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 进入getGIF界面
- (void)rightImageAction:(UIBarButtonItem *)sender
{
    if (self.subViews.count>2) {
    
        JMGetGIFController *gif = [[JMGetGIFController alloc] init];
        gif.filePath = [self.folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
        
        NSMutableArray *images = [NSMutableArray array];
        for (JMPaintView *memberView in self.subViews) {
            
            UIImage *imageNew = [UIImage imageWithCaptureView:memberView rect:CGRectMake(0, 0, kW, kW)];
            [images addObject:imageNew];
        }
        gif.delayTime = 0.5;
        gif.imagesFromDrawVC = images;
        [self.navigationController pushViewController:gif animated:YES];
    }else{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"生成Gif/Video所需照片必须大于1" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        [self configiPad:alertController];
    }
}

#pragma mark -- ****************JMTopTableViewDelegate
- (void)topTableView:(JMBottomType)bottomType didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *title = nil;
    
    JMTopBarModel *tModel = self.dataSource[indexPath.section];
    if (tModel.models.count == 1) {
        
        title = tModel.title;
    }else{
    
        JMBottomModel *bModel = [_dataSource[indexPath.section] models][row];
        title = bModel.title;
    }
    
    if (bottomType == JMTopBarTypeAdd){
        
        _slider.slider.value = 1.0;
        [JMPopView popView:self.view title:title];
        JMPaintView *pView = [[JMPaintView alloc] init];
        pView.drawType = (JMPaintToolType)[StaticClass getPaintType];
        pView.lineDash = [StaticClass getDashType];
        pView.paintText = [StaticClass getPaintText];
        pView.paintImage = [StaticClass getPaintImage];
        
        self.paintView = pView;
        [self.view addSubview:pView];
        [self.subViews addObject:pView];
        
        [pView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(self.view.width);
            // make.height.mas_equalTo(self.view.width*1.2);
        }];
        
    }else if (bottomType == JMTopBarTypeLayerManger){
        
        [JMPopView popView:self.view title:title];
        [JMMembersView initMemberDataArray:self.subViews isEditer:NO addDelegate:self];
        
    }else if (bottomType == JMTopBarTypePaint){
        
        [JMPopView popView:self.view title:title];
        _paintView.drawType = (JMPaintToolType)row;
        [StaticClass setPaintType:row];
        
        if (row == 5){
            
            JMSelf(ws);
            JMEmojiAnimationView *animation = [[JMEmojiAnimationView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:animation];
            animation.animationBlock = ^(id model) {
                
                JMSubImageModel *emojiModel = (JMSubImageModel *)model;
                ws.paintView.paintImage = emojiModel.name;
                [StaticClass setPaintImage:emojiModel.name];
            };
            
            [UIView animateWithDuration:0.3 animations:^{animation.alpha = 1.0;}];
            
        }else if (row == 6){
            
            JMSelf(ws);
            JMAttributeTextInputView *attribute = [[JMAttributeTextInputView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 44)];
            attribute.textViewMaxLine = 5;
            attribute.placeholderLabel.text = @"请输入...";
            attribute.inputAttribute = ^(NSString *sendContent) {ws.paintView.paintText = sendContent;[StaticClass setPaintText:sendContent];};
            [self.view addSubview:attribute];
            [attribute.textInput becomeFirstResponder];
        }
        
    }else if (bottomType == JMTopBarTypeClear && row==0){
        
        [JMPopView popView:self.view title:title];
        [_paintView undoLatestStep];

    }else if (bottomType == JMTopBarTypeClear && row==1){
        
        [JMPopView popView:self.view title:title];
        [_paintView clearAll];
        
    }else if (bottomType == JMTopBarTypeClear && row==2){
        
        [JMPopView popView:self.view title:title];
        [_paintView redoLatestStep];
        
    }else if (bottomType == JMTopBarTypeNote && row==0){
        
        [JMPopView popView:self.view title:title];
        _paintView.lineDash = !_paintView.lineDash;
        [StaticClass setDashType:_paintView.lineDash];
        
    }else if (bottomType == JMTopBarTypeNote && row==1){
        
        [JMPopView popView:self.view title:title];
        _paintView.isFill = !_paintView.isFill;
        [StaticClass setFillType:_paintView.isFill];
    }else if (bottomType == JMTopBarTypeNote && row==2){
        
        if ([_paintView canUndo]) {
        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此时添加图片将清除当前画板内容" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            [alertController addAction:[UIAlertAction actionWithTitle:@"依然添加" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
                [self getImageFromLibrary];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消添加" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            [self configiPad:alertController];
        }else{
        
            [self getImageFromLibrary];
        }
        
    }else if (bottomType == JMTopBarTypeColor){
        
        JMAnimationView *animation = [[JMAnimationView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:animation];
        [UIView animateWithDuration:0.3 animations:^{animation.alpha = 1.0;}];
    }
}

- (void)moveCoverageAtIndexPath:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    JMPaintView *from = self.subViews[fromIndex];
    JMPaintView *to = self.subViews[toIndex];
    [self.view insertSubview:from aboveSubview:to];
    
    [self.subViews removeObjectAtIndex:fromIndex];
    [self.subViews insertObject:from atIndex:toIndex];
}

- (void)removeCoverageAtIndex:(NSInteger)index
{
    JMPaintView *pView = self.subViews[index];
    [pView removeFromSuperview];
    [self.subViews removeObjectAtIndex:index];
}

- (void)hideCoverageAtIndex:(NSInteger)index isHide:(BOOL)isHide
{
    JMPaintView *pView = self.subViews[index];
    pView.hidden = isHide;
}

#pragma mark -- ****************初始化图片选择器
- (void)getImageFromLibrary
{
    JMSelf(ws);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    // 相机
    [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {[ws initImagePicker:1];}
    }]];
    
    // 相册
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {[ws initImagePicker:0];}
    }]];
    
    // 取消
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    [self configiPad:alertController];
}

#pragma mark -- 初始化图片选择器
- (void)initImagePicker:(NSInteger)number
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64);
    picker.delegate = self;
    picker.sourceType = number;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    JMPaintView *pView = self.subViews.firstObject;
    pView.image = image;
    [pView setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 添加代码，处理选中图像又取消的情况
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareCurrentImage:(UIButton *)sender
{
    JMPaintView *pView = self.subViews.firstObject;
    
    if (pView.image) {
        
        [self showBottomCircleView:[pView.image imageWithWaterMask]];
    }else{
        UIImage *image = [UIImage imageWithCaptureView:pView rect:CGRectMake(0, 0, kW, kW)];
        [self showBottomCircleView:[image imageWithWaterMask]];
    }
}

// 这个比较好
- (void)showBottomCircleView:(id)shareImage
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareImageAndTextToPlatformType:platformType shareImage:shareImage];
    }];
}

//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType shareImage:(id)shareImage
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.thumbImage = [UIImage imageNamed:@"logo"];
    shareObject.shareImage = shareImage;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
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

- (void)configiPad:(UIAlertController *)alertController
{
    if (IS_IPAD) {
        
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        
        if (popover){
            popover.sourceView = self.navigationController.navigationBar;
            popover.sourceRect = self.navigationController.navigationBar.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
    }
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"JMDrawViewController销毁 %s", __FUNCTION__);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    // Dispose of any resources that can be recreated.
}

/*
 NSInteger row = indexPath.row;

 
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
