//
//  LZPickerCollectionCell.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/10.
//

#import "LZPickerCollectionCell.h"

@interface LZPickerCollectionCell()

/// 相片
@property (nonatomic, strong) UIImageView *photoImageView;
/// 选中按钮
@property (nonatomic, strong) UIButton *selectButton;
/// 半透明遮罩
@property (nonatomic, strong) UIView *translucentView;

@end

@implementation LZPickerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.translucentView];
        self.translucentView.hidden = YES;
        [self.contentView addSubview:self.selectButton];
        self.selectButton.backgroundColor = [UIColor redColor];
    }
    return self;
}

#pragma mark - action && selector

- (void)selectPhoto:(UIButton *)button {
    
}

#pragma mark - private

-(void)loadImage:(NSIndexPath *)indexPath {
    CGFloat imageWidth = self.contentView.frame.size.width;
    NSLog(@"imageWidth=%f",imageWidth);
    self.photoImageView.image = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(imageWidth * [UIScreen mainScreen].scale, imageWidth * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (self.row == indexPath.row) {
//            NSLog(@"result=%@",NSStringFromCGSize(result.size));
//            NSLog(@"info:%@",info.description);
            NSString *value = info[@"PHImageResultIsDegradedKey"];
            NSLog(@"PHImageResultIsDegradedKey:%@",value);

            self.photoImageView.image = result;
        }
    }];
    
    PHAssetResource *resource = [PHAssetResource assetResourcesForAsset:self.asset].firstObject;
    NSLog(@"imgType:%@",resource.uniformTypeIdentifier);
}

#pragma mark - view

-(UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = YES;
    }
    return _photoImageView;
}

-(UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectButton.layer.borderWidth = 1.f;
        _selectButton.layer.cornerRadius = 12.5f;
        _selectButton.layer.masksToBounds = YES;
        [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectButton;
}

-(UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] init];
        _translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    
    return _translucentView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.photoImageView.frame = self.contentView.bounds;
    self.translucentView.frame = self.contentView.bounds;
    self.selectButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-25-5, 5, 25, 25);
}
@end
