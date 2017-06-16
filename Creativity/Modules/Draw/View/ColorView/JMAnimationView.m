//
//  JMAnimationView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/2.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMAnimationView.h"
#import "JMSlider.h"
#import "JMColorView.h"

@interface JMAnimationView ()
@property (nonatomic, weak) JMColorView *colorView;
@property (nonatomic, weak) JMSlider *fontSize;
@property (nonatomic, weak) JMSlider *alphaView;
@property (nonatomic, weak) UIView *coverView;

@end

@implementation JMAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 0.0;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(kW/2, 80, 0, kH-160)];
        coverView.backgroundColor = JMBaseColor;
//        coverView.alpha = 0.5;
        coverView.layer.cornerRadius = 20;
        coverView.layer.masksToBounds = YES;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        close.tintColor = [UIColor whiteColor];
        [close setImage:[UIImage imageWithTemplateName:@"close_icon_black"] forState:(UIControlStateNormal)];
        [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            coverView.frame = CGRectMake(30, 120, kW-60, kH-240);
            
        } completion:^(BOOL finished) {
            
            [coverView addSubview:close];
            
            [self addsubColorViews];
        }];
    }
    return self;
}

- (void)addsubColorViews
{
    JMColorView *colorView = [[JMColorView alloc] initWithFrame:CGRectMake(15, 10, _coverView.width-30, _coverView.width+30)];
    colorView.colorBlock = ^(UIColor *color) {
        
        [StaticClass setColor:color];
    };
    
    [self.coverView insertSubview:colorView atIndex:0];
    self.colorView = colorView;
    
    JMSlider *fontSize = [[JMSlider alloc] initWithFrame:CGRectMake(30, _coverView.height-60, kW-120, 20)];
    fontSize.sValue = [StaticClass getLineWidth];
    fontSize.alpha = 0.0;
    fontSize.value = ^(JMSlider *value) {
        
        value.title.text = [NSString stringWithFormat:@"%.0f", value.sValue*20];
        [StaticClass setLineWidth:value.sValue*20];
    };
    
    [self.coverView addSubview:fontSize];
    self.fontSize = fontSize;
    
    JMSlider *alphaView = [[JMSlider alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(fontSize.frame), kW-120, 20)];
    alphaView.sValue = [StaticClass getAlpha];
    alphaView.alpha = 0.0;
    alphaView.value = ^(JMSlider *value) {
        
        [StaticClass setAlpha:value.sValue];
        colorView.color_Alpha = [NSString stringWithFormat:@"%.2f", value.sValue];
    };
    
    [self.coverView addSubview:alphaView];
    self.alphaView = alphaView;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        alphaView.alpha = 1.0;
        fontSize.alpha = 1.0;
        colorView.alpha = 1.0;
    }];
}

- (void)closeView:(UIButton *)sender
{
    [UIView animateWithDuration:0.4 animations:^{
    
        _fontSize.alpha = 0.0;
        _alphaView.alpha = 0.0;
        _colorView.alpha = 0.0;
        
        sender.transform = CGAffineTransformMakeRotation(M_PI);
        sender.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [sender removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            
            _coverView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    _view.frame = CGRectMake(kW/2, 80, 0, kH-160);
//    _close.frame = CGRectMake(CGRectGetMaxX(_view.frame)-30, CGRectGetMinY(_view.frame)+30, 20, 20);
//    txt.frame = CGRectMake((kW-60)/2, (_view.height-30)/2, 0, 30);
//    txt1.frame = CGRectMake((kW-60)/2, CGRectGetMaxY(txt.frame)+30, 0, 30);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
