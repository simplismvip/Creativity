//
//  JMHeaderFooterView.m
//  ebookReader
//
//  Created by JM Zhao on 2017/9/30.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMHeaderFooterView.h"
#import "JMHeaderFooterModel.h"

@interface JMHeaderFooterView()
@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) UILabel *leftLabel;
@end

@implementation JMHeaderFooterView

+ (instancetype)initHeaderFooterWithTableView:(UITableView *)tableView
{
    static NSString *headID = @"header";
    JMHeaderFooterView *headView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    
    if (headView == nil) {
        headView = [[JMHeaderFooterView alloc] initWithReuseIdentifier:headID];
        headView.contentView.backgroundColor = JMColorRGBA(240, 240, 240, 0.7);
    }
    
    return headView;
}

// 重用headView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:leftLabel];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel = leftLabel;
        
        UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        leftBtn.userInteractionEnabled = NO;
        leftBtn.tintColor = [UIColor grayColor];
        [self.contentView addSubview:leftBtn];
        self.leftBtn = leftBtn;
        
        UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.contentView addSubview:rightBtn];
        self.rightBtn = rightBtn;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = [_model.leftImage isEqualToString:@"0"]?0:self.height-8;
    _leftBtn.frame = CGRectMake(10, 4, w, w);
    
    _leftLabel.frame = CGRectMake(CGRectGetMaxX(_leftBtn.frame)+(w>0?10:0), 0, self.width*0.6, self.height);
    
    _rightBtn.frame = CGRectMake(self.width-self.height-10, 0, self.height, self.height);
    
}

- (void)setModel:(JMHeaderFooterModel *)model
{
    _model = model;
    [_leftBtn setImage:[UIImage imageNamed:model.leftImage] forState:(UIControlStateNormal)];
    [_rightBtn setImage:[UIImage imageNamed:model.rightImage] forState:(UIControlStateNormal)];
    _leftLabel.text = model.leftTitle;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
