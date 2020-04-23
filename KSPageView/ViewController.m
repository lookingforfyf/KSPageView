//
//  ViewController.m
//  KSPageView
//
//  Created by 范云飞 on 2020/1/16.
//  Copyright © 2020 范云飞. All rights reserved.
//

#import "ViewController.h"

#import "KSPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"KSPageView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(100), TRANS_VALUE(50)));
    }];
}

- (void)buttonClick:(UIButton *)sender {
    KSPageViewController * pageVC = [[KSPageViewController alloc] init];
    [self.navigationController pushViewController:pageVC animated:YES];
}

@end
