//
//  UIImage+Filters.m
//  Creativity
//
//  Created by ZhaoJM on 16/3/19.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "UIImage+Filters.h"
#import "JMFilterContent.h"

@implementation UIImage (Filters)

- (UIImage *)setFiltersByIndex:(NSInteger)index
{
    if (index == 0) {
        
        return [self saturateImage:1.7 withContrast:1];
        
    }else if (index == 1){
        
        return [self saturateImage:0 withContrast:1.05];
        
    }else if (index == 2){
        
        return [self vignetteWithRadius:0 andIntensity:18];
        
    }else if (index == 3){
        
        return [self blendMode:@"CIScreenBlendMode" withImageNamed:@"flowers.jpg"];
        
    }else if (index == 4){
        
        return [self blendMode:@"CISoftLightBlendMode" withImageNamed:@"paper.jpg"];
        
    }else if (index == 5){
        
        return [self curveFilter];
    }else if (index == 6){
        
        return [self gaussianBlur:5];
        
    }else if (index == 7){
        
        return [self hueAdjust:0.3];
        
    }else if (index == 8){
        
        return [self temperatureAndTint:3000 inputTargetNeutral:100];
        
    }else if (index == 9){
        
        return [self whitePointAdjust:[CIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:196.0/255.0]];
        
    }else if (index == 10){
        
        const CGFloat reds[] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        CIVector *red = [CIVector vectorWithValues:reds count:10];
        
        const CGFloat greens[] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        CIVector *green = [CIVector vectorWithValues:greens count:10];
        
        const CGFloat blues[] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        CIVector *blue = [CIVector vectorWithValues:blues count:10];
        
        return [self colorCrossPolynomial:red greenCoefficients:green blueCoefficients:blue];
        
    }else if (index == 11){
        
        return [self sepiaTones:1];
        
    }else if (index == 12){
        
        UIImage *imaNew = [UIImage imageNamed:@"text"];
        return [self colorMap:imaNew];
        
    }else if (index == 13){
        
        return [self falseColor:[CIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0] color2:[CIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0]];
        
    }else if (index == 14){
        
        return [self bloom:30 inputIntensity:0.5];
        
    }else if (index == 15){
        
        return [self edges:1.5];
    }else if (index == 16){
        
        return [self highlightShadowAdjust:.5 shadowAmount:-.7];
        
    }else if (index == 17){
        
        return [self lineOverlay:0.1 sharpness:0.9 intensity:1.0 threshold:0.2 ontrast:10.0];
        
    }else {
        
        return [self defaultFilter:index-19];
    }
}

- (UIImage *)sepiaTones:(float)Intensity
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, inputImage, @"inputIntensity", [NSNumber numberWithFloat:Intensity], nil];
    return [self imageFromContext:context withFilter:filter];
}

// 生成素描 > ios9
- (UIImage *)lineOverlay:(float)noiseLevel sharpness:(float)sharpness intensity:(float)intensity threshold:(float)threshold ontrast:(float)ontrast
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CILineOverlay"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:noiseLevel] forKey:@"inputNRNoiseLevel"];
    [filter setValue:[NSNumber numberWithFloat:sharpness] forKey:@"inputNRSharpness"];
    [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputEdgeIntensity"];
    [filter setValue:[NSNumber numberWithFloat:threshold] forKey:@"inputThreshold"];
    [filter setValue:[NSNumber numberWithFloat:ontrast] forKey:@"inputContrast"];
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)highlightShadowAdjust:(float)inputHighlightAmount shadowAmount:(float)inputShadowAmount
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:inputHighlightAmount] forKey:@"inputHighlightAmount"];
    [filter setValue:[NSNumber numberWithFloat:inputShadowAmount] forKey:@"inputShadowAmount"];
    return [self imageFromContext:context withFilter:filter];
    
}

// 强调边缘 风格化的黑白渲染的图像，看起来类似于木块切口。
- (UIImage *)edgeWork:(float)inputIntensity
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIEdgeWork"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:inputIntensity] forKey:@"inputRadius"];
    return [self imageFromContext:context withFilter:filter];
}

// 强调边缘
- (UIImage *)edges:(float)inputIntensity
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIEdges"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:inputIntensity] forKey:@"inputIntensity"];
    return [self imageFromContext:context withFilter:filter];
    
}

