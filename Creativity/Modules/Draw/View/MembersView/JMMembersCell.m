//
//  JMMembersCell.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/28.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMMembersCell.h"
#import "JMMemberModel.h"

@interface JMMembersCell()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JMMembersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = JMColor(100, 100, 100);
        
        // 右侧label
        self.name = [[UILabel alloc] init];
        self.name.font = [UIFont systemFontOfSize:14.0];
        self.name.textColor = [UIColor whiteColor];
        self.name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.name];
        
        // 右侧label
        self.headerBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [_headerBtn setTintColor:JMColorRGBA(217, 51, 58, 1.0)];
        [_headerBtn addTarget:self action:@selector(headerBtn:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_headerBtn];
    }
    
    return self;
}

- (void)headerBtn:(UIButton *)btn event:(id)event
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [btn convertRect:btn.bounds toView:window];
    UITouch *touch =[[event allTouches] anyObject];
    NSIndexPath *indexpath = [_tableView indexPathForRowAtPoint:[touch locationInView:_tableView]];
    
    if ([self.delegate respondsToSelector:@selector(editerView:frame:)]) {
        
        [self.delegate editerView:indexpath frame:rect];
    }
}

- (void)setModel:(JMMemberModel *)model
{
    _model = model;
    [_headerBtn setImage:model.thumbnailImage forState:(UIControlStateNormal)];
    _name.text = [NSString stringWithFormat:@"%ld", model.index];
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
    self.headerBtn.frame = CGRectMake(10, 4, self.height-8, self.height-8);
    self.name.frame = CGRectMake(CGRectGetMaxX(_headerBtn.frame)+20, CGRectGetMinY(_headerBtn.frame), self.height, self.height-10);
    
    for (UIControl *control in self.subviews) {
        
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
