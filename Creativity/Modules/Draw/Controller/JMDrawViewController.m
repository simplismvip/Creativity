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
#import "JMPhotosAlertView.h"
#import "JMEditerSuperView.h"

#define kMargin 10.0

@interface JMDrawViewController ()<JMPhotosAlertViewDelegate,JMTopTableViewDelegate,UMSocialShareMenuViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) JMPaintView *paintView;
@property (nonatomic, weak) JMSlider *slider;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, strong) JMGetGIFController *GIFController;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *memberViewData;
@property (nonatomic, strong) NSMutableArray *cacheArray;
@property (nonatomic, weak) UIImageView *imageView;
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
    
    // 缓存
    self.cacheArray = [NSMutableArray array];
    
    self.memberViewData = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    
    JMSelf(ws);
    JMSlider *slider = [[JMSlider alloc] initWithFrame:CGRectMake(10, (self.view.height/2-self.view.width/2+64)*0.5-15, self.view.width-20, 30)];
    slider.slider.value = 1.0;
    slider.value = ^(JMSlider *value) {ws.paintView.alpha = value.sValue;};
    [self.view addSubview:slider];
    self.slider = slider;
    
//    slider.dragUpEnd = ^(BOOL hide) {
//        
//        ws.imageView.hidden = hide;
//        
//    };
    
    slider.dragUp = ^(BOOL hide) {
        
        NSInteger index = ws.cacheArray.count;
        if (index>0) {
         
//            ws.imageView.hidden = hide;
            ws.imageView.image = ws.cacheArray[index-1];
        }
    };

    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(self.view.width);
    }];
    
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
    JMPaintView *pView = [[JMPaintView alloc] init];
    pView.drawType = (JMPaintToolType)[StaticClass getPaintType];
    pView.lineDash = [StaticClass getDashType];
    pView.paintText = [StaticClass getPaintText];
    pView.paintImage = [StaticClass getPaintImage];
    self.paintView = pView;
    [self.view addSubview:pView];
    
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(self.view.width);
    }];

    self.leftImage = @"navbar_close_icon_black";
    self.rightImage = @"navbar_next_icon_black";
}

- (void)leftImageAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 进入getGIF界面
- (void)rightImageAction:(UIBarButtonItem *)sender
{
    if (_cacheArray.count>1) {
    
        JMGetGIFController *gif = [[JMGetGIFController alloc] init];
        gif.filePath = [_folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
        gif.delayTime = 0.7;
        gif.imagesFromDrawVC = _cacheArray;
        [self.navigationController pushViewController:gif animated:YES];
        
    }else{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"gif.base.alert.moreThanTwo", "") message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        [self configiPad:alertController];
    }
}

#pragma mark -- ****************JMTopTableViewDelegate
- (void)topTableView:(JMBottomType)bottomType didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *title = nil;
    
    JMTopBarModel *tModel = _dataSource[indexPath.section];
    if (tModel.models.count == 1) {
        
        title = tModel.title;
    }else{
    
        JMBottomModel *bModel = [_dataSource[indexPath.section] models][row];
        title = bModel.title;
    }
    
    if (bottomType == JMTopBarTypeAdd){
        
#pragma mark -- 这里也可以优化, 没必要每次都创建, 创建新的View时原来的保存下来就是
        if (_cacheArray.count<11) {
            
            _slider.slider.value = 1.0;
            [JMPopView popView:self.view title:title];
            
            UIImage *imageNew = _paintView.image; //[UIImage imageWithCaptureView:_paintView rect:CGRectMake(0, 0, kW, kW)];
            [_cacheArray addObject:imageNew];
            [_paintView clearAll];
            _imageView.image = imageNew;
            
        }else{
        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"gif.base.alert.picLessTen", "") message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *buyVip = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.getVIP", "") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                [JMBuyHelper getVip];
            }];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.cancle", "") style:(UIAlertActionStyleDefault) handler:nil]];
            [alertController addAction:buyVip];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }else if (bottomType == JMTopBarTypeLayerManger){
        
        [JMPopView popView:self.view title:title];
        [JMMembersView initMemberDataArray:_cacheArray isEditer:NO addDelegate:self];
        
    }else if (bottomType == JMTopBarTypePaint){
        
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
            attribute.placeholderLabel.text = NSLocalizedString(@"gif.base.alert.inputContent", "");
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
        
            JMSelf(ws);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"gif.base.alert.cleanAllContent", "") message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.Addpic", "") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