- (UIImage *)bloom:(float)inputRadius inputIntensity:(float)inputIntensity
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:inputRadius] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:inputIntensity] forKey:@"inputIntensity"];
    
    CGRect rect = [inputImage extent];
    rect.origin.x += (rect.size.width - self.size.width) / 2;
    rect.origin.y = (rect.size.height - self.size.height) / 2;
    rect.size = self.size;
    
    CGImageRef imageRef = [context createCGImage:[filter outputImage] fromRect:rect];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

#warning 不能使用
// 旋转由中心和半径参数指定的输入图像的一部分，以产生隧道效应
- (UIImage *)lightTunnel:(CIVector *)center rotation:(float)rotation radius:(float)radius
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CILightTunnel"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:rotation] forKey:@"inputRotation"];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    [filter setValue:center forKey:@"inputCenter"];
    return [self imageFromContext:context withFilter:filter];
}

// 毛玻璃文理效果
- (UIImage *)glassDistortion:(UIImage *)texture center:(CIVector *)center scale:(float)scale
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIGlassDistortion"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIImage *textureImage = [[CIImage alloc] initWithImage:texture];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:textureImage forKey:@"inputTexture"];
    [filter setValue:center forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
    return [self imageFromContext:context withFilter:filter];
}


// 默认值：[150 150] 默认值：300.00 默认值：0.50
- (UIImage *)bumpDistortion:(CIVector *)inputCenter radius:(float)radius scale:(float)scale
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortion"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:inputCenter forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)additionCompositing:(UIImage *)inputBackgroundImage
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIAdditionCompositing"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIImage *backgroundImage = [[CIImage alloc] initWithImage:inputBackgroundImage];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:backgroundImage forKey:@"inputBackgroundImage"];
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)vignette:(float)inputRadius inputIntensity:(float)inputIntensity
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    NSNumber *number1 = [NSNumber numberWithFloat:inputRadius];
    [filter setValue:number1 forKey:@"inputRadius"];
    NSNumber *number2 = [NSNumber numberWithFloat:inputIntensity];
    [filter setValue:number2 forKey:@"inputIntensity"];
    return [self imageFromContext:context withFilter:filter];
}

// 将亮度映射到两种颜色的颜色斜坡。
- (UIImage *)falseColor:(CIColor *)color1 color2:(CIColor *)color2
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:color1 forKey:@"inputColor0"];
    [filter setValue:color2 forKey:@"inputColor1"];
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)colorMap:(UIImage *)ciimage
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMap"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIImage *ciimageNew = [[CIImage alloc] initWithImage:ciimage];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:ciimageNew forKey:@"inputGradientImage"];
    return [self imageFromContext:context withFilter:filter];
}

// 最小值：2.00 最大值：128.00
- (UIImage *)colorCubeinput:(float)cubeDimension
{
    float color_cube_data[8*4] = {
        
        0.0, 0.0, 0.0, 1.0,
        1.0, 0.0, 0.0, 1.0,
        0.0, 1.0, 0.0, 1.0,
        1.0, 1.0, 0.0, 1.0,
        0.0, 0.0, 1.0, 1.0,
        1.0, 0.0, 1.0, 1.0,
        0.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0
    };
    
    NSData * cube_data =[NSData dataWithBytes:color_cube_data length:8*4*sizeof(uint8_t)];
    
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorCube"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    NSNumber *number = [NSNumber numberWithFloat:cubeDimension];
    [filter setValue:number forKey:@"inputCubeDimension"];
    [filter setValue:cube_data forKey:@"inputCubeData"];
    return [self imageFromContext:context withFilter:filter];
}

#warning 不能使用
- (UIImage *)colorCubeData:(NSData *)data inputCubeDimension:(float)cubeDimension
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filte = [CIFilter filterWithName:@"CIColorCubeWithColorSpace"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    [filte setValue:(__bridge id _Nullable)(colorSpace) forKey:@"inputColorSpace"];
    [filte setValue:data forKey:@"inputCubeData"];
    
    NSNumber *number = [NSNumber numberWithFloat:cubeDimension];
    [filte setValue:number forKey:@"inputCubeDimension"];
    [filte setValue:inputImage forKey:@"inputImage"];
    CGColorSpaceRelease(colorSpace);
    return [self imageFromContext:context withFilter:filte];
}

