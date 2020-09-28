//
//  KSTestHeightDynamicTableCell.m
//  KSPageView
//
//  Created by 范云飞 on 2020/9/25.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import "KSTestHeightDynamicTableCell.h"

@interface KSTestHeightDynamicTableCell ()

@end

@implementation KSTestHeightDynamicTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake((self.contentView.width - 80)/2, 20, 80, 30)];
    leftButton.backgroundColor = [UIColor blackColor];
    [leftButton setTitle:@"更新高度" forState:UIControlStateNormal];
    [leftButton setTitle:@"恢复高度" forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(updateHeightClick:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = 1000;
    [self.contentView addSubview:leftButton];
}

- (void)updateHeightClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadRowsHeightAtIndexPaths:)]) {
        [self.delegate reloadRowsHeightAtIndexPaths:self.indexPath];
    }
}


@end