//                UIImage *imageNew = [UIImage imageWithCaptureView:_paintView rect:CGRectMake(0, 0, kW, kW)];
                [ws.cacheArray addObject:_paintView.image];
                [ws.paintView clearAll];
                [ws getImageFromLibrary];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.cancle", "") style:(UIAlertActionStyleDefault) handler:nil]];
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
//    if (fromIndex == _cacheArray.count-1) {
//        
//        
//    }
//    
//    JMPaintView *from = self.subViews[fromIndex];
//    JMPaintView *to = self.subViews[toIndex];
//    [self.view insertSubview:from aboveSubview:to];
//    
//    [self.subViews removeObjectAtIndex:fromIndex];
//    [self.subViews insertObject:from atIndex:toIndex];
}

- (void)removeCoverageAtIndex:(NSInteger)index
{
    if (index==_cacheArray.count-1) {
        
        [_paintView clearAll];
        _paintView.image = _cacheArray[index-1];
    }
    
    [_cacheArray removeObjectAtIndex:index];
}

- (void)editerAtIndex:(NSInteger)index frame:(CGRect)frame
{
    JMSelf(ws);
    JMEditerSuperView *image = [[JMEditerSuperView alloc] initWithFrame:self.view.bounds];
    image.imageRect = frame;
    image.image = _cacheArray[index];
    image.editerDone = ^(UIImage *image) {
        
        [ws.cacheArray insertObject:image atIndex:index];
    };
    
    UIWindow *windows = [UIApplication sharedApplication].windows.firstObject;
    [windows addSubview:image];
    [_cacheArray removeObjectAtIndex:index];
}

- (void)getImageFromLibrary
{
    NSArray *array = @[
                       NSLocalizedString(@"gif.draw.photoAlert.camera", ""),
                       NSLocalizedString(@"gif.draw.photoAlert.album", ""),
                       NSLocalizedString(@"gif.base.alert.cancle", "")];
    JMPhotosAlertView *alert = [[JMPhotosAlertView alloc] initWithFrame:CGRectMake(0, kH, kW, alertHeight)];
    alert.titles = array;
    alert.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:backView];
    [backView addSubview:alert];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        alert.frame = CGRectMake(0, kH-(12+alertHeight*array.count), kW, 12+alertHeight*array.count);
    }];
}

#pragma mark --
- (void)photoFromSource:(NSInteger)sourceType
{
    if (sourceType == 200) {
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {[self initImagePicker:1];}
        
    }else if (sourceType == 201){
       
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {[self initImagePicker:0];}
    }
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
    
#pragma mark -- 这一步应该先保存原来的, 在开始新的
    _paintView.image = image;
    [_paintView setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 添加代码，处理选中图像又取消的情况
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareCurrentImage:(UIButton *)sender
{
    // JMPaintView *pView = self.subViews.lastObject;
    
    if (_paintView.image) {
        
        [self showBottomCircleView:[_paintView.image imageWithWaterMask]];
    }else{
        UIImage *image = _paintView.image; //[UIImage imageWithCaptureView:_paintView rect:CGRectMake(0, 0, kW, kW)];
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
    
    for (UIImage *image in _cacheArray) {
        
        NSData *data = UIImagePNGRepresentation(image);
        NSString *cache = [NSString stringWithFormat:@"%@/%@.png", JMCachePath, [JMHelper timerString]];
        [data writeToFile:cache atomically:YES];
    }
    
    [_cacheArray removeAllObjects];
    
    
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
