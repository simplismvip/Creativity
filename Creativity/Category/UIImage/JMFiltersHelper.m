//
//  JMFiltersHelper.m
//  PhotoFilters
//
//  Created by JM Zhao on 2017/7/20.
//  Copyright © 2017年 Icoms. All rights reserved.
//

#import "JMFiltersHelper.h"

@interface JMFiltersHelper()
@property (nonatomic, strong) CIContext *context;
@end

@implementation JMFiltersHelper

- (CIContext *)context
{
    if (!_context) {self.context = [CIContext contextWithOptions:nil];}
    return _context;
}

- (UIImage *)saturateImage:(UIImage *)image saturationAmount:(float)saturationAmount withContrast:(float)contrastAmount
{
    UIImage *sourceImage = image;
    CIFilter *filter= [CIFilter filterWithName:@"CIColorControls"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:sourceImage];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:saturationAmount] forKey:@"inputSaturation"];
    [filter setValue:[NSNumber numberWithFloat:contrastAmount] forKey:@"inputContrast"];
    return [self imageFromContext:self.context image:image withFilter:filter];
}

- (UIImage *)vignetteWithImage:(UIImage *)image Radius:(float)inputRadius andIntensity:(float)inputIntensity
{
    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:inputIntensity] forKey:@"inputIntensity"];
    [filter setValue:[NSNumber numberWithFloat:inputRadius] forKey:@"inputRadius"];
    return [self imageFromContext:self.context image:image withFilter:filter];
}

- (UIImage *)blendModeImage:(UIImage *)image model:(NSString *)blendMode withImageNamed:(NSString *) imageName
{
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    //try with different textures
    CIImage *bgCIImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:imageName]];
    CIFilter *filter= [CIFilter filterWithName:blendMode];
    
    // inputBackgroundImage most be the same size as the inputImage
    [filter setValue:inputImage forKey:@"inputBackgroundImage"];
    [filter setValue:bgCIImage forKey:@"inputImage"];
    return [self imageFromContext:self.context image:image withFilter:filter];
}

- (UIImage *)curveFilterImage:(UIImage *)image
{
    CIImage *inputImage =[[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIToneCurve"];
    [filter setDefaults];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:0.0 Y:0.0] forKey:@"inputPoint0"]; // default
    [filter setValue:[CIVector vectorWithX:0.25 Y:0.15] forKey:@"inputPoint1"];
    [filter setValue:[CIVector vectorWithX:0.5 Y:0.5] forKey:@"inputPoint2"];
    [filter setValue:[CIVector vectorWithX:0.75 Y:0.85] forKey:@"inputPoint3"];
    [filter setValue:[CIVector vectorWithX:1.0 Y:1.0] forKey:@"inputPoint4"]; // default
    return [self imageFromContext:self.context image:image withFilter:filter];
}

- (UIImage *)wornImage:(UIImage *)image
{
    CIImage *beginImage = [[CIImage alloc] initWithImage:image];
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
 
    CGImageRef imageRef = [self.context createCGImage:outputImageC fromRect:outputImageC.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
}

- (UIImage *)defaultFilterImage:(UIImage *)image index:(NSInteger)index
{
    NSArray *filters = @[@"CIPhotoEffectNoir", @"CIPhotoEffectTransfer", @"CIPhotoEffectTonal", @"CIPhotoEffectProcess", @"CIPhotoEffectMono", @"CIPhotoEffectInstant", @"CIPhotoEffectFade", @"CIPhotoEffectChrome", @"CIMaskToAlpha", @"CIColorPosterize", @"CIColorInvert", @"CIWhitePointAdjust", @"CISRGBToneCurveToLinear", @"CILinearToSRGBToneCurve"];
    
    if (index < filters.count) {
        
        CIImage *ci = [[CIImage alloc] initWithImage:image];
        CIFilter *filte = [CIFilter filterWithName:filters[index]];
        [filte setValue:ci forKey:kCIInputImageKey];
        return [self imageFromContext:self.context image:image withFilter:filte];
    }else{
        return image;
    }
}

- (UIImage *)imageFromContext:(CIContext*)context image:(UIImage *)image withFilter:(CIFilter*)filter
{
    CGImageRef imageRef = [context createCGImage:[filter outputImage] fromRect:filter.outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
}

@end
