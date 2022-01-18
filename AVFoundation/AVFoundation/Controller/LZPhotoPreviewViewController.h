//
//  LZPhotoPreviewViewController.h
//  AVFoundation
//
//  Created by lzwang on 2022/1/14.
//

#import "LZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZPhotoPreviewViewController : LZBaseViewController

- (void)setPreViewImg:(UIImage *)previewImg;

- (void)setPreViewVideo:(NSData *)previewData;

@end

NS_ASSUME_NONNULL_END
