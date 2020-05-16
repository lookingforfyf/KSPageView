//
//  KSPageListContainerTableCell.m
//  KSPageView
//
//  Created by 范云飞 on 2020/1/17.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import "KSPageListContainerTableCell.h"
#import "KSPageListViewController.h"

#import "KSPageListContainerView.h"
#import "KSPageListMainTableView.h"


#define CategoryViewHeight TRANS_VALUE(100)

@interface KSPageListContainerTableCell ()
<KSPageListContainerViewDelegate,
JXCategoryViewDelegate>

@property (nonatomic, strong) KSPageListContainerView *listContainerView;
@property (nonatomic, strong) JXCategoryTitleView * categoryView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;

@property (nonatomic, strong) NSMutableDictionary <NSString *, KSPageListViewController *>* listDict;

@end

@implementation KSPageListContainerTableCell

#pragma mark - Setter
- (void)setIsReload:(BOOL)isReload {
    _isReload = isReload;
}

- (void)setDataArray:(NSArray<id> *)dataArray {
    _dataArray = dataArray;
    [self ks_categroyView_reloadData];
    [self ks_listContainerView_reloadData];
}

- (void)setMainTableView:(KSPageListMainTableView *)mainTableView {
    _mainTableView = mainTableView;
    self.listContainerView.mainTableView = mainTableView;
}

- (void)ks_categroyView_reloadData {
    self.categoryView.titles = self.dataArray;
    [self.categoryView reloadData];
}

- (void)ks_listContainerView_reloadData {
    [self.listContainerView reloadData];
}

#pragma mark - Init
- (void)dealloc {
    [self.listDict removeAllObjects];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(CategoryViewHeight);
    }];
    
    [self.contentView addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(CategoryViewHeight);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    self.categoryView.contentScrollView = self.listContainerView.collectionView;
}

- (KSPageListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[KSPageListContainerView alloc] initWithFrame:CGRectZero];
        _listContainerView.delegate = self;
    }
    return _listContainerView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
        _categoryView.titleColor = [UIColor blackColor];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;

        JXCategoryIndicatorLineView *indicatorLineView = [[JXCategoryIndicatorLineView alloc] init];
        indicatorLineView.indicatorColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
        indicatorLineView.indicatorWidth = 30;
        _categoryView.indicators = @[indicatorLineView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,  CategoryViewHeight - 1, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor redColor];
        [_categoryView addSubview:lineView];
    }
    return _categoryView;
}

- (NSMutableDictionary *)listDict {
    if (!_listDict) {
        _listDict = [NSMutableDictionary dictionary];
    }
    return _listDict;
}

+ (NSString *)identifier {
    return @"KSPageListContainerTableCell";
}

#pragma mark - Private
- (void)configListViewDidScrollCallback:(KSPageListViewController *)listVC {
    __weak typeof(self) weakSelf = self;
    [listVC listViewDidScrollCallback:^(UIScrollView *scrollView) {
        __strong __typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf listViewDidScroll:scrollView];
    }];
}

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0.0) {
        scrollView.bounces = NO;
    }else {
        scrollView.bounces = YES;
    }
    
    self.currentScrollingListView = scrollView;
    if (scrollView.isTracking == NO && scrollView.isDecelerating == NO) {
        return;
    }
    
    CGFloat topContentHeight = [self mainTableViewMaxContentOffsetY];
    if (self.mainTableView.contentOffset.y < topContentHeight) {
        CGFloat insetTop = scrollView.contentInset.top;
        if (@available(iOS 11.0, *)) {
            insetTop = scrollView.adjustedContentInset.top;
        }
        scrollView.contentOffset = CGPointMake(0, -insetTop);
    } else {
        self.mainTableView.contentOffset = CGPointMake(0, topContentHeight);
    }
}

#pragma mark - Public
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0.0) {
        scrollView.bounces = NO;
    }else {
        scrollView.bounces = YES;
    }

    CGFloat topContentY = [self mainTableViewMaxContentOffsetY];
    if (scrollView.isTracking || scrollView.isDecelerating) {
        if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > 0) {
            self.mainTableView.contentOffset = CGPointMake(0, topContentY);
        }
    }

    if (scrollView.contentOffset.y < topContentY) {
        NSArray *listVCs = self.listDict.allValues;
        CGFloat insetTop = scrollView.contentInset.top;
        if (@available(iOS 11.0, *)) {
            insetTop = scrollView.adjustedContentInset.top;
        }
        for (KSPageListViewController * listVC in listVCs) {
            [listVC listScrollView].contentOffset = CGPointMake(0, -insetTop);
        }
    }
}

#pragma mark - KSPageListContainerViewDelegate
- (NSInteger)numberOfRowsInListContainerView:(KSPageListContainerView *)listContainerView {
    return self.dataArray.count;
}

- (UIView *)listContainerView:(KSPageListContainerView *)listContainerView listViewInRow:(NSInteger)row {
    KSPageListViewController * listVC  = [self getListVCWithIndex:row];
    listVC.isReload = self.isReload;
    return listVC.view;
}

- (void)listContainerView:(KSPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row {
    
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    [self listViewDidSelectedAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self listViewDidSelectedAtIndex:index];
}

- (void)listViewDidSelectedAtIndex:(NSInteger)index {
    KSPageListViewController *listVC = [self getListVCWithIndex:index];
    if ([listVC listScrollView].contentOffset.y > 0) {
        [self.mainTableView setContentOffset:CGPointMake(0, [self mainTableViewMaxContentOffsetY]) animated:YES];
    }
}

- (KSPageListViewController *)getListVCWithIndex:(NSInteger)index {
    if (index < self.dataArray.count) {
        NSString * key = [self.dataArray objectAtIndex:index];
        KSPageListViewController *listVC = [self.listDict objectForKey:key];
        if (!listVC) {
            listVC = [[KSPageListViewController alloc] init];
            listVC.isFirstReload = YES;
            if (key.length) {
                [self.listDict setObject:listVC forKey:key];
            }
            listVC.title = key;
        } else {
            listVC.isFirstReload = NO;
        }
        [self configListViewDidScrollCallback:listVC];
        return listVC;
    }
    KSPageListViewController * listVC = [[KSPageListViewController alloc] init];
    return listVC;
}

- (CGFloat)mainTableViewMaxContentOffsetY {
    return floor(self.mainTableView.contentSize.height) - self.bounds.size.height;
}

@end
