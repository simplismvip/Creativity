//
//  JMHomeCollectionViewCell.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMHomeCollectionViewCell.h"
#import "JMHomeModel.h"
#import "UIImageView+WebCache.h"

@interface JMHomeCollectionViewCell ()

@property (nonatomic, strong) UIImageView *classImage;
@property (nonatomic, strong) UIImageView *voiceImage;
@property (nonatomic, strong) UILabel *className;
@property (nonatomic, strong) UIButton *classTime;
@property (nonatomic, strong) UIButton *deleteBtn;
//@property (nonatomic, strong) UIButton *countBtn;

@end

@implementation JMHomeCollectionViewCell

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
        
        _voiceImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _voiceImage.contentMode = UIViewContentModeScaleAspectFit;
        _voiceImage.tintColor = JMColor(115, 115, 155);
        [self.contentView addSubview:_voiceImage];
        
        _className = [[UILabel alloc] initWithFrame:CGRectZero];
        _className.numberOfLines = 0;
        _className.textColor = JMColor(115, 115, 155);
        _className.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_className];
        
        _classTime = [[UIButton alloc] initWithFrame:CGRectZero];
        _classTime.tintColor = JMColor(115, 115, 155);
        [_classTime addTarget:self action:@selector(share:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_classTime];
        
//        _countBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [_countBtn addTarget:self action:@selector(showRoomNumber:event:) forControlEvents:(UIControlEventTouchUpInside)];
//        _countBtn.frame = CGRectZero;
////        _countBtn.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_countBtn];
        
        _deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _deleteBtn.hidden = YES;
        _deleteBtn.frame = CGRectZero;
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

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    
    if (isGrid) {
        
        _classImage.frame = CGRectMake(5, 5, self.width-10, self.height-45);
        _voiceImage.frame = CGRectMake(CGRectGetMinX(_classImage.frame)+CGRectGetWidth(_classImage.frame)/2-20, CGRectGetMinY(_classImage.frame)+CGRectGetHeight(_classImage.frame)/2-20, 40, 40);
        
        _deleteBtn.frame = CGRectMake(0, 0, 30, 30);
        _className.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMaxY(_classImage.frame), CGRectGetWidth(_classImage.frame)-40, 40);
        _classTime.frame = CGRectMake(CGRectGetMaxX(_className.frame)+10, CGRectGetMaxY(_classImage.frame)+5, 30, 30);
        _className.font = [UIFont boldSystemFontOfSize:11.0];
        _className.textAlignment = NSTextAlignmentCenter;
        
    } else {
        
        _classImage.frame = CGRectMake(5, 5, self.height-10, self.height-10);
        _voiceImage.frame = CGRectMake(CGRectGetMinX(_classImage.frame)+CGRectGetWidth(_classImage.frame)/2-20, CGRectGetMinY(_classImage.frame)+CGRectGetHeight(_classImage.frame)/2-20, 40, 40);
        _deleteBtn.frame = CGRectMake(0, 0, 30, 30);
        _className.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, self.height-40, self.width-self.height-50, 40);
        _classTime.frame = CGRectMake(self.width-40, self.height-40, 40, 40);
        _className.font = [UIFont boldSystemFontOfSize:14.0];
        _className.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setModel:(JMHomeModel *)model
{
    _model = model;
    NSString *png = [NSString stringWithFormat:@"%@/%@/%@", JMAccountPath, model.folderName, model.pngName];
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.pngName] placeholderImage:[UIImage imageNamed:png]];
    
    _voiceImage.image = [UIImage imageWithTemplateName:model.isVoice?@"home_play":@"0"];
    _className.text = @"YaoYao";// model.creatDate;
    [_classTime setImage:[UIImage imageWithTemplateName:@"share"] forState:(UIControlStateNormal)];
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
