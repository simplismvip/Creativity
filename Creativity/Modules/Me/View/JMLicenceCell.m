//
//  JMLicenceCell.m
//  Creativity
//
//  Created by 赵俊明 on 2017/6/24.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMLicenceCell.h"
#import "JMLicenceModel.h"
#import "JMLicenceViewModel.h"

@interface JMLicenceCell ()
@property (nonatomic, weak) UILabel *abovecopyright;
@property (nonatomic, weak) UILabel *copyright;
@property (nonatomic, weak) UILabel *lower;
@property (nonatomic, weak) UILabel *upper;
@end

@implementation JMLicenceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *copyright = [[UILabel alloc] init];
        copyright.numberOfLines = 0;
        copyright.font = [UIFont systemFontOfSize:15];
        [self addSubview:copyright];
        self.copyright = copyright;
        
        UILabel *lower = [[UILabel alloc] init];
        lower.numberOfLines = 0;
        lower.font = [UIFont systemFontOfSize:15];
        [self addSubview:lower];
        self.lower = lower;
        
        UILabel *abovecopyright = [[UILabel alloc] init];
        abovecopyright.numberOfLines = 0;
        abovecopyright.font = [UIFont systemFontOfSize:15];
        [self addSubview:abovecopyright];
        self.abovecopyright = abovecopyright;
        
        UILabel *upper = [[UILabel alloc] init];
        upper.numberOfLines = 0;
        upper.font = [UIFont systemFontOfSize:15];
        [self addSubview:upper];
        self.upper = upper;
    }
    
    return self;
}

- (void)setViewModel:(JMLicenceViewModel *)viewModel
{
    _viewModel = viewModel;
    _copyright.text = viewModel.model.copyright;
    _lower.text = viewModel.model.lower;
    _abovecopyright.text = viewModel.model.aboveCopyright;
    _upper.text = viewModel.model.upper;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _copyright.frame = CGRectMake(10, 0, self.width-20, _viewModel.copyrightFrame);
    _lower.frame = CGRectMake(10, CGRectGetMaxY(_copyright.frame)+20, self.width-20, _viewModel.lowerFrame);
    _abovecopyright.frame = CGRectMake(10, CGRectGetMaxY(_lower.frame)+20, self.width-20, _viewModel.aboveCopyrightFrame);
    _upper.frame = CGRectMake(10, CGRectGetMaxY(_abovecopyright.frame)+20, self.width-20, _viewModel.upperFrame);
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