- (UIImage *)colorCrossPolynomial:(CIVector *)redCoefficients greenCoefficients:(CIVector *)greenCoefficients blueCoefficients:(CIVector *)blueCoefficients
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filte = [CIFilter filterWithName:@"CIColorCrossPolynomial"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filte setValue:redCoefficients forKey:@"inputRedCoefficients"];
    [filte setValue:greenCoefficients forKey:@"inputGreenCoefficients"];
    [filte setValue:blueCoefficients forKey:@"inputBlueCoefficients"];
    [filte setValue:inputImage forKey:@"inputImage"];
    
    return [self imageFromContext:context withFilter:filte];
}

// 白平衡
- (UIImage *)whitePointAdjust:(CIColor *)color
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filte = [CIFilter filterWithName:@"CIWhitePointAdjust"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    [filte setValue:inputImage forKey:@"inputImage"];
    [filte setValue:color forKey:@"inputColor"];
    
    return [self imageFromContext:context withFilter:filte];
}

// 图像的R，G和B通道的色调响应, 曲线调整
- (UIImage *)toneCurve
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filte = [CIFilter filterWithName:@"CIToneCurve"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filte setValue:[CIVector vectorWithX:0 Y:0] forKey:@"inputPoint0"];
    [filte setValue:[CIVector vectorWithX:0.3 Y:0.3] forKey:@"inputPoint1"];
    [filte setValue:[CIVector vectorWithX:0.5 Y:0.5] forKey:@"inputPoint2"];
    [filte setValue:[CIVector vectorWithX:0.75 Y:0.75] forKey:@"inputPoint3"];
    [filte setValue:[CIVector vectorWithX:1 Y:1] forKey:@"inputPoint4"];
    
    [filte setValue:inputImage forKey:@"inputImage"];
    
    return [self imageFromContext:context withFilter:filte];
}

// https://stackoverflow.com/questions/11464266/citemperatureandtint-for-image-in-ios
// CIVector 向量类
- (UIImage *)temperatureAndTint:(float)inputNeutral inputTargetNeutral:(float)inputTargetNeutral
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filte = [CIFilter filterWithName:@"CITemperatureAndTint"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filte setValue:[CIVector vectorWithX:inputNeutral Y:300] forKey:@"inputNeutral"];
    [filte setValue:[CIVector vectorWithX:inputTargetNeutral Y:1100] forKey:@"inputTargetNeutral"];
    
    [filte setValue:inputImage forKey:@"inputImage"];
    
    return [self imageFromContext:context withFilter:filte];
}

// max 3.14 min -3.14
- (UIImage *)hueAdjust:(float)inputAngle
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filte = [CIFilter filterWithName:@"CIHueAdjust"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    NSNumber *number = [NSNumber numberWithFloat:inputAngle];
    [filte setValue:inputImage forKey:@"inputImage"];
    [filte setValue:number forKey:@"inputAngle"];
    
    return [self imageFromContext:context withFilter:filte];
    
}

- (UIImage *)gaussianBlur:(float)inputRadius
{
    JMFilterContent *context = [JMFilterContent sharedInstance];
    CIFilter *filte = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    NSNumber *number = [NSNumber numberWithFloat:inputRadius];
    [filte setValue:inputImage forKey:@"inputImage"];
    [filte setValue:number forKey:@"inputRadius"];
    
    CGRect rect = [inputImage extent];
    rect.origin.x += (rect.size.width - self.size.width) / 2;
    rect.origin.y = (rect.size.height - self.size.height) / 2;
    rect.size = self.size;
    
    CGImageRef imageRef = [context createCGImage:[filte outputImage] fromRect:rect];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);    
    return image;
}

- (UIImage *)saturateImage:(float)saturationAmount withContrast:(float)contrastAmount{
    
    UIImage *sourceImage = self;
    JMFilterContent *context = [JMFilterContent sharedInstance];// [CIContext contextWithOptions:nil];
    CIFilter *filter= [CIFilter filterWithName:@"CIColorControls"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:sourceImage];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:saturationAmount] forKey:@"inputSaturation"];
    [filter setValue:[NSNumber numberWithFloat:contrastAmount] forKey:@"inputContrast"];
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)vignetteWithRadius:(float)inputRadius andIntensity:(float)inputIntensity
{
    JMFilterContent *context = [JMFilterContent sharedInstance];// [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:inputIntensity] forKey:@"inputIntensity"];
    [filter setValue:[NSNumber numberWithFloat:inputRadius] forKey:@"inputRadius"];
    return [self imageFromContext:context withFilter:filter];
}

