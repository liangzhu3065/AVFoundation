//
//  LZPickerModel.h
//  AVFoundation
//
//  Created by lzwang on 2022/3/10.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LZAsset.h"

NS_ASSUME_NONNULL_BEGIN

/** 相册*/
@interface LZPickerAlbumModel : NSObject

/// 相册
@property (nonatomic, strong) PHAssetCollection *collection;

/// 相册中的图片（PHFetchResult 类似是一个数组）
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;

/// 相册名称
@property (nonatomic, copy) NSString *albumName;
///1-全部照片 2-全部视频
@property (nonatomic, copy) NSString *type;


@end

NS_ASSUME_NONNULL_END
