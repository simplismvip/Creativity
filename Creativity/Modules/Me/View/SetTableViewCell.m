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
        
        UIImageView *leftImage = [[UIImageView alloc] init];
        [self.contentView addSubview:leftImage];
        leftImage.tintColor = [UIColor grayColor];
        self.leftImage = leftImage;
        
        UILabel *textTitle = [[UILabel alloc] init];
        textTitle.textAlignment = NSTextAlignmentLeft;
        textTitle.font = [UIFont systemFontOfSize:14.0];
//        textTitle.textColor = JMTabViewBaseColor;
        [self.contentView addSubview:textTitle];
        self.textTitle = textTitle;
    }
    
    return self;
}

+ (instancetype)setCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath model:(SetModel *)model
{
    static NSString *ID = @"baseCell";
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {cell = [[SetTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    
    cell.leftImage.image = indexPath.section == 2 ? [UIImage imageNamed:model.icon]:[UIImage imageWithTemplateName:model.icon];
    cell.textTitle.text = model.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:JMBaseColor];
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _leftImage.frame = CGRectMake(10, 12, self.height-20, self.height-20);
    _textTitle.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame)+10, 8, self.width*0.6, self.height-10);
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
