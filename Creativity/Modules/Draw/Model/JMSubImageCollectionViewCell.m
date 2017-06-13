//
//  JMSubImageCollectionViewCell.m
//  YaoYao
//
//  Created by JM Zhao on 2017/4/25.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMSubImageCollectionViewCell.h"
#import "JMSubImageModel.h"

@interface JMSubImageCollectionViewCell()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation JMSubImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    
    return self;
}

- (void)setModel:(JMSubImageModel *)model
{
    _model = model;
    _imageView.image = [UIImage imageNamed:model.name];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
