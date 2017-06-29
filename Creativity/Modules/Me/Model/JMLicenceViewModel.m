//
//  JMLicenceViewModel.m
//  Creativity
//
//  Created by 赵俊明 on 2017/6/24.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMLicenceViewModel.h"
#import "JMLicenceModel.h"
#import "NSString+Extension.h"

@implementation JMLicenceViewModel

- (void)setModel:(JMLicenceModel *)model
{
    _model = model;
    
    CGSize copyrightFrame = [model.copyright sizeWithFont:[UIFont systemFontOfSize:15] maxW:kW-20];
    _copyrightFrame = copyrightFrame.height;
    
    
    CGSize sizeLower = [model.lower sizeWithFont:[UIFont systemFontOfSize:15] maxW:kW-20];
    _lowerFrame = sizeLower.height;
    
    CGSize sizeUpper = [model.upper sizeWithFont:[UIFont systemFontOfSize:15] maxW:kW-20];
    _upperFrame = sizeUpper.height;
    
    CGSize sizeAboveCopyright = [model.aboveCopyright sizeWithFont:[UIFont systemFontOfSize:15] maxW:kW-20];
    _aboveCopyrightFrame = sizeAboveCopyright.height;
    _cellFrame = _copyrightFrame+_lowerFrame+_upperFrame+_aboveCopyrightFrame;
    
}
@end
