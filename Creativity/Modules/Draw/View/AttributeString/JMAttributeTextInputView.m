//
//  JMAttributeTextInputView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMAttributeTextInputView.h"
#import "JMAttributeScrollBaseView.h"
#import "StaticClass.h"

//输入框高度
#define kInputHeight 35
#define kButtonMargin 10
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface JMAttributeTextInputView () <UITextViewDelegate>

/***文本输入框最高高度***/
@property (nonatomic, assign) NSInteger textInputMaxHeight;

/***文本输入框高度***/
@property (nonatomic, assign) CGFloat textInputHeight;

/***键盘高度***/
@property (nonatomic, assign) CGFloat keyboardHeight;

/***当前键盘是否可见*/
@property (nonatomic,assign) BOOL keyboardIsVisiable;
@property (nonatomic,assign) CGFloat origin_y;
@property (nonatomic, strong) JMAttributeScrollBaseView *baseAttribute;
@property (nonatomic, assign) BOOL isSelect;
@end

@implementation JMAttributeTextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.origin_y = frame.origin.y;
        self.isSelect = YES;
        [self initView];
        [self setupSubviews];
        [self addEventListening];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    if (!self.textViewMaxLine || self.textViewMaxLine == 0) {
        self.textViewMaxLine = 4;
    }
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine
{
    _textViewMaxLine = textViewMaxLine;
    _textInputMaxHeight = ceil(self.textInput.font.lineHeight * (textViewMaxLine - 1) +
                               self.textInput.textContainerInset.top + self.textInput.textContainerInset.bottom);
}

// 添加通知
- (void)addEventListening
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 初始化UI
 */
- (void)setupSubviews {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    line.backgroundColor = RGBACOLOR(227, 228, 232, 1);
    [self addSubview:line];
    
    self.textInput = [[UITextView alloc] initWithFrame:CGRectMake(10, (self.height - kInputHeight)/2, self.width - 65, kInputHeight)];
    self.textInput.font = [UIFont systemFontOfSize:15];
    self.textInput.backgroundColor = [UIColor whiteColor];
    self.textInput.layer.cornerRadius = 9;
    self.textInput.layer.borderColor = RGBACOLOR(227, 228, 232, 0.5).CGColor;
    self.textInput.layer.borderWidth = 1;
    self.textInput.layer.masksToBounds = YES;
    self.textInput.returnKeyType = UIReturnKeySend;
    self.textInput.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textInput.enablesReturnKeyAutomatically = YES;
    self.textInput.delegate = self;
    [self addSubview:self.textInput];
    
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (self.height - kInputHeight)/2, self.width - 65, kInputHeight)];
    self.placeholderLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.placeholderLabel.font = self.textInput.font;
    if (!self.placeholderLabel.text.length) {
        self.placeholderLabel.text = @" ";
    }
    [self addSubview:self.placeholderLabel];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(CGRectGetMaxX(self.textInput.frame)+10, (self.height - kInputHeight)/2, 32, 32);
    [button addTarget:self action:@selector(fontAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTintColor:[UIColor redColor]];
    [button setImage:[UIImage imageNamed:@"textNote"] forState:(UIControlStateNormal)];
    [self addSubview:button];
}

- (void)fontAction:(UIButton *)sender
{
    if (_isSelect) {
        
        _textInput.inputView = self.baseAttribute;
        [_textInput becomeFirstResponder];
        [_textInput reloadInputViews];
        [sender setTitle:@"完成" forState:(UIControlStateNormal)];
        [sender setImage:nil forState:(UIControlStateNormal)];
        
    }else{
    
        _textInput.inputView = nil;
        [_textInput becomeFirstResponder];
        [_textInput reloadInputViews];
        [sender setTitle:@"" forState:(UIControlStateNormal)];
        [sender setImage:[UIImage imageNamed:@"textNote"] forState:(UIControlStateNormal)];
    }
    
    _isSelect = !_isSelect;
}
#pragma mark keyboardnotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardFrame.size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:7];
    self.y = keyboardFrame.origin.y - self.height;
    [UIView commitAnimations];
    self.keyboardIsVisiable = YES;
    if (self.keyIsVisiableBlock) {
        self.keyIsVisiableBlock(YES);
    }
}
- (void)keyboardWillHidden:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.y = self.origin_y;
    }];
    
    self.keyboardIsVisiable = NO;
    if (self.keyIsVisiableBlock) {
        self.keyIsVisiableBlock(NO);
    }
}
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length;
    _textInputHeight = ceilf([self.textInput sizeThatFits:CGSizeMake(self.textInput.width, MAXFLOAT)].height);
    self.textInput.scrollEnabled = _textInputHeight > _textInputMaxHeight && _textInputMaxHeight > 0;
    if (self.textInput.scrollEnabled) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:7];
        self.textInput.height = 5 + _textInputMaxHeight;
        self.y = SCREEN_HEIGHT - _keyboardHeight - _textInputMaxHeight - 5 - 10;
        self.height = _textInputMaxHeight + 15;
        [UIView commitAnimations];
        
    } else {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:7];
        self.textInput.height = _textInputHeight;
        self.y = SCREEN_HEIGHT - _keyboardHeight - _textInputHeight - 5 - 8;
        self.height = _textInputHeight + 15;
        [UIView commitAnimations];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 点击return按钮
    if ([text isEqualToString:@"\n"]){
        
        if (self.inputAttribute) {self.inputAttribute(self.textInput.text);}
        [self sendSuccessEndEditing];
        return NO;
    }
    return YES;
}

// 发送按钮
- (void)didClickSendBtn {
    
    if (self.inputAttribute) {
        
        self.inputAttribute(self.textInput.text);
    }
}

// 发送成功 清空文字 更新输入框大小
- (void)sendSuccessEndEditing {
    self.textInput.text = nil;
    [self.textInput.delegate textViewDidChange:self.textInput];
    [self endEditing:YES];
}

- (JMAttributeScrollBaseView *)baseAttribute
{
    if (!_baseAttribute) {
        
        JMAttributeScrollBaseView *baseAttribute = [[JMAttributeScrollBaseView alloc] initWithFrame:CGRectMake(0, 0, self.width, 258)];
        baseAttribute.attributeFontset = ^(NSString *fontName, NSInteger fontType) {
            
            if (fontName) {
                
                [StaticClass setFontName:fontName];
            }else{
            
                [StaticClass setFontType:fontType];
            }
        };
        
        self.baseAttribute = baseAttribute;
    }
    
    return _baseAttribute;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
