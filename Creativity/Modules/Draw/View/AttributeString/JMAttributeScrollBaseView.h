//
//  JMAttributeScrollBaseView.h
//  Creativity
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^attributeFontset)(NSString *fontName, NSInteger fontType);
@interface JMAttributeScrollBaseView : UIView
@property (nonatomic, strong) NSArray *fontNames;
@property (nonatomic, copy) attributeFontset attributeFontset;
@end
