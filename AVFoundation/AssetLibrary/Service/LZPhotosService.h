//
//  LZPhotosService.h
//  AVFoundation
//
//  Created by lzwang on 2022/3/12.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZPhotosService : NSObject

+ (instancetype)shared;

- (PHFetchResult<PHAsset *> *)getAllPhotosFromAlbum;

@end

NS_ASSUME_NONNULL_END
