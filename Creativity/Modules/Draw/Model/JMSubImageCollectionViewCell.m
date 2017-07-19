//
//  JMSubImageCollectionViewCell.m
//  YaoYao
//
//  Created by JM Zhao on 2017/4/25.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMSubImageCollectionViewCell.h"
#import "JMSubImageModel.h"
#import "SDImageCache.h"

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
    
    JMSelf(ws);
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:model.name completion:^(BOOL isInCache) {
        
        if (isInCache) {
            
            ws.imageView.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.name];
        }else{
            [[SDImageCache sharedImageCache] storeImage:[UIImage imageNamed:model.name] forKey:model.name completion:^{
                
                ws.imageView.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.name];
            }];
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
