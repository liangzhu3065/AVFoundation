//
//  LZTransitionViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/1/18.
//

#import "LZTransitionViewController.h"
#import "LZTransitionChildViewController.h"
#import "LZAnimatedTransitioningObject.h"
#import "LZTransitionModalViewController.h"


@interface LZTransitionViewController ()<
UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate,
UINavigationBarDelegate
>

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *presentButton;


@end

@implementation LZTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Transition";
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.presentButton];
    [self.presentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(self.button.mas_bottom).offset(20);
    }];
}

#pragma mark - action && selector
- (void)buttonClick {
    LZTransitionChildViewController *vc = [[LZTransitionChildViewController alloc] init];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentButtonClick {
    LZTransitionModalViewController *vc = [[LZTransitionModalViewController alloc] init];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Push && Pop
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        return [LZAnimatedTransitioningObject instanceWithTransitionAnimationObjectType:LZTransitionAnimationObjectTypePush];
    }
    else if (operation == UINavigationControllerOperationPop) {
        return [LZAnimatedTransitioningObject instanceWithTransitionAnimationObjectType:LZTransitionAnimationObjectTypePop];
    }
    
    return nil;
}

#pragma mark - present && dismiss

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [LZAnimatedTransitioningObject instanceWithTransitionAnimationObjectType:LZTransitionAnimationObjectTypePresent];

}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [LZAnimatedTransitioningObject instanceWithTransitionAnimationObjectType:LZTransitionAnimationObjectTypeDismiss];
}

#pragma mark - View
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 5.0;
        _button.layer.borderWidth = 1.0;
        _button.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor;
        [_button setTitle:@"PushButton" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton *)presentButton {
    if (!_presentButton) {
        _presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _presentButton.layer.cornerRadius = 5.0;
        _presentButton.layer.borderWidth = 1.0;
        _presentButton.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor;
        [_presentButton setTitle:@"PresentButton" forState:UIControlStateNormal];
        [_presentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_presentButton addTarget:self action:@selector(presentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentButton;
}
@end
