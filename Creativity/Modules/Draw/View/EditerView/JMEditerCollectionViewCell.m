//
//  JMEditerCollectionViewCell.m
//  Creativity
//
//  Created by 赵俊明 on 2017/7/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMEditerCollectionViewCell.h"
#import "JMEditerModel.h"
#import "SDImageCache.h"

@interface JMEditerCollectionViewCell ()
@property (nonatomic, strong) UIImageView *classImage;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation JMEditerCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        _classImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _classImage.contentMode = UIViewContentModeScaleAspectFill;
        _classImage.clipsToBounds = YES;
        [self.contentView addSubview:_classImage];
        
        _deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _deleteBtn.frame = CGRectZero;
        [_deleteBtn setTintColor:JMBaseColor];
        [_deleteBtn setImage:[UIImage imageNamed:@"navbar_close_icon_black"] forState:(UIControlStateNormal)];
        [_deleteBtn addTarget:self action:@selector(deleteByIndexPath:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_deleteBtn];
    }
    
    return self;
}

- (void)deleteByIndexPath:(UIButton *)sender event:(id)event
{
    if ([self.delegate respondsToSelector:@selector(deleteByIndexPath:)]) {
        
        UITouch *touch =[[event allTouches] anyObject];
        CGPoint currentTouchPosition = [touch locationInView:_collection];
        NSIndexPath *indexpath = [_collection indexPathForItemAtPoint:currentTouchPosition];
        if (indexpath) {[self.delegate deleteByIndexPath:indexpath];}
        
        [SDImageCache sharedImageCache] ;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _classImage.frame = self.bounds;
    _deleteBtn.frame = CGRectMake(0, 0, 30, 30);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
//    NSString *localIdentifier = @"";
//    [[SDImageCache sharedImageCache] diskImageExistsWithKey:localIdentifier completion:^(BOOL isInCache) {
//        
//        if (isInCache) {
//            
//            _classImage.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:localIdentifier];
//            
//            NSLog(@"存在改文件---------------");
//        }else{
//            
//            JMSelf(ws);
//            [[SDImageCache sharedImageCache] storeImage:image forKey:localIdentifier completion:^{
//                
//                ws.classImage.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:localIdentifier];;
//            }];
//            
//            NSLog(@"---------------");
//
//        }
//    }];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        UIImage *newNimage = [image compressOriginalImageToSize:CGSizeMake(64, 64)];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _classImage.image = newNimage;
        });
    });
}

@end
