//
//  JMSelectEmojiView.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/4.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSubImageModel;
typedef void(^emojiBlock)(JMSubImageModel *model);

@interface JMSelectEmojiView : UIView
@property (nonatomic, copy) emojiBlock modelBlock;
- (void)reloadData:(NSMutableArray *)data;
@end
