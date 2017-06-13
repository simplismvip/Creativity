//
//  JMHomeCollectionViewFlowLayout.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMHomeCollectionViewFlowLayout.h"

@interface JMHomeCollectionViewFlowLayout()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

// 当前indexPath
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

// 移动的中心点
@property (nonatomic, assign) CGPoint movePoint;

// 移动的视图
@property (nonatomic, strong) UIView *moveView;

@end

@implementation JMHomeCollectionViewFlowLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureObserver];
    }
    return self;
}

#pragma mark - 添加观察者

- (void)configureObserver
{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self setUpGestureRecognizers];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 长按手势
- (void)setUpGestureRecognizers
{
    if (self.collectionView == nil) {return;}
    [self.collectionView addGestureRecognizer:self.longGesture];
}

#pragma mark - 手势动画
- (void)longGesture:(UILongPressGestureRecognizer *)gesture
{
    if (!self.inEditState) {[self setInEditState:YES];}
    
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan: {
            CGPoint location = [gesture locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
            
            // 如果indexPath为空，不做任何操作
            if (indexPath == nil || indexPath.section != 0) return;
            self.currentIndexPath = indexPath;
            UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            
            // 得到当前cell的映射(截图)
            self.moveView = [targetCell snapshotViewAfterScreenUpdates:YES];
            self.moveView.layer.borderWidth = 3;
            self.moveView.layer.borderColor = JMBaseColor.CGColor;
            self.moveView.layer.cornerRadius = 10;
            self.moveView.layer.masksToBounds = YES;
            
            [self.collectionView addSubview:self.moveView];
            targetCell.hidden = YES;
            self.moveView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.moveView.center = location;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [gesture locationInView:self.collectionView];
            
            // 更新cell的位置
            self.moveView.center = point;
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil)  return;
            if (indexPath.section == self.currentIndexPath.section && indexPath.section == 0) {
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                
                // 使用代理方法更新数据源
                if ([self.delegate respondsToSelector:@selector(moveItemAtIndexPath:toIndexPath:)]) {
                    [self.delegate moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                }
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                self.moveView.center = cell.center;
            } completion:^(BOOL finished) {
                [self.moveView removeFromSuperview];
                cell.hidden = NO;
                self.moveView = nil;
                self.currentIndexPath = nil;
                [self.collectionView reloadData];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 处于编辑状态
- (void)setInEditState:(BOOL)inEditState
{
    if (_inEditState != inEditState) {
        
        if ([_delegate respondsToSelector:@selector(didChangeEditState:)]) {
            
            [_delegate didChangeEditState:inEditState];
        }
    }
    
    _inEditState = inEditState;
}

#pragma mark - 移除观察者
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"collectionView"];
}

#pragma mark - 手势
- (UILongPressGestureRecognizer *)longGesture
{
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        _longGesture.minimumPressDuration = 0.5f;
        _longGesture.delegate = self;
    }
    return _longGesture;
}

@end
