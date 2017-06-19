//
//  JMBaseColorView.m
//  YaoYao
//
//  Created by 赵俊明 on 2017/6/6.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMBaseColorView.h"
#import "UIColor+Wonderful.h"

@interface JMBaseColorView ()
@property (nonatomic, weak) UIScrollView *scrollView;
@end

//#pragma mark - **************** 黄色系
//* 玉米色
//+ (UIColor *)cornColor;
//* 柠檬薄纱
//+ (UIColor *)LemonChiffon;
//* 苍金麒麟
//+ (UIColor *)paleGodenrod;
//* 卡其色
//+ (UIColor *)khakiColor;
//* 金色
//+ (UIColor *)goldColor;
//* 雌黄
//+ (UIColor *)orpimentColor;
//* 藤黄
//+ (UIColor *)gambogeColor;
//* 雄黄
//+ (UIColor *)realgarColor;
//* 金麒麟色
//+ (UIColor *)goldenrod;
//* 乌金
//+ (UIColor *)darkGold;
//
//#pragma mark - **************** 绿色系
//* 苍绿
//+ (UIColor *)paleGreen;
//* 淡绿色
//+ (UIColor *)lightGreen;
//* 春绿
//+ (UIColor *)springGreen;
//* 绿黄色
//+ (UIColor *)greenYellow;
//* 草坪绿
//+ (UIColor *)lawnGreen;
//* 酸橙绿
//+ (UIColor *)limeColor;
//* 森林绿
//+ (UIColor *)forestGreen;
//* 海洋绿
//+ (UIColor *)seaGreen;
//* 深绿
//+ (UIColor *)darkGreen;
//* 橄榄(墨绿)
//+ (UIColor *)olive;
//
//#pragma mark - **************** 青色系
//* 淡青色
//+ (UIColor *)lightCyan;
//* 苍白绿松石
//+ (UIColor *)paleTurquoise;
//* 绿碧
//+ (UIColor *)aquamarine;
//* 绿松石
//+ (UIColor *)turquoise;
//* 适中绿松石
//+ (UIColor *)mediumTurquoise;
//* 美团色
//+ (UIColor *)meituanColor;
//* 浅海洋绿
//+ (UIColor *)lightSeaGreen;
//* 深青色
//+ (UIColor *)darkCyan;
//* 水鸭色
//+ (UIColor *)tealColor;
//* 深石板灰
//+ (UIColor *)darkSlateGray;
//
//#pragma mark - **************** 蓝色系
//* 天蓝色
//+ (UIColor *)skyBlue;
//* 淡蓝
//+ (UIColor *)lightBLue;
//* 深天蓝
//+ (UIColor *)deepSkyBlue;
//* 道奇蓝
//+ (UIColor *)doderBlue;
//* 矢车菊
//+ (UIColor *)cornflowerBlue;
//* 皇家蓝
//+ (UIColor *)royalBlue;
//* 适中的蓝色
//+ (UIColor *)mediumBlue;
//* 深蓝
//+ (UIColor *)darkBlue;
//* 海军蓝
//+ (UIColor *)navyColor;
//* 午夜蓝
//+ (UIColor *)midnightBlue;
//
//#pragma mark - **************** 紫色系
//* 薰衣草
//+ (UIColor *);
//* 蓟
//+ (UIColor *)thistleColor;
//* 李子
//+ (UIColor *)plumColor;
//* 紫罗兰
//+ (UIColor *)violetColor;
//* 适中的兰花紫
//+ (UIColor *)mediumOrchid;
//* 深兰花紫
//+ (UIColor *)darkOrchid;
//* 深紫罗兰色
//+ (UIColor *)darkVoilet;
//* 泛蓝紫罗兰
//+ (UIColor *)blueViolet;
//* 深洋红色
//+ (UIColor *)darkMagenta;
//* 靛青
//+ (UIColor *)indigoColor;
//
//#pragma mark - **************** 灰色系
//* 白烟
//+ (UIColor *)whiteSmoke;
//* 鸭蛋
//+ (UIColor *)duckEgg;
//* 亮灰
//+ (UIColor *)gainsboroColor;
//* 蟹壳青
//+ (UIColor *)carapaceColor;
//* 银白色
//+ (UIColor *);
//* 暗淡的灰色
//+ (UIColor *);

// [UIColor mistyRose], [UIColor lightSalmon], [UIColor lightCoral], [UIColor salmonColor], [UIColor coralColor], [UIColor tomatoColor], [UIColor orangeRed], [UIColor indianRed], [UIColor crimsonColor], [UIColor fireBrick]
@implementation JMBaseColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *colors = @[[UIColor blackColor], [UIColor whiteColor], [UIColor grayColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor], [UIColor darkGrayColor], [UIColor mistyRose], [UIColor fireBrick], [UIColor crimsonColor], [UIColor indianRed], [UIColor lightSalmon], [UIColor tomatoColor], [UIColor coralColor],[UIColor salmonColor], [UIColor waterPink], [UIColor lotusRoot], [UIColor deepPink], [UIColor paleVioletRed], [UIColor peachRed], [UIColor mediumPink],[UIColor lightPink], [UIColor tanColor], [UIColor rosyBrown], [UIColor peruColor], [UIColor chocolateColor], [UIColor bronzeColor], [UIColor siennaColor],[UIColor saddleBrown], [UIColor soilColor], [UIColor maroonColor], [UIColor inkfishBrown], [UIColor lavender], [UIColor dimGray], [UIColor silverColor]];
        
        for (UIColor *color in colors) {
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            button.backgroundColor = color;
            button.layer.cornerRadius = 15;
            button.layer.borderWidth = 1;
            button.layer.borderColor = JMTabViewBaseColor.CGColor;
            [self addSubview:button];
            [button addTarget:self action:@selector(chouseColor:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        self.contentSize = CGSizeMake(35*colors.count, self.height);
    }
    return self;
}

- (void)chouseColor:(UIButton *)sender
{
    if (self.colorBlock) {self.colorBlock(sender.backgroundColor);}
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat margin = 5.0;
    CGFloat width = 30;
    
    for (UIView *view in self.subviews) {
        
        view.frame = CGRectMake(margin + (margin + width) * i, 0, 30, 30);
        i ++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
