//
//  LZCameraView.h
//  AVFoundation
//
//  Created by lzwang on 2022/1/5.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LZCameraView;

@protocol LZCameraViewDelegate <NSObject>

@optional
/// 取消
- (void)cameraViewDidCancel:(LZCameraView *)cameraView;

//拍照
- (void)cameraViewDidTakeStillPhoto:(LZCameraView *)cameraView;

//即将录制视频
- (void)cameraViewWillVideoRecording:(LZCameraView *)cameraView;

//视频录制结束
- (void)cameraViewDidFinishedVideoRecored:(LZCameraView *)cameraView;

@end

@interface LZCameraView : UIView

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, weak) id<LZCameraViewDelegate> delegate;

- (void)startVideoRecordAnimation;

- (void)stopVideoRecordAnimation;

@end

NS_ASSUME_NONNULL_END
