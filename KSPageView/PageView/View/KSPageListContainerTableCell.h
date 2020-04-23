//
//  KSPageListContainerTableCell.h
//  KSPageView
//
//  Created by 范云飞 on 2020/1/17.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSPageListContainerTableCell;
@class KSPageListMainTableView;

@protocol KSPageListContainerTableCellListDelegate <NSObject>

@required
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback;

@end

@interface KSPageListContainerTableCell : UITableViewCell

@property (nonatomic, weak) KSPageListMainTableView *mainTableView;
@property (nonatomic, strong) NSArray <id>* dataArray;

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView;

+ (NSString *)identifier;

@end

