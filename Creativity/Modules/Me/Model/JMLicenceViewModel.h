//
//  JMLicenceViewModel.h
//  Creativity
//
//  Created by 赵俊明 on 2017/6/24.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMLicenceModel;
@interface JMLicenceViewModel : NSObject

@property (nonatomic, strong) JMLicenceModel *model;
@property (nonatomic, assign) CGFloat headeTitleFrame;
@property (nonatomic, assign) CGFloat copyrightFrame;
@property (nonatomic, assign) CGFloat lowerFrame;
@property (nonatomic, assign) CGFloat upperFrame;
@property (nonatomic, assign) CGFloat aboveCopyrightFrame;
@property (nonatomic, assign) CGFloat cellFrame;
@end
