//
//  LZPhoneManager.h
//  AVFoundation
//
//  Created by lzwang on 2022/1/6.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^LZPhotoManagerStillImageCompletion)(UIImage * _Nullable originImage, UIImage * _Nullable scaledImage, UIImage *_Nullable croppedImage, NSError* _Nullable error);
typedef void(^LZPhotoManagerLiveImageCompletion)(NSURL *_Nullable liveURL, NSData *_Nullable liveData, NSError* _Nullable error);


@interface LZPhoneManager : NSObject

@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;

- (instancetype)initWithPhotoOutput:(AVCapturePhotoOutput *)photoOutput;
+ (instancetype)instanceWithPhotoOutput:(AVCapturePhotoOutput *)photoOutput;


/// 拍摄静态图片
- (void)takeStillPhoto:(AVCaptureVideoPreviewLayer *)previewLayer
             competion:(LZPhotoManagerStillImageCompletion)competion;


/// 拍摄动态图片
- (void)takeLivePhoto:(AVCaptureVideoPreviewLayer *)previewLayer
            competion:(LZPhotoManagerStillImageCompletion)competion;
@end

NS_ASSUME_NONNULL_END
