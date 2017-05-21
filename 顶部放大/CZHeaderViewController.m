//
//  CZHeaderViewController.m
//  顶部放大
//
//  Created by xiang on 2017/5/21.
//  Copyright © 2017年 xiang. All rights reserved.
//

#import "CZHeaderViewController.h"

NSString *const cellId = @"cellId";
#define kHeaderHeight  200

@interface CZHeaderViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CZHeaderViewController {
    UIView *_headerView;
    UIImageView *_headerImageView;
    UIView *_lineView;
    UIStatusBarStyle _statusBarStyle;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //取消自动调整滚动视图间距-- ViewController + NAV 会自动调整 tableView的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareTableView];
    [self prepareHeaderView];
    
    _statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", scrollView.contentOffset.y);
    
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
//    NSLog(@"%f", offset);
    
    //放大
    if (offset <= 0) {
        
        //调整headerView 和 headerImageView
        CGRect headFrame = _headerView.frame;
        headFrame.origin.y = 0;
        headFrame.size.height = kHeaderHeight - offset;
        _headerView.frame = headFrame;
        
        CGRect headImgFrame = _headerImageView.frame;
        headImgFrame.size.height = headFrame.size.height;
        _headerImageView.frame = headImgFrame;
        _headerImageView.alpha = 1;
        
        
    } else { //整体移动

        CGRect headFrame = _headerView.frame;
        headFrame.size.height = kHeaderHeight;
        //headerView 最小y值
        CGFloat minY = kHeaderHeight - 64;
        headFrame.origin.y = -MIN(minY, offset);
        _headerView.frame = headFrame;
        
        CGRect headImgFrame = _headerImageView.frame;
        headImgFrame.size.height = headFrame.size.height;
        _headerImageView.frame = headImgFrame;
        
        
        //设置透明度
//        NSLog(@"%f", offset/minY);
        //根据输出可以知道 offset/minY == 1 时不可见
        CGFloat progress = 1 - (offset / minY);
        _headerImageView.alpha = progress;
        
        //根据透明度来修改状态栏的颜色
        _statusBarStyle = (progress < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        //主动更新状态栏
        [self.navigationController setNeedsStatusBarAppearanceUpdate];

    }
    
    //设置分隔线的位置
    CGRect lineFrame = _lineView.frame;
    lineFrame.origin.y = _headerView.frame.size.height - _lineView.frame.size.height;
    _lineView.frame = lineFrame;
}

#pragma mark - gettings and settings
- (void)prepareTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:tableView];
    
    //设置表格的间距
    tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    //设置滚动指示器的位置
    tableView.scrollIndicatorInsets = tableView.contentInset;
}

//准备顶部视图
- (void)prepareHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight)];
    _headerView.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1];
    [self.view addSubview:_headerView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:_headerView.bounds];
    _headerImageView.backgroundColor = [UIColor lightGrayColor];
    _headerImageView.image = [UIImage imageNamed:@"girl.jpg"];
    //设置 contentMode
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    //设置图像裁切
    _headerImageView.clipsToBounds = YES;
    [_headerView addSubview:_headerImageView];
    
    //添加分隔线 一个像素点
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight - lineHeight, _headerView.frame.size.width, lineHeight)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_headerView addSubview:_lineView];
}

@end
