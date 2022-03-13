//
//  LZPhotosService.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/12.
//

#import "LZPhotosService.h"

@implementation LZPhotosService

//- (PHFetchResult<PHAsset *> *)getAllPhotosFromAlbum {
////    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//}

#pragma - mark 单例
static id _instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}
                                                        
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
                                                        
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
                                                        
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
