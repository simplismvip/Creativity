//
//  JMColorView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/2.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMColorView.h"
#import "JMBaseColorView.h"


@interface JMColorView ()

@property (nonatomic, weak) UIImageView *colorSelectImage;
@property (nonatomic, weak) UIImageView *point;
@property (nonatomic, weak) UILabel *r_RGB;
@property (nonatomic, weak) UILabel *g_RGB;
@property (nonatomic, weak) UILabel *b_RGB;
@property (nonatomic, weak) UILabel *a_ALPHA;
@property (nonatomic, weak) JMBaseColorView *baseColorView;
@end

@implementation JMColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *r_RGB = [[UILabel alloc] init];
        r_RGB.font = [UIFont systemFontOfSize:11.0];
        r_RGB.textColor = JMTabViewBaseColor;
        r_RGB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:r_RGB];
        self.r_RGB = r_RGB;
        
        UILabel *g_RGB = [[UILabel alloc] init];
        g_RGB.font = [UIFont systemFontOfSize:11.0];
        g_RGB.textColor = JMTabViewBaseColor;
        g_RGB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:g_RGB];
        self.g_RGB = g_RGB;
        
        UILabel *b_RGB = [[UILabel alloc] init];
        b_RGB.font = [UIFont systemFontOfSize:11.0];
        b_RGB.textColor = JMTabViewBaseColor;
        b_RGB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:b_RGB];
        self.b_RGB = b_RGB;
        
        UILabel *a_ALPHA = [[UILabel alloc] init];
        a_ALPHA.text = [NSString stringWithFormat:@"A：%.2f", [StaticClass getAlpha]];
        a_ALPHA.font = [UIFont systemFontOfSize:11.0];
        a_ALPHA.textColor = JMTabViewBaseColor;
        a_ALPHA.textAlignment = NSTextAlignmentCenter;
        [self addSubview:a_ALPHA];
        self.a_ALPHA = a_ALPHA;
        
        JMBaseColorView *baseColorView = [[JMBaseColorView alloc] init];
        [self addSubview:baseColorView];
        
        JMSelf(ws)
        baseColorView.colorBlock = ^(UIColor *color) {
           
            if (ws.colorBlock && color) {
                
                ws.colorBlock(color);
                [ws set_RGBWithColor:color];
            }
        };
        
        self.baseColorView = baseColorView;
        
        UIImageView *point = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point.png"]];
        [self addSubview:point];
        self.point = point;
        
        [self set_RGBWithColor:[StaticClass getColor]];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat chassRadius = self.width*0.5;
    CGFloat absDistanceX = fabs(currentPoint.x - self.center.x);
    CGFloat absDistanceY = fabs(currentPoint.y - self.center.y);
    CGFloat currentToPointRadius = sqrtf(absDistanceX *absDistanceX + absDistanceY *absDistanceY);
    
    if (currentToPointRadius < chassRadius) {
        self.point.center = currentPoint;
        UIColor *color = [self getPixelColorAtLocation:currentPoint];
        
        if (self.colorBlock && color) {
            
            self.colorBlock(color);
            [self set_RGBWithColor:color];
        }
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat chassisRadius = self.width*0.5;
    CGFloat absDistanceX = (currentPoint.x - self.center.x);
    CGFloat absDistanceY = (currentPoint.y - self.center.y);
    CGFloat currentTopointRadius = sqrtf(absDistanceX * absDistanceX + absDistanceY *absDistanceY);
    
    if (currentTopointRadius <chassisRadius) {
        
        // 取色
        self.point.center = currentPoint;
        UIColor *color = [self getPixelColorAtLocation:currentPoint];
        
        if (self.colorBlock && color) {
            
            self.colorBlock(color);
            [self set_RGBWithColor:color];
        }
    }
}

- (void)set_RGBWithColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    int R = components[0] * 255;
    int G = components[1] * 255;
    int B = components[2] * 255;
    
    _r_RGB.text = [NSString stringWithFormat:@"R：%d",R];
    _g_RGB.text = [NSString stringWithFormat:@"G：%d",G];
    _b_RGB.text = [NSString stringWithFormat:@"B：%d",B];
}

- (UIColor *)getPixelColorAtLocation:(CGPoint)point
{
    UIColor *color = nil;
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef inImage = viewImage.CGImage;
    
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil;
    }
    
    size_t w = self.bounds.size.width;
    size_t h = self.bounds.size.height;
    
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void * bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = self.bounds.size.width;
    size_t pixelsHigh = self.bounds.size.height;
    
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8, bitmapBytesPerRow,
                                     colorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

- (void)setColor_Alpha:(NSString *)color_Alpha
{
    _color_Alpha = color_Alpha;
    _a_ALPHA.text = color_Alpha;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat y = self.width;
    CGFloat w = self.width/4;
    
    _r_RGB.frame = CGRectMake(0, y, w, 30);
    _g_RGB.frame = CGRectMake(CGRectGetMaxX(_r_RGB.frame), y, w, 30);
    _b_RGB.frame = CGRectMake(CGRectGetMaxX(_g_RGB.frame), y, w, 30);
    _a_ALPHA.frame = CGRectMake(CGRectGetMaxX(_b_RGB.frame), y, w, 30);
    _baseColorView.frame = CGRectMake(0, CGRectGetMaxY(_a_ALPHA.frame), y, 30);
    _point.frame = CGRectMake(100, 100, 30, 30);
}

- (void)drawRect:(CGRect)rect {

    UIImage *centerImage = [UIImage imageNamed:@"ColorPalette.png"];
    CGFloat size_W = self.width;
    [centerImage drawInRect:CGRectMake(size_W*0.5-size_W*0.9/2, size_W*0.05, size_W*0.9, size_W*0.9)];
}


@end
