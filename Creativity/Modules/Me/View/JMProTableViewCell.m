//
//  JMProTableViewCell.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMProTableViewCell.h"
#import "ProModel.h"

@interface JMProTableViewCell()
@property (nonatomic, weak) UIImageView *leftImage;
@property (nonatomic, weak) UILabel *textTitle;
@property (nonatomic, weak) UILabel *subTitle;
@end

@implementation JMProTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *leftImage = [[UIImageView alloc] init];
        [leftImage setTintColor:JMColor(125, 125, 125)];
        [self.contentView addSubview:leftImage];
        self.leftImage = leftImage;
        
        UILabel *textTitle = [[UILabel alloc] init];
        textTitle.textAlignment = NSTextAlignmentLeft;
        textTitle.font = [UIFont systemFontOfSize:14.0];
        textTitle.textColor = JMColor(55, 55, 55);
        [self.contentView addSubview:textTitle];
        self.textTitle = textTitle;
        
        UILabel *subTitle = [[UILabel alloc] init];
        subTitle.textAlignment = NSTextAlignmentLeft;
        subTitle.font = [UIFont systemFontOfSize:14.0];
        subTitle.textColor = JMColor(55, 55, 55);
        [self.contentView addSubview:subTitle];
        self.subTitle = subTitle;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _leftImage.frame = CGRectMake(10, 12, self.height-20, self.height-20);
    _textTitle.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame)+10, 8, self.width*0.6, self.height-10);
    _subTitle.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame)+10, CGRectGetMaxY(_textTitle.frame), self.width*0.6, self.height-10);
}

- (void)setModel:(ProModel *)model
{
    _model = model;
    _leftImage.image = [UIImage imageNamed:model.image];
    _textTitle.text = model.title;
    _subTitle.text = model.subTitle;
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
