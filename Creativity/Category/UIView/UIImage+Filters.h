//
//  UIImage+Filters.h
//  Creativity
//
//  Created by ZhaoJM on 16/3/19.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filters)

- (UIImage *)setFiltersByIndex:(NSInteger)index;

// 滤镜方法
- (UIImage *)saturateImage:(float)saturationAmount withContrast:(float)contrastAmount;
- (UIImage *)vignetteWithRadius:(float)inputRadius andIntensity:(float)inputIntensity;
- (UIImage *)blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName;
- (UIImage *)curveFilter;
- (UIImage *)worn;
- (UIImage *)defaultFilter:(NSInteger)index;
- (UIImage *)imageFromContext:(CIContext*)context withFilter:(CIFilter*)filter;

// 高斯模糊
- (UIImage *)gaussianBlur:(float)inputRadius;

// 修改色相
- (UIImage *)hueAdjust:(float)inputAngle;

// 修改色温
- (UIImage *)temperatureAndTint:(float)inputNeutral inputTargetNeutral:(float)inputTargetNeutral;

// 曲线调整
- (UIImage *)toneCurve;

// 白平衡
- (UIImage *)whitePointAdjust:(CIColor *)color;

// 通过应用一组多项式交叉积来修改图像中的像素值
- (UIImage *)colorCrossPolynomial:(CIVector *)redCoefficients greenCoefficients:(CIVector *)greenCoefficients blueCoefficients:(CIVector *)blueCoefficients;

// 使用三维颜色表来转换源图像像素，并将结果映射到指定的颜色空间
- (UIImage *)colorCubeinput:(float)cubeDimension;

// 使用表中提供的映射值执行源颜色值的非线性变换
- (UIImage *)colorMap:(UIImage *)ciimage;

//
- (UIImage *)falseColor:(CIColor *)color1 color2:(CIColor *)color2;

//
- (UIImage *)bumpDistortion:(CIVector *)inputCenter radius:(float)radius scale:(float)scale;

//
- (UIImage *)additionCompositing:(UIImage *)inputBackgroundImage;

//
- (UIImage *)vignette:(float)inputRadius inputIntensity:(float)inputIntensity;

//
- (UIImage *)bloom:(float)inputRadius inputIntensity:(float)inputIntensity;

// 强调边缘
- (UIImage *)sepiaTones:(float)Intensity;
- (UIImage *)edges:(float)inputIntensity;
- (UIImage *)highlightShadowAdjust:(float)inputHighlightAmount shadowAmount:(float)inputShadowAmount;
- (UIImage *)lineOverlay:(float)noiseLevel sharpness:(float)sharpness intensity:(float)intensity threshold:(float)threshold ontrast:(float)ontrast;

#warning 一下方法不能用不能使用
- (UIImage *)glassDistortion:(UIImage *)texture center:(CIVector *)center scale:(float)scale;
- (UIImage *)lightTunnel:(CIVector *)center rotation:(float)rotation radius:(float)radius;
// 强调边缘 风格化的黑白渲染的图像，看起来类似于木块切口。
- (UIImage *)edgeWork:(float)inputIntensity;
// 使用三维颜色表来转换源图像像素
- (UIImage *)colorCubeData:(NSData *)data inputCubeDimension:(float)cubeDimension;

@end
