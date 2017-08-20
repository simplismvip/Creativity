//
//  JMPhotosCollectionCell.m
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMPhotosCollectionCell.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"
#import "SDImageCache.h"

@interface JMPhotosCollectionCell()
@property (nonatomic, strong) UILabel *className;
@property (nonatomic, strong) UIImageView *classImageTpye;
@end

@implementation JMPhotosCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        _classImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _classImage.contentMode = UIViewContentModeScaleAspectFill;
        _classImage.clipsToBounds = YES;
        [self.contentView addSubview:_classImage];
        
        _classImageTpye = [[UIImageView alloc] initWithFrame:CGRectZero];
        _classImageTpye.contentMode = UIViewContentModeScaleAspectFill;
        _classImageTpye.clipsToBounds = YES;
        _classImageTpye.tintColor = JMColor(217, 51, 58);
        [self.contentView addSubview:_classImageTpye];
        
        _className = [[UILabel alloc] initWithFrame:CGRectZero];
        _className.alpha = 0.5;
        _className.hidden = YES;
        _className.textAlignment = NSTextAlignmentCenter;
        _className.textColor = JMBaseColor;
        _className.backgroundColor = [UIColor yellowColor];
        _className.font = [UIFont boldSystemFontOfSize:24];
        [self.contentView addSubview:_className];
        
        self.isSelect = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _classImage.frame = self.bounds;
    _classImageTpye.frame = CGRectMake(5, self.height-25, 20, 20);
    _className.frame = self.bounds;
}

- (void)setModel:(TZAssetModel *)model
{
    _model = model;
    _isSelect = model.isSelect;
    _className.text = [NSString stringWithFormat:@"%ld", model.index];
    _className.hidden = model.isHide;
    PHAsset *asset = (PHAsset *)model.asset;

    JMSelf(ws);
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:asset.localIdentifier completion:^(BOOL isInCache) {
    
        if (isInCache) {
    
            ws.classImage.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:asset.localIdentifier];
        }else{
        
            [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:100 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                
                PHAsset *asset = (PHAsset *)model.asset;
                [[SDImageCache sharedImageCache] storeImage:photo forKey:asset.localIdentifier completion:^{
                
                    ws.classImage.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:asset.localIdentifier];;
                }];
            }];
        }
    }];
    
    if (model.type == TZAssetModelMediaTypeLivePhoto) {
        
        _classImageTpye.image = [[UIImage imageWithRenderingName:@"PhotosLivePrefsHeader"] imageWithColor:JMBaseColor];
        
    }else if (model.type == TZAssetModelMediaTypeBursts){
        
        _classImageTpye.image = [[UIImage imageWithRenderingName:@"icons8-layers"] imageWithColor:JMBaseColor];
        
    }else if (model.type == TZAssetModelMediaTypeGIF){
        
        _classImageTpye.image = [[UIImage imageWithRenderingName:@"gif"] imageWithColor:JMBaseColor];
        
    }else if (model.type == TZAssetModelMediaTypeVideo){
        
        _classImageTpye.image = [[UIImage imageWithRenderingName:@"navbar_video_icon_disabled_black"] imageWithColor:JMBaseColor];
        
    }else if (model.type == TZAssetModelMediaTypePhoto){
        
        _classImageTpye.image = [[UIImage imageWithRenderingName:@"icons8-add_image"] imageWithColor:JMBaseColor];
    }
}

@end
