//
//  KSPageListViewController.h
//  KSPageView
//
//  Created by 范云飞 on 2020/1/16.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KSPageListContainerTableCell.h"

@interface KSPageListViewController : UIViewController <KSPageListContainerTableCellListDelegate>

- (UIView *)listView;
- (UIScrollView *)listScrollView;

@end
