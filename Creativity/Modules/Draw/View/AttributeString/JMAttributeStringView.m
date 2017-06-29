//
//  JMAttributeStringView.m
//  YaoYao
//
//  Created by JM Zhao on 2017/5/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMAttributeStringView.h"
#import "JMAttributeStringCell.h"
#import "JMAttributeStringModel.h"
#import "JMAttributeString.h"
#import "JMAttributeStringContentView.h"
#import "JMHelper.h"

@interface JMAttributeStringView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation JMAttributeStringView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = JMColor(31, 31, 31);
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:(UITableViewStylePlain)];
        [tableView registerClass:[JMAttributeStringCell class] forCellReuseIdentifier:@"cell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor = tableView.backgroundColor;
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){tableView.cellLayoutMarginsFollowReadableWidth = NO;}
        [self addSubview:tableView];
        self.tableView = tableView;
        
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *sections = self.dataArray[section];
    NSMutableArray *values = sections.allValues.firstObject;
    return values.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMAttributeStringCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {cell = [[JMAttributeStringCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];}
    
    NSMutableDictionary *sections = self.dataArray[indexPath.section];
    NSMutableArray *values = sections.allValues.firstObject;
    JMAttributeStringModel *model = values[indexPath.row];
    
    if (model.fontName) {
        
        cell.contentV.hidden = YES;
        cell.fontName.hidden = NO;
        
        cell.fontName.text = model.fontName;
        cell.fontName.font = [UIFont fontWithName:model.fontName size:14];
    
    }else {
    
        cell.contentV.hidden = NO;
        cell.fontName.hidden = YES;
        cell.contentV.type = indexPath.section;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *sections = self.dataArray[indexPath.section];
    NSMutableArray *values = sections.allValues.firstObject;
    JMAttributeStringModel *model = values[indexPath.row];
    if (self.fontname) {
        
        if (_dataArray.count> 10) {
        
            self.fontname(model.fontName, 10);
        
        }else {
        
            self.fontname(nil, indexPath.section);
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.width, self.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
