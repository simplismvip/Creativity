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

@interface JMPhotosCollectionCell()
@property (nonatomic, strong) UILabel *className;
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
    _className.frame = self.bounds;
}

- (void)setModel:(TZAssetModel *)model
{
    _model = model;
    _isSelect = model.isSelect;
    _className.text = [NSString stringWithFormat:@"%ld", model.index];
    _className.hidden = model.isHide;
    
    [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:200 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _classImage.image = photo;
    }];
}

@end
