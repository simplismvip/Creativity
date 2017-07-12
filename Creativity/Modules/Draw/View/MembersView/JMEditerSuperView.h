//
//  JMEditerSuperView.h
//  Creativity
//
//  Created by JM Zhao on 2017/7/12.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editerDone)(UIImage *image);
@interface JMEditerSuperView : UIView
@property (nonatomic, copy) editerDone editerDone;
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, strong) UIImage *image;
@end
