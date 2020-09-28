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

#import "KSTestHeightDynamicTableCell.h"

#define CellHeight SCREEN_HEIGHT - SafeArea_TopBarHeight

static NSString * const CellIdentifier = @"UITableViewCell";

@interface KSPageViewController ()
<UITableViewDelegate,
UITableViewDataSource,
KSTestHeightDynamicTableCellDelegate>
@property (nonatomic, strong) KSPageListMainTableView * tableView;
@property (nonatomic, strong) KSPageListContainerTableCell * listContainerTableCell;

@property (nonatomic, strong) NSArray * listTitles;

@property (nonatomic, assign) BOOL isUpdateForthCellHeight;
@property (nonatomic, assign) BOOL isUpdateFirstCellHeight;

@end

@implementation KSPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.listTitles = @[@"测试测试1",@"测试测试测2",@"测试测试测试3"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>) self;
}

- (void)setupUI {
    self.navigationItem.title = @"KSPageView";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (KSPageListMainTableView *)tableView {
    if (!_tableView) {
        _tableView = [[KSPageListMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        [_tableView registerClass:[KSPageListContainerTableCell class] forCellReuseIdentifier:[KSPageListContainerTableCell identifier]];
        [_tableView registerClass:[KSTestHeightDynamicTableCell class] forCellReuseIdentifier:NSStringFromClass([KSTestHeightDynamicTableCell class])];
    }
    return _tableView;
}

- (KSPageListContainerTableCell *)listContainerTableCell {
    if (!_listContainerTableCell) {
        _listContainerTableCell = [[KSPageListContainerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[KSPageListContainerTableCell identifier]];
    }
    return _listContainerTableCell;
}

- (void)loadDataIsRefresh:(BOOL)isRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self reloadPageListContainer:@[@"测试7"]];
        }
    });
}

- (void)reloadPageListContainer:(NSArray *)listTitles {
    if (self.listContainerTableCell) {
        self.listContainerTableCell.dataArray = listTitles;
        [self.listContainerTableCell reloadData];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 1) ? 1 : 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = nil;
        
        if (indexPath.row == 0 || indexPath.row == 4) {
            KSTestHeightDynamicTableCell * heightDynamicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KSTestHeightDynamicTableCell class]) forIndexPath:indexPath];
            heightDynamicCell.indexPath = indexPath;
            heightDynamicCell.delegate = self;
            cell = heightDynamicCell;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"KSPageView";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        KSPageListContainerTableCell * cell = [tableView dequeueReusableCellWithIdentifier:[KSPageListContainerTableCell identifier] forIndexPath:indexPath];
        if (!cell.mainTableView) {
            cell.mainTableView = self.tableView;
        }
        cell.dataArray = self.listTitles;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.listContainerTableCell = cell;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return CellHeight;
    } else {
        if (indexPath.row == 0) {
            return self.isUpdateFirstCellHeight ? 500 : 100;
        }
        if (indexPath.row == 4) {
            return self.isUpdateForthCellHeight ? 500 : 100;
        }
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.listContainerTableCell mainTableViewDidScroll:scrollView];
}

#pragma mark - KSTestHeightDynamicTableCellDelegate

- (void)reloadRowsHeightAtIndexPaths:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.isUpdateFirstCellHeight = !self.isUpdateFirstCellHeight;
    }
    if (indexPath.row == 4) {
        self.isUpdateForthCellHeight = !self.isUpdateForthCellHeight;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
