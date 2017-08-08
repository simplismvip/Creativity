//
//  JMLicenceController.m
//  Creativity
//
//  Created by 赵俊明 on 2017/6/24.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMLicenceController.h"
#import "JMLicenceModel.h"
#import "JMLicenceCell.h"
#import "JMAccountHeaderFooter.h"
#import "JMLicenceViewModel.h"

@interface JMLicenceController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UITableView *licence;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation JMLicenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    [self creatMitsLicence];
    [self setUI];
}

- (void)setUI
{
    UITableView *licence = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStyleGrouped)];
    [licence registerClass:[JMLicenceCell class] forCellReuseIdentifier:@"licence"];
    licence.delegate = self;
    licence.dataSource = self;
    licence.sectionHeaderHeight = 0;
    licence.sectionFooterHeight = 0;
    licence.separatorColor = [UIColor clearColor];
    licence.showsVerticalScrollIndicator = NO;
    licence.backgroundColor = JMTabViewBaseColor;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){licence.cellLayoutMarginsFollowReadableWidth = NO;}
    [self.view addSubview:licence];
    self.licence = licence;
    
    [licence mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMLicenceViewModel *model = self.dataSource[indexPath.section];
    JMLicenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"licence"];
    if (!cell) {cell = [[JMLicenceCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"licence"];}
    cell.viewModel = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JMAccountHeaderFooter *headView = [JMAccountHeaderFooter headViewWithTableView:tableView];
    JMLicenceViewModel *model = _dataSource[section];
    headView.contentView.backgroundColor = [UIColor whiteColor];
    headView.name.backgroundColor = [UIColor whiteColor];
    headView.name.text = model.model.headeTitle;
    headView.name.textColor = [UIColor blackColor];
    headView.name.font = [UIFont fontWithName:@"AlNile-Bold" size:22];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMLicenceViewModel *model = _dataSource[indexPath.section];
    return model.cellFrame+60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatMitsLicence
{
    JMLicenceViewModel *viewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *networking = [[JMLicenceModel alloc] init];
    [_dataSource addObject:viewModel];
    networking.headeTitle = @"AFNetworking";
    networking.copyright = @"Copyright (c) 2011–2016 Alamofire Software Foundation (http://alamofire.org/)";
    networking.lower =@"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:";
    
    networking.aboveCopyright = @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    networking.upper = @"THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    viewModel.model = networking;
    
    JMLicenceViewModel *hudViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *hud = [[JMLicenceModel alloc] init];
    [_dataSource addObject:hudViewModel];
    hud.headeTitle = @"MBProgressHUD";
    hud.copyright = @"Copyright © 2009-2016 Matej Bukovinski";
    hud.lower =@" Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    hud.aboveCopyright = @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    hud.upper = @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    hudViewModel.model = hud;
    
    JMLicenceViewModel *sdwebimageViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *sdwebimage = [[JMLicenceModel alloc] init];
    [_dataSource addObject:sdwebimageViewModel];
    sdwebimage.headeTitle = @"SDWebImage";
    sdwebimage.copyright = @"Copyright (c) 2016 Olivier Poitrey rs@dailymotion.com";
    sdwebimage.lower =@" Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    sdwebimage.aboveCopyright = @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    sdwebimage.upper = @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    sdwebimageViewModel.model = sdwebimage;
    
    JMLicenceViewModel *flaViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *FLAnimatedImage = [[JMLicenceModel alloc] init];
    [_dataSource addObject:flaViewModel];
    FLAnimatedImage.headeTitle = @"FLAnimatedImage";
    FLAnimatedImage.copyright = @"Copyright (c) 2014-2016 Flipboard";
    FLAnimatedImage.lower =@" Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    FLAnimatedImage.aboveCopyright = @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    FLAnimatedImage.upper = @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    flaViewModel.model = FLAnimatedImage;

    
    JMLicenceViewModel *masonyViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *masony = [[JMLicenceModel alloc] init];
    [_dataSource addObject:masonyViewModel];
    masony.headeTitle = @"Masony";
    masony.copyright = @"Copyright (c) 2011-2012 Masonry Team - https://github.com/Masonry";
    masony.lower =@" Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    masony.aboveCopyright = @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    masony.upper = @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    masonyViewModel.model = masony;

    
    JMLicenceViewModel *mjxtentViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *mjextension = [[JMLicenceModel alloc] init];
    [_dataSource addObject:mjxtentViewModel];
    masony.headeTitle = @"MJExtension";
    mjextension.copyright = @"Copyright (c) 2013-2015 MJExtension (https://github.com/CoderMJLee/MJExtension)";
    mjextension.lower =@" Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    mjextension.aboveCopyright = @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    mjextension.upper = @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    mjxtentViewModel.model = mjextension;

    
    JMLicenceViewModel *fmdbViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *fmdb = [[JMLicenceModel alloc] init];
    [_dataSource addObject:fmdbViewModel];
    fmdb.headeTitle = @"FMDB";
    fmdb.copyright = @"Copyright (c) 2008-2014 Flying Meat Inc.";
    fmdb.lower =@" Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    fmdb.aboveCopyright = @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.";
    
    fmdb.upper = @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    fmdbViewModel.model = fmdb;
    
    for (JMLicenceViewModel *view in _dataSource) {
        
        NSLog(@"%@-%@--%@--%@--%@", view.model.headeTitle, view.model.copyright, view.model.lower, view.model.upper, view.model.aboveCopyright);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
