//
//  JMMembersCell.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/28.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMMembersCell.h"

@interface JMMembersCell()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL drawViewHide;
@end


@implementation JMMembersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 左侧label
        self.header = [[UIImageView alloc] init];
        self.header.backgroundColor = JMColor(245, 245, 245);
        [self addSubview:self.header];
        
        // 右侧label
        self.name = [[UILabel alloc] init];
        self.name.font = [UIFont systemFontOfSize:14.0];
        self.name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.name];
        
        // 右侧label
        self.showAndHide = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.showAndHide setTintColor:JMColor(52, 118, 237)];
        [self.showAndHide addTarget:self action:@selector(showAndHide:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.showAndHide];
        
        self.textLabel.textColor = JMColor(55, 55, 55);
        
        UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(getEditer:)];
        [self addGestureRecognizer:ges];
    }
    
    return self;
}

- (void)getEditer:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
    
        if ([self.delegate respondsToSelector:@selector(editerCell)]) {
            [self.delegate editerCell];
        }
    }
}

- (void)showAndHide:(UIButton *)btn event:(id)event
{
    UITouch *touch =[[event allTouches] anyObject];
    NSIndexPath *indexpath = [_tableView indexPathForRowAtPoint:[touch locationInView:_tableView]];
    if (indexpath) {
        
        self.drawViewHide = !self.drawViewHide;
        if ([self.delegate respondsToSelector:@selector(hideView:isHide:)]) {
            
            [self.delegate hideView:indexpath.row isHide:self.drawViewHide];
            
            if (self.drawViewHide) {
               
                [self.showAndHide setImage:[UIImage imageWithTemplateName:@"vesion_hide_32"] forState:(UIControlStateNormal)];
            }else{
                [self.showAndHide setImage:[UIImage imageWithTemplateName:@"vesion_show_32"] forState:(UIControlStateNormal)];
            }
        }
    }
}

+ (instancetype)initWithMemberCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"memberCell";
    JMMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.tableView = tableView;
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.header.frame = CGRectMake(10, 4, self.height-8, self.height-8);
    self.name.frame = CGRectMake(CGRectGetMaxX(_header.frame)+10, CGRectGetMinY(_header.frame), self.width*0.6, self.height-10);
    self.showAndHide.frame = CGRectMake(self.width-45, 6, 30, 30);

    for (UIControl *control in self.subviews) {
        self.showAndHide.hidden = _tableView.isEditing;
        if ([control isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {[control removeFromSuperview];}
    }
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
