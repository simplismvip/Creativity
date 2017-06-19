//
//  JMAttributeStringAnimationView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/19.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMAttributeStringAnimationView.h"
#import "JMAttributeStringView.h"
#import "JMAttributeStringModel.h"
#import "JMFiltersView.h"
#import "JMAttributeString.h"

@interface JMAttributeStringAnimationView()
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) JMAttributeStringView *attribute;
@property (nonatomic, weak) JMFiltersView *filter;
@end

@implementation JMAttributeStringAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(kW/2, 80, 0, kH-160)];
        coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        coverView.layer.cornerRadius = 10;
        coverView.layer.masksToBounds = YES;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            coverView.frame = CGRectMake(kW*0.15, 120, kW*0.7, kW);
            
        } completion:^(BOOL finished) {
            
            [self addAttributeStringAnimationView];
        }];
    }
    return self;
}

- (void)addAttributeStringAnimationView
{
    JMAttributeStringView *attribute = [[JMAttributeStringView alloc] initWithFrame:CGRectMake(10, 10, _coverView.width-20, _coverView.height-50)];
    [self.coverView insertSubview:attribute atIndex:0];
    attribute.fontname = ^(NSString *fontName, NSInteger fontType) {
     
        if (fontName) {if (self.attributeString) {self.attributeString(fontName);}}
        if (fontType<10) {[StaticClass setFontType:fontType];}
    };
    
    self.attribute = attribute;
    
    JMFiltersView *filter = [[JMFiltersView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(attribute.frame), _coverView.width-20, 40)];
    filter.tinColor = JMBaseColor;
    filter.titles = @[@{@"title":@"返回", @"image":@"navbar_close_icon_black"}, @{@"title":@"选择字体", @"image":@"emoji"}, @{@"title":@"字体样式", @"image":@"heart_32"}];
    filter.contentSize = CGSizeMake(filter.width*0.63, 30);
    filter.filter = ^(NSInteger type) {
        
        if (type == 0) {
            
            [self closeView];
            
        }else if (type == 1) {
            
            attribute.dataArray = [JMHelper systemFont];
            
        }else if (type == 2) {
            
            attribute.dataArray = [JMHelper systemFontType];
        }
    };
    
    [self.coverView addSubview:filter];
    self.filter = filter;
}

- (void)closeView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _attribute.alpha = 0.0;
        _filter.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _coverView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }];
}


/*
 
 - (void)closeView:(UIButton *)sender
 {
 [UIView animateWithDuration:0.4 animations:^{
 
 _attribute.alpha = 0.0;
 sender.transform = CGAffineTransformMakeRotation(M_PI);
 sender.transform = CGAffineTransformMakeScale(0.1, 0.1);
 
 } completion:^(BOOL finished) {
 
 [UIView animateWithDuration:0.3 animations:^{
 
 _coverView.alpha = 0.5;
 
 } completion:^(BOOL finished) {
 
 [self removeFromSuperview];
 }];
 }];
 }

 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
