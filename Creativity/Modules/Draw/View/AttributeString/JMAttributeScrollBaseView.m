//
//  JMAttributeScrollBaseView.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMAttributeScrollBaseView.h"
#import "JMAttributeStringView.h"
@interface JMAttributeScrollBaseView()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageController;
@end


@implementation JMAttributeScrollBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIScrollView *scrollView  = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate  = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        JMAttributeStringView *fontName = [[JMAttributeStringView alloc] init];
        fontName.fontname = ^(NSString *fontName, NSInteger fontType) {
            
            if (self.attributeFontset) {self.attributeFontset(fontName, fontType);}
        };
        
        [self.scrollView addSubview:fontName];
        fontName.dataArray = [JMHelper systemFont];
        
        JMAttributeStringView *fontSet = [[JMAttributeStringView alloc] init];
        fontSet.fontname = ^(NSString *fontName, NSInteger fontType) {
            
            if (self.attributeFontset) {self.attributeFontset(fontName, fontType);}
        };
        
        [self.scrollView addSubview:fontSet];
        fontSet.dataArray = [JMHelper systemFontType];
        
        UIPageControl *pageController = [[UIPageControl alloc] init];
        pageController.userInteractionEnabled = NO;
        pageController.currentPageIndicatorTintColor = JMBaseColor;
        pageController.pageIndicatorTintColor = [UIColor whiteColor];
        pageController.numberOfPages = 2;
        [self addSubview:pageController];
        self.pageController = pageController;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, self.width, self.height-20);
    _pageController.frame = CGRectMake(0, self.height - 20, self.width, 20);
    
    for (int i = 0; i < 2; i ++) {
        
        JMAttributeStringView *view = _scrollView.subviews[i];
        view.frame = CGRectMake(_scrollView.width * i, 0, _scrollView.width, _scrollView.height);
    }
    
    self.scrollView.contentSize = CGSizeMake(2 * self.scrollView.width, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page  = scrollView.contentOffset.x / scrollView.width;
    self.pageController.currentPage = (int)(page + 0.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
