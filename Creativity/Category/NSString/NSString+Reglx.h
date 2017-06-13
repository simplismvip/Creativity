//
//  NSString+Reglx.h
//  Text-图文混排
//
//  Created by Mac on 16/3/8.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Reglx)
- (BOOL)isQQ;
- (BOOL)isIpAddress;
- (BOOL)isPhoneNumber;
- (BOOL)isEmail;
- (BOOL)isUrl;
@end
