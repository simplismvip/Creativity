//
//  JMHomeCollectionViewCell.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMHomeCollectionViewCell.h"
#import "JMHomeModel.h"
#import "UIImage+GIF.h"

@interface JMHomeCollectionViewCell ()
@property (nonatomic, strong) UIImageView *classImage;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation JMHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = JMColor(251, 251, 251);
        
        _classImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_classImage];
        
        _deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _deleteBtn.hidden = YES;
        [_deleteBtn setTintColor:JMColor(115, 115, 155)];
        [_deleteBtn addTarget:self action:@selector(deleteByIndexPath:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [_deleteBtn setImage:[UIImage imageWithTemplateName:@"collectionDelete"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_deleteBtn];
    }
    
    return self;
}

- (void)showRoomNumber:(UIButton *)sender event:(id)event
{
    if ([self.delegate respondsToSelector:@selector(showRoomMembers:currentPoint:)]) {
        
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:_collection];
        NSIndexPath *indexpath = [_collection indexPathForItemAtPoint:currentTouchPosition];
        if (indexpath) {
            
            [self.delegate showRoomMembers:indexpath currentPoint:currentTouchPosition];
        }
    }
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        UIImage *image = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:model.folderPath]];
        //通知主线程刷新
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            _classImage.image = image;
        });
        
    });
}

#pragma mark - 是否处于编辑状态
- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState) {
        
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        _deleteBtn.hidden = NO;
        
    } else {
        
        self.layer.borderColor = [UIColor clearColor].CGColor;
        _deleteBtn.hidden = YES;
    }
}

@end
