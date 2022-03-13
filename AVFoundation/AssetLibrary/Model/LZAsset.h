//
//  LZAsset.h
//  AVFoundation
//
//  Created by lzwang on 2022/3/13.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZAsset : NSObject

@property (nonatomic, strong) PHAsset *asset;
///缩略图
@property (nonatomic, strong) UIImage *imageThumb;

@end

NS_ASSUME_NONNULL_END
