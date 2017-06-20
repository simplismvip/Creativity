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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = JMColor(65, 65, 65);
        
        UIImageView *leftImage = [[UIImageView alloc] init];
        [self.contentView addSubview:leftImage];
        self.leftImage = leftImage;
        
        UILabel *textTitle = [[UILabel alloc] init];
        textTitle.textAlignment = NSTextAlignmentLeft;
        textTitle.font = [UIFont systemFontOfSize:18.0];
        textTitle.textColor = [UIColor whiteColor];
        [self.contentView addSubview:textTitle];
        self.textTitle = textTitle;
        
        UILabel *subTitle = [[UILabel alloc] init];
        subTitle.textAlignment = NSTextAlignmentLeft;
        subTitle.font = [UIFont systemFontOfSize:14.0];
        subTitle.textColor = [UIColor whiteColor];
        [self.contentView addSubview:subTitle];
        self.subTitle = subTitle;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _leftImage.frame = CGRectMake(20, 15, self.height-30, self.height-30);
    _textTitle.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame)+20, 15, self.width*0.6, self.height/3);
    _subTitle.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame)+20, CGRectGetMaxY(_textTitle.frame), self.width*0.6, self.height/3);
}

- (void)setModel:(ProModel *)model
{
    _model = model;
    _leftImage.image = [[UIImage imageNamed:model.image] imageWithColor:JMBaseColor];
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
