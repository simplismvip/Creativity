//
//  JMPaintView.m
//  YaoYao
//
//  Created by JM Zhao on 2016/12/22.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMPaintView.h"
#import "JMPaintTools.h"
#import <QuartzCore/QuartzCore.h>
#import "UserDefaultTools.h"
#import "StaticClass.h"

#define PARTIAL_REDRAW  0

@interface JMPaintView ()
{
    CGPoint startP;
    CGPoint endP;
    NSMutableArray *_widthPoint;
    NSMutableArray *_heightPoint;
}

@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;

// 记录点
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) id<JMPaintTool> currentTool;

@end

#pragma mark -
@implementation JMPaintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    self.points = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.5;

}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
    [self.currentTool draw];
}

- (void)updateCacheImage:(BOOL)redraw
{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        
        self.image = nil;
        for (id<JMPaintTool> tool in self.pathArray) {[tool draw];}
    }else {
        
        [self.image drawInRect:self.bounds];
        [self.currentTool draw];
    }
    
    // 存储照片
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (id<JMPaintTool>)toolWithCurrentSettingsWithType:(JMPaintToolType)type isFill:(BOOL)isFill imageName:(NSString *)imageName text:(NSString *)drawString fontSize:(CGFloat)fontSize fontName:(NSString *)fontName fontType:(NSInteger)fontType
{
    if (type == JMPaintToolTypePen) {
        JMPaintPenTool *pen = [JMPaintPenTool new];
        return pen;
        
    }else if (type == JMPaintToolTypeLine){
    
        JMPaintLineTool *line = [JMPaintLineTool new];
        return line;
        
    }else if (type == JMPaintToolTypeRectagle){
        
        JMPaintRectangleTool *tool = [JMPaintRectangleTool new];
        tool.fill = isFill;
        return tool;

    }else if (type == JMPaintToolTypeEllipse){
    
        JMPaintEllipseTool *tool = [JMPaintEllipseTool new];
        tool.fill = isFill;
        return tool;
        
    }else if (type == JMPaintToolTypeArrow){
        
        DrawingToolArrow *tool = [DrawingToolArrow new];
        return tool;
        
    }else if (type == JMPaintToolTypeImage){
        
        JMPaintToolImage *tool = [JMPaintToolImage new];
        tool.linesOffSet = [UserDefaultTools readFloatByKey:@"offSetvalue"];
        tool.drawImage = imageName;
        return tool;
        
    }else if (type == JMPaintToolTypeText){
        
        JMPaintToolText *tool = [JMPaintToolText new];
        tool.linesOffSet = [UserDefaultTools readFloatByKey:@"offSetvalue"];
        tool.drawText = drawString;
        tool.fontName = fontName;
        tool.fontSize = fontSize;
        tool.type = fontType;
        return tool;
    }else{
        return nil;
    }
}

#pragma mark - Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentTool = [self toolWithCurrentSettingsWithType:self.drawType isFill:self.isFill imageName:self.paintImage text:self.paintText fontSize:[StaticClass getLineWidth] fontName:[StaticClass getFontName] fontType:[StaticClass getFontType]];
    self.currentTool.linesWidth = [StaticClass getLineWidth];
    self.currentTool.linesColor = [StaticClass getColor];
    self.currentTool.linesAlpha = [StaticClass getAlpha];
    self.currentTool.LineDash = self.lineDash;
    [self.pathArray addObject:self.currentTool];
    
    CGPoint startPoint = [self pointWithTouches:touches];
    [self.currentTool setInitialPoint:startPoint];
    
    // 记录数据
    NSString *point = NSStringFromCGPoint(startPoint);
    [self.points addObject:point];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint previousLocation = [touch previousLocationInView:self];
    CGPoint endPoint = [self pointWithTouches:touches];
    [self.currentTool moveFromPoint:previousLocation toPoint:endPoint];
    
    // 画曲线的时候持续记录数据
    if (_drawType == JMPaintToolTypePen) {
        
        NSString *pointPrevious = NSStringFromCGPoint(previousLocation);
        [self.points addObject:pointPrevious];
        
        NSString *point = NSStringFromCGPoint(endPoint);
        [self.points addObject:point];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint previousLocation = [touch previousLocationInView:self];
    CGPoint endPoint = [self pointWithTouches:touches];
    
    NSString *pointPrevious = NSStringFromCGPoint(previousLocation);
    [self.points addObject:pointPrevious];
    
    NSString *point = NSStringFromCGPoint(endPoint);
    [self.points addObject:point];
    [self.points removeAllObjects];
    
    [self updateCacheImage:NO];
    self.currentTool = nil;
    [self.bufferArray removeAllObjects];
}

// 获取触摸点
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 取消点击
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - 清空/重做/恢复
- (void)clearAll
{
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}

- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
}

- (BOOL)canUndo
{
    return self.pathArray.count > 0;
}

- (void)undoLatestStep
{
    if ([self canUndo]) {
        id<JMPaintTool>tool = [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
}

- (void)redoLatestStep
{
    if ([self canRedo]) {
        
        id<JMPaintTool>tool = [self.bufferArray lastObject];
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (void)dealloc
{
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    JMLog(@"销毁--JMPaintView");
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    JMPaintToolImage *tool = [JMPaintToolImage new];
    tool.image = image;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [tool draw];
    _image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.pathArray addObject:tool];
    
}

@end
