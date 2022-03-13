//
//  LZAlbumBrowserViewController.h
//  AVFoundation
//
//  Created by lzwang on 2022/3/13.
//

#import "LZBaseViewController.h"
#import "LZPickerAlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZAlbumBrowserViewController : LZBaseViewController

- (void)showAlbumIn:(LZPickerAlbumModel *)model atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
