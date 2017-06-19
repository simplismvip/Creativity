//
//  JMSelectEmojiView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/4.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMSelectEmojiView.h"
#import "JMSubImageModel.h"
#import "NSObject+JMProperty.h"
#import "JMSubImageCollectionViewCell.h"

@interface JMSelectEmojiView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@end

@implementation JMSelectEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
        NSArray *emojis = [JMHelper readJsonByPath:jsonPath][@"emoji"];
        self.dataSource = [NSMutableArray array];
        for (NSDictionary *dic in emojis) {[self.dataSource addObject:[JMSubImageModel objectWithDictionary:dic]];}
        [self addSubview:self.collection];
    }
    return self;
}

- (void)reloadData:(NSMutableArray *)data
{
    self.dataSource = data;
    [_collection reloadData];
}

- (UICollectionView *)collection
{
    if (!_collection)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [collection registerClass:[JMSubImageCollectionViewCell class] forCellWithReuseIdentifier:@"emoji"];
        collection.backgroundColor = [UIColor clearColor];
        collection.dataSource = self;
        collection.delegate = self;
        collection.showsVerticalScrollIndicator = NO;
        [self addSubview:collection];
        self.collection = collection;
    }
    
    return _collection;
}


#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMSubImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emoji" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        cell.transform = CGAffineTransformMakeScale(2, 2);
        cell.alpha = 0.1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            cell.transform = CGAffineTransformMakeScale(1, 1);
            cell.alpha = 1.0;
        }];
    }];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMSubImageModel *model = self.dataSource[indexPath.row];
    if (self.modelBlock) {
        
        self.modelBlock(model);
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(48, 48);
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