-(UIImage *)worn
{
    CIImage *beginImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:@"CIWhitePointAdjust"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputColor",[CIColor colorWithRed:212 green:235 blue:200 alpha:1],
                        nil];
    CIImage *outputImage = [filter outputImage];
    
    CIFilter *filterB = [CIFilter filterWithName:@"CIColorControls"
                                   keysAndValues: kCIInputImageKey, outputImage,
                         @"inputSaturation", [NSNumber numberWithFloat:.8],
                         @"inputContrast", [NSNumber numberWithFloat:0.8],
                         nil];
    CIImage *outputImageB = [filterB outputImage];
    
    CIFilter *filterC = [CIFilter filterWithName:@"CITemperatureAndTint"
                                   keysAndValues: kCIInputImageKey, outputImageB,
                         @"inputNeutral",[CIVector vectorWithX:6500 Y:3000 Z:0],
                         @"inputTargetNeutral",[CIVector vectorWithX:5000 Y:0 Z:0],
                         nil];
    CIImage *outputImageC = [filterC outputImage];
    JMFilterContent *context = [JMFilterContent sharedInstance];// [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:outputImageC fromRect:outputImageC.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}


-(UIImage *)blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName{
    
    /*
     Blend Modes
     
     CISoftLightBlendMode
     CIMultiplyBlendMode
     CISaturationBlendMode
     CIScreenBlendMode
     CIMultiplyCompositing
     CIHardLightBlendMode
     */
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    //try with different textures
    CIImage *bgCIImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:imageName]];
    JMFilterContent *context = [JMFilterContent sharedInstance];// [CIContext contextWithOptions:nil];
    CIFilter *filter= [CIFilter filterWithName:blendMode];
    
    // inputBackgroundImage most be the same size as the inputImage
    [filter setValue:inputImage forKey:@"inputBackgroundImage"];
    [filter setValue:bgCIImage forKey:@"inputImage"];
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)curveFilter
{
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    JMFilterContent *context = [JMFilterContent sharedInstance];// [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIToneCurve"];
    [filter setDefaults];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:0.0 Y:0.0] forKey:@"inputPoint0"]; // default
    [filter setValue:[CIVector vectorWithX:0.25 Y:0.15] forKey:@"inputPoint1"];
    [filter setValue:[CIVector vectorWithX:0.5  Y:0.5] forKey:@"inputPoint2"];
    [filter setValue:[CIVector vectorWithX:0.75 Y:0.85] forKey:@"inputPoint3"];
    [filter setValue:[CIVector vectorWithX:1.0 Y:1.0] forKey:@"inputPoint4"]; // default
    
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)imageFromContext:(CIContext*)context withFilter:(CIFilter*)filter
{
    CGImageRef imageRef = [context createCGImage:[filter outputImage] fromRect:filter.outputImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

// 14
- (UIImage *)defaultFilter:(NSInteger)index
{
    NSArray *filters = @[@"CIPhotoEffectNoir", @"CIPhotoEffectTransfer", @"CIPhotoEffectProcess", @"CIPhotoEffectMono", @"CIPhotoEffectInstant", @"CIPhotoEffectFade", @"CIPhotoEffectChrome", @"CIMaskToAlpha", @"CIColorPosterize", @"CIColorInvert", @"CIWhitePointAdjust", @"CISRGBToneCurveToLinear", @"CILinearToSRGBToneCurve"];
    
    if (index < filters.count) {
        
        JMFilterContent *context = [JMFilterContent sharedInstance];// [CIContext contextWithOptions:nil];
        CIImage *ci = [[CIImage alloc] initWithImage:self];
        CIFilter *filte = [CIFilter filterWithName:filters[index]];
        [filte setValue:ci forKey:kCIInputImageKey];
        return [self imageFromContext:context withFilter:filte];
        
    }else{
        
        return self;
    }
}

@end
