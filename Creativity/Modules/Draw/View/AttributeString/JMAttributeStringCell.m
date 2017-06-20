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
        self.contentV = content;
        
        UILabel *fontName = [[UILabel alloc] init];
        [self addSubview:fontName];
        fontName.textColor = [UIColor whiteColor];
        fontName.textAlignment = NSTextAlignmentCenter;
        self.fontName = fontName;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _fontName.frame = self.bounds;
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
