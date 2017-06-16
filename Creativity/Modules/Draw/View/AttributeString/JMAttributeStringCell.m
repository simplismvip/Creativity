//
//  JMAttributeStringCell.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMAttributeStringCell.h"
#import "JMAttributeStringContentView.h"

@interface JMAttributeStringCell()

@end

@implementation JMAttributeStringCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.backgroundColor = [UIColor clearColor];
        
        JMAttributeStringContentView *content = [[JMAttributeStringContentView alloc] init];
        [self addSubview:content];
        content.backgroundColor = [UIColor clearColor];
        self.contentV = content;
        
        UILabel *fontName = [[UILabel alloc] init];
        [self addSubview:fontName];
        fontName.textAlignment = NSTextAlignmentLeft;
        self.fontName = fontName;
        
        UILabel *fontShow = [[UILabel alloc] init];
        [self addSubview:fontShow];
        fontShow.textAlignment = NSTextAlignmentCenter;
        self.fontShow = fontShow;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _fontName.frame = CGRectMake(10, 0, self.width/2-10, self.height);
    _fontShow.frame = CGRectMake(CGRectGetMaxX(_fontName.frame), 0, self.width/2, self.height);
    _contentV.frame = self.bounds;
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
