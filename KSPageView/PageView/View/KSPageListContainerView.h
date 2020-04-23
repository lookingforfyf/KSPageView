//
//  KSPageListContainerView.h
//  KSPageView
//
//  Created by 范云飞 on 2020/1/16.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSPageListContainerView;
@class KSPageListMainTableView;

@protocol KSPageListContainerViewDelegate <NSObject>

@optional

- (NSInteger)numberOfRowsInListContainerView:(KSPageListContainerView *)listContainerView;

- (UIView *)listContainerView:(KSPageListContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(KSPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

@end

@interface KSPageListContainerView : UIView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<KSPageListContainerViewDelegate> delegate;
@property (nonatomic, weak) KSPageListMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<KSPageListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

@end
