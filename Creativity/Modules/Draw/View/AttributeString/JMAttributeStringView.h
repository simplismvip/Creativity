//
//  JMAttributeStringView.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^drawFontName)(NSString *fontName, NSInteger fontType);
@interface JMAttributeStringView : UIView
@property (nonatomic, copy) drawFontName fontname;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
