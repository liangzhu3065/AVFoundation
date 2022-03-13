//
//  LZPickerModel.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/10.
//

#import "LZPickerAlbumModel.h"

@implementation LZPickerAlbumModel

- (void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    
    self.assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

}


@end
