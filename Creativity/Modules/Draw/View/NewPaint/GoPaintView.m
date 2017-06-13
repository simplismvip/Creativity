//
//  GoPaintView.m
//  Wu-五子棋
//
//  Created by JM Zhao on 2017/5/25.
//  Copyright © 2017年 ZhaoJunMing. All rights reserved.
//

#import "GoPaintView.h"

@interface GoPaintView()
@property (nonatomic, strong) NSMutableArray *widths;
@property (nonatomic, strong) NSMutableArray *heights;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *white;
@property (nonatomic, strong) NSMutableArray *black;
@property (nonatomic, assign) BOOL is;
@end

@implementation GoPaintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.array = [NSMutableArray array];
        self.white = [NSMutableArray array];
        self.black = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        
        self.widths = [NSMutableArray array];
        while (self.distanceWidth < frame.size.width) {
            
            CGPoint pointStart = CGPointMake(self.distanceWidth, 0);
            CGPoint pointEnd = CGPointMake(self.distanceWidth, frame.size.height);
            NSValue *valueS = [NSValue valueWithCGPoint:pointStart];
            NSValue *valueE = [NSValue valueWithCGPoint:pointEnd];
            self.distanceWidth = self.distanceWidth + 20;
            NSDictionary *dict = @{@"start":valueS, @"end":valueE};
            [_widths addObject:dict];
        }
        
        self.heights = [NSMutableArray array];
        while (self.distanceHeight < frame.size.height) {
            
            CGPoint pointStart = CGPointMake(0, self.distanceHeight);
            CGPoint pointEnd = CGPointMake(frame.size.width, self.distanceHeight);
            NSValue *valueS = [NSValue valueWithCGPoint:pointStart];
            NSValue *valueE = [NSValue valueWithCGPoint:pointEnd];
            self.distanceHeight = self.distanceHeight + 20;
            NSDictionary *dict = @{@"start":valueS, @"end":valueE};
            [_heights addObject:dict];
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat xP = point.x;
    CGFloat yP = point.y;
    
    // 标记最小值和取到的x
    CGFloat min = 0.0;
    CGFloat minX = 0.0;
    
    // 遍历拿出距离点击点最近的两个view, 然后找到交点
    int i = 0;
    for (NSDictionary *dic in self.widths) {
        
        NSValue *valueS = dic[@"start"];
        CGPoint point = valueS.CGPointValue;
        CGFloat x = point.x;
        CGFloat x1 = fabs(xP - x);
        
        if (i == 0) {
            
            min = x1;
        }else{
            
            if (min > x1) {
                
                min = x1;
                minX = x;
            }
        }
        i ++;
    }
    
    // 标记最小值和取到的y
    CGFloat min1 = 0.0;
    CGFloat minY = 0.0;
    // 遍历拿出距离点击点最近的两个view, 然后找到交点
    int j = 0;
    for (NSDictionary *dic in self.heights) {
        
        NSValue *valueS = dic[@"start"];
        CGPoint point = valueS.CGPointValue;
        CGFloat y = point.y;
        CGFloat y1 = fabs(yP - y);
        
        if (j == 0) {
            
            min1 = y1;
        }else{
            
            if (min1 > y1) {
                
                min1 = y1;
                minY = y;
            }
        }
        j ++;
    }
    
    
    // 获取位置
    [self getLocation:CGPointMake(minX, minY)];
    
    // 获取黑子白子位置
    [self locationWhite];
    [self locationBlack];
}

- (void)locationWhite
{
    CGPoint point = CGPointMake(0.0, 0.0);
    int i = 0;
    
    if (self.white.count == 0) return;
    
    // 排序
    for (int i = 0; i < self.white.count - 1; i ++) {
        
        for (int j = 0; j < self.white.count - i - 1; j++) {
            
            UIImageView *view = self.white[j];
            CGFloat x = view.center.x;
            
            UIImageView *view1 = self.white[j + 1];
            CGFloat x1 = view1.center.x;
            
            if (x > x1) {
                
                UIImageView *temp = nil;
                temp = self.white[j];
                self.white[j] = self.white[j + 1];
                self.white[j + 1] = temp;
            }
        }
    }
    
    for (UIImageView *view in self.white) {
        
        if (i == 0) {
            
            point = view.center;
            i ++;
        }else {
            
            if (point.y == view.center.y && (int)fabs(point.x - view.center.x) == 20) {
                
                point = view.center;
                i ++;
            }else{
                point = view.center;
            }
            
            if (i == 5) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"白子胜" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
                
            }
        }
    }
}

- (void)locationBlack
{
    CGPoint point = CGPointMake(0.0, 0.0);
    int i = 0;
    
    if (self.black.count == 0) return;
    
    // 排序
    for (int i = 0; i < self.black.count - 1; i ++) {
        
        for (int j = 0; j < self.black.count - i - 1; j++) {
            
            UIImageView *view = self.black[j];
            CGFloat y = view.center.y;
            
            UIImageView *view1 = self.black[j + 1];
            CGFloat y1 = view1.center.y;
            
            if (y > y1) {
                
                UIImageView *temp = nil;
                temp = self.black[j];
                self.black[j] = self.black[j + 1];
                self.black[j + 1] = temp;
            }
        }
    }
    
    for (UIImageView *view in self.black) {
        
        if (i == 0) {
            
            point = view.center;
            i ++;
        }else {
            
            if (point.x == view.center.x && (int)fabs(point.y - view.center.y) == 20) {
                
                point = view.center;
                i ++;
            }else{
                point = view.center;
            }
            
            if (i == 5) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"黑子胜" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
                
            }
        }
    }
}

- (void)getLocation:(CGPoint)point
{
    UIImageView *view = [[UIImageView alloc] init];
    
    if (self.is) {
        view.image = [UIImage imageNamed:@"01"];
        [self.white addObject:view];
        view.tag = 1;
        _is = NO;
        
    }else {
        view.image = [UIImage imageNamed:@"02"];
        [self.black addObject:view];
        view.tag = 2;
        _is = YES;
    }
    
    view.frame = CGRectMake(0, 0, 15, 15);
    view.center = point;
    [self addSubview:view];
}

- (void)drawRect:(CGRect)rect {
    
    for (NSDictionary *width in self.widths) {
    
        NSValue *valueS = width[@"start"];
        NSValue *valueE = width[@"end"];
        UIBezierPath *beziPath = [UIBezierPath bezierPath];
        beziPath.lineWidth = 1.0;
        [beziPath moveToPoint:valueS.CGPointValue];
        [beziPath addLineToPoint:valueE.CGPointValue];
        [[UIColor grayColor] set];
        [beziPath stroke];
    }
    
    for (NSDictionary *width in self.heights) {
        
        NSValue *valueS = width[@"start"];
        NSValue *valueE = width[@"end"];
        UIBezierPath *beziPath = [UIBezierPath bezierPath];
        beziPath.lineWidth = 1.0;
        [beziPath moveToPoint:valueS.CGPointValue];
        [beziPath addLineToPoint:valueE.CGPointValue];
        [[UIColor grayColor] set];
        [beziPath stroke];
    }
}

@end
