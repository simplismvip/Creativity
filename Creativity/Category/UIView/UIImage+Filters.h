//
//  UIImage+Filters.h
//  Creativity
//
//  Created by ZhaoJM on 16/3/19.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filters)
- (UIImage *)saturateImage:(float)saturationAmount withContrast:(float)contrastAmount;
- (UIImage *)vignetteWithRadius:(float)inputRadius andIntensity:(float)inputIntensity;
- (UIImage *)blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName;
- (UIImage *)curveFilter;
- (UIImage *)worn;
- (UIImage *)defaultFilter:(NSInteger)index;
@end
