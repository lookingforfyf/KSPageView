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

@required
- (NSInteger)numberOfRowsInListContainerView:(KSPageListContainerView *)listContainerView;

- (UIView *)listContainerView:(KSPageListContainerView *)listContainerView listViewInRow:(NSInteger)row;

@optional
- (void)listContainerView:(KSPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

@end

@interface KSPageListContainerView : UIView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<KSPageListContainerViewDelegate> delegate;
@property (nonatomic, weak) KSPageListMainTableView *mainTableView;

- (void)reloadData;

@end
