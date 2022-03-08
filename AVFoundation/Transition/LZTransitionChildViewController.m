//
//  LZTransitionChildViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/1/18.
//

#import "LZTransitionChildViewController.h"

@interface LZTransitionChildViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation LZTransitionChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(120);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)buttonClick {
    LZTransitionChildViewController *vc = [[LZTransitionChildViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 5.0;
        _button.layer.borderWidth = 1.0;
        _button.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor;
        [_button setTitle:@"Button" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
