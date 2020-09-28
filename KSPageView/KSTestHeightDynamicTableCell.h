//
//  KSTestHeightDynamicTableCell.h
//  KSPageView
//
//  Created by 范云飞 on 2020/9/25.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSTestHeightDynamicTableCellDelegate <NSObject>

- (void)reloadRowsHeightAtIndexPaths:(NSIndexPath *)indexPath;

@end

@interface KSTestHeightDynamicTableCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, weak) id<KSTestHeightDynamicTableCellDelegate>delegate ;


@end
