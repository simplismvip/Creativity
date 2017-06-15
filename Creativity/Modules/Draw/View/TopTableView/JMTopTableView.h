//
//  JMTopTableView.h
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    JMTopBarTypeBack=0,
//    JMTopBarTypeColor=1,
    JMTopBarTypeShare,
    JMTopBarTypeAdd,
    JMTopBarTypepaint,
    JMTopBarTypeclear,
//    JMTopBarTypeSource,
    JMTopBarTypeNote
//    JMTopBarTypeWidth
} JMBottomType;

@protocol JMTopTableViewDelegate <NSObject>

- (void)topTableView:(JMBottomType)bottomType didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface JMTopTableView : UIView
@property (nonatomic, weak) id <JMTopTableViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
