//
//  LZPhotoPreviewViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/1/14.
//

#import "LZPhotoPreviewViewController.h"

@interface LZPhotoPreviewViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation LZPhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}


#pragma mark 视图
- (void)setupSubViews {
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
