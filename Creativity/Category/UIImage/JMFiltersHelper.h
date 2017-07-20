//
//  JMFiltersHelper.h
//  PhotoFilters
//
//  Created by JM Zhao on 2017/7/20.
//  Copyright © 2017年 Icoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMFiltersHelper : NSObject
- (UIImage *)saturateImage:(UIImage *)image saturationAmount:(float)saturationAmount withContrast:(float)contrastAmount;
- (UIImage *)vignetteWithImage:(UIImage *)image Radius:(float)inputRadius andIntensity:(float)inputIntensity;
- (UIImage *)blendModeImage:(UIImage *)image model:(NSString *)blendMode withImageNamed:(NSString *) imageName;
- (UIImage *)curveFilterImage:(UIImage *)image;
- (UIImage *)wornImage:(UIImage *)image;
- (UIImage *)defaultFilterImage:(UIImage *)image index:(NSInteger)index;
@end
