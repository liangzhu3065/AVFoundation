//
//  LZImageBrowserCell.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/13.
//

#import "LZImageBrowserCell.h"
#import <SDWebImage/SDWebImage.h>

@interface LZImageBrowserCell()

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation LZImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self.contentView addSubview:self.scrollView];
//        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self.contentView);
//        }];
        self.contentView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)loadImage:(NSIndexPath *)indexPath {
    CGFloat imageWidth = self.contentView.frame.size.width;
    CGFloat imageHeigth = self.contentView.frame.size.height;
    self.imageView.image = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
//    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(imageWidth * [UIScreen mainScreen].scale, imageHeigth * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        if (self.row == indexPath.row) {
//
//            self.imageView.image = result;
//        }
//    }];
    
//    PHAssetResource *resource = [PHAssetResource assetResourcesForAsset:self.asset].firstObject;
//    NSLog(@"imgType:%@",resource.uniformTypeIdentifier);
    
    [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:self.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
        
        if ([dataUTI isEqualToString:@"com.compuserve.gif"]) {
            self.imageView.image = [UIImage sd_imageWithGIFData:imageData];
        }
        else {
            self.imageView.image = [UIImage imageWithData:imageData];
        }
        NSLog(@"data length = %lu dataUTI = %@",(unsigned long)imageData.length,dataUTI);
    }];
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.maximumZoomScale = 2.0;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height);
}
@end
