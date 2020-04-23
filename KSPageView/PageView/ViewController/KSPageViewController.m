//
//  KSPageViewController.m
//  KSPageView
//
//  Created by 范云飞 on 2020/1/16.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import "KSPageViewController.h"

#import "KSPageListViewController.h"

#import "KSPageListContainerTableCell.h"
#import "KSPageListMainTableView.h"

#define CellHeight SCREEN_HEIGHT - SafeArea_TopBarHeight

static NSString * const CellIdentifier = @"UITableViewCell";

@interface KSPageViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) KSPageListMainTableView * tableView;
@property (nonatomic, strong) KSPageListContainerTableCell * listContainerTableCell;

@property (nonatomic, strong) NSArray * listTitles;

@end

@implementation KSPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.listTitles = @[@"测试测试1",@"测试测试测2",@"测试测试测试3",@"测试测试4",@"测试5",@"测试测试测试6"];
}

- (void)setupUI {
    self.navigationItem.title = @"KSPageView";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(SafeArea_TopBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (KSPageListMainTableView *)tableView {
    if (!_tableView) {
        _tableView = [[KSPageListMainTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];

        __weak __typeof (self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof (weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return ;
            }
            [strongSelf loadDataIsRefresh:YES];
        }];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        [_tableView registerClass:[KSPageListContainerTableCell class] forCellReuseIdentifier:[KSPageListContainerTableCell identifier]];
    }
    return _tableView;
}

- (void)loadDataIsRefresh:(BOOL)isRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
//            self.listTitles = @[@"测试10",@"测试1",@"测试2",@"测试20",@"测试3",@"测试4",@"测试5",@"测试6",@"测试7"];
            self.listTitles = @[@"测试7"];
        }
    });
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 1) ? 1 : 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"KSPageView";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        KSPageListContainerTableCell * cell = [tableView dequeueReusableCellWithIdentifier:[KSPageListContainerTableCell identifier] forIndexPath:indexPath];
        cell.mainTableView = self.tableView;
        cell.dataArray = self.listTitles;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.listContainerTableCell = cell;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return CellHeight;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.listContainerTableCell mainTableViewDidScroll:scrollView];
}


@end
