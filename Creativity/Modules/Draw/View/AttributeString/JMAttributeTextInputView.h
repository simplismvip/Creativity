//
//  JMAttributeTextInputView.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMAttributeTextInputView;
typedef void(^textInputAttribute)(NSString *sendContent);

@interface JMAttributeTextInputView : UIView
/**
 *  初始化chat bar
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  文本输入框
 */
@property (nonatomic,strong)UITextView *textInput;
/**
 *  设置输入框最大行数
 */
@property (nonatomic,assign)NSInteger textViewMaxLine;
/**
 *  textView占位符
 */
@property (nonatomic,strong)UILabel *placeholderLabel;

@property (nonatomic, copy) void (^keyIsVisiableBlock)(BOOL keyboardIsVisiable);
@property (nonatomic, copy) textInputAttribute inputAttribute;

// 发送成功
-(void)sendSuccessEndEditing;

@end
