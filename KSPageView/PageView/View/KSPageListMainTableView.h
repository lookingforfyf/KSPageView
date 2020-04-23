//
//  KSPageListMainTableView.h
//  KSPageView
//
//  Created by 范云飞 on 2020/1/16.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSPageListMainTableViewGestureDelegate <NSObject>

@optional
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end


@interface KSPageListMainTableView : UITableView

@property (nonatomic, weak) id<KSPageListMainTableViewGestureDelegate> gestureDelegate;

@end
