//
//  SetTableViewCell.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "SetTableViewCell.h"
#import "MSCellAccessory.h"
#import "SetModel.h"

@interface SetTableViewCell()
@property (nonatomic, weak) UIImageView *leftImage;
@property (nonatomic, weak) UILabel *textTitle;
@end

@implementation SetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:leftImage];
        leftImage.tintColor = [UIColor grayColor];
        self.leftImage = leftImage;
        
        UILabel *textTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        textTitle.textAlignment = NSTextAlignmentLeft;
        textTitle.font = [UIFont systemFontOfSize:14.0];
//        textTitle.textColor = JMTabViewBaseColor;
        [self.contentView addSubview:textTitle];
        self.textTitle = textTitle;
        
        self.accessoryType = 1;
        self.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:JMBaseColor];
    }
    
    return self;
}

- (void)setModel:(SetModel *)model
{
    _model = model;
    _textTitle.text = model.title;
    if (![_model.icon isEqualToString:@"0"]) {_leftImage.image = [UIImage imageNamed:model.icon];}
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = [_model.icon isEqualToString:@"0"]?0:self.height-20;
    _leftImage.frame = CGRectMake(10, 12, w, self.height-20);
    
    CGFloat m = [_model.icon isEqualToString:@"0"]?0:10;
    _textTitle.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame)+m, 8, self.width*0.6, self.height-10);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
