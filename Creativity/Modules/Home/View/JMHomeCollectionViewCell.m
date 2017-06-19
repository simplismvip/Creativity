//
//  JMHomeCollectionViewCell.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMHomeCollectionViewCell.h"
#import "JMHomeModel.h"
#import "FLAnimatedImageView+WebCache.h"

@interface JMHomeCollectionViewCell ()
@property (nonatomic, strong) FLAnimatedImageView *classImage;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation JMHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = JMColor(251, 251, 251);
        
        _classImage = [[FLAnimatedImageView alloc] init];
        [self.contentView addSubview:_classImage];
        
        _deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_deleteBtn setTintColor:JMColor(217, 51, 58)];
        [_deleteBtn addTarget:self action:@selector(share:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [_deleteBtn setImage:[UIImage imageWithTemplateName:@"navbar_share_icon_black"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_deleteBtn];
    }
    
    return self;
}

- (void)deleteByIndexPath:(UIButton *)sender event:(id)event
{
    if ([self.delegate respondsToSelector:@selector(deleteByIndexPath:)]) {
        
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:_collection];
        NSIndexPath *indexpath = [_collection indexPathForItemAtPoint:currentTouchPosition];
        
        if (indexpath) {
            
            [self.delegate deleteByIndexPath:indexpath];
        }
    }
}

- (void)share:(UIButton *)sender event:(id)event
{
    if ([self.delegate respondsToSelector:@selector(share:)]) {
        
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:_collection];
        NSIndexPath *indexpath = [_collection indexPathForItemAtPoint:currentTouchPosition];
        
        if (indexpath) {
            
            [self.delegate share:indexpath];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _classImage.frame = CGRectMake(5, 5, self.height-10, self.height-10);
    _deleteBtn.frame = CGRectMake(0, 0, 30, 30);
}

- (void)setModel:(JMHomeModel *)model
{
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.folderPath];
    [_classImage sd_setImageWithURL:url];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//       
//        UIImage *image = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:model.folderPath]];
//        //通知主线程刷新
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [_classImage sd_setImageWithURL:url1];
//            
//            //回调或者说是通知主线程刷新，
//            _classImage.image = image;
//        });
//        
//    });
}

#pragma mark - 是否处于编辑状态
- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState) {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = JMColor(217, 51, 58).CGColor;
        [_deleteBtn setImage:[UIImage imageWithTemplateName:@"navbar_close_icon_black"] forState:(UIControlStateNormal)];
        [_deleteBtn removeTarget:self action:@selector(share:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [_deleteBtn addTarget:self action:@selector(deleteByIndexPath:event:) forControlEvents:(UIControlEventTouchUpInside)];
        
    } else {
        
        [_deleteBtn setImage:[UIImage imageWithTemplateName:@"navbar_share_icon_black"] forState:(UIControlStateNormal)];
        [_deleteBtn removeTarget:self action:@selector(deleteByIndexPath:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [_deleteBtn addTarget:self action:@selector(share:event:) forControlEvents:(UIControlEventTouchUpInside)];
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
