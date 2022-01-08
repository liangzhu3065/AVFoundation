//
//  LZPhoneManager.m
//  AVFoundation
//
//  Created by lzwang on 2022/1/6.
//

#import "LZPhoneManager.h"

@interface LZPhoneManager()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, copy) LZPhotoManagerStillImageCompletion stillPhotoCompletion;
@property (nonatomic, copy) LZPhotoManagerLiveImageCompletion livePhotoCompletion;
@property (nonatomic, assign) CGRect currentPreviewFrame;
@property (nonatomic, strong) NSData *photoData;

@end

@implementation LZPhoneManager

- (instancetype)initWithPhotoOutput:(AVCapturePhotoOutput *)photoOutput {
    self = [super init];
    if (self) {
        self.photoOutput = photoOutput;
    }
    return self;
}

+ (instancetype)instanceWithPhotoOutput:(AVCapturePhotoOutput *)photoOutput {
    return [[LZPhoneManager alloc] initWithPhotoOutput:photoOutput];
}

- (void)takeStillPhoto:(AVCaptureVideoPreviewLayer *)previewLayer
             competion:(LZPhotoManagerStillImageCompletion)competion {
    NSAssert(self.photoOutput, @"photoOutput 不可为空");
    self.currentPreviewFrame = previewLayer.frame;
    self.stillPhotoCompletion = competion;
    
    //AVCaptureConnection 代表输入和输出之间的一种连接
    AVCaptureConnection *connection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.supportsVideoOrientation) {
        connection.videoOrientation = previewLayer.connection.videoOrientation;
    }
    
    //AVCapturePhotoSettings 输出照片需要的配置，配置好之后传给output；
    //AVCapturePhotoSettings 实例不能重复使用，如有重复使用的需求，可以使用photoSettingsFromPhotoSettings重新创建一个
    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
    if([self.photoOutput.availablePhotoCodecTypes containsObject:AVVideoCodecTypeJPEG]) {
        NSDictionary *format = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
        photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:format];
    }
    [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
}

- (void)takeLivePhoto:(AVCaptureVideoPreviewLayer *)previewLayer
            competion:(LZPhotoManagerStillImageCompletion)competion {
    
}

#pragma mark AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output willBeginCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    //拍摄准备完毕
}

- (void)captureOutput:(AVCapturePhotoOutput *)output willCapturePhotoForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    //曝光开始
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(NSError *)error {
    //曝光结束
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    if(error) {
        if (self.stillPhotoCompletion) {
            self.stillPhotoCompletion(nil, nil, nil, error);
        }
        
        if (self.livePhotoCompletion) {
            self.livePhotoCompletion(nil, nil, error);
        }
        return;
    }
    
    //获取原始图片
    NSData *data = [photo fileDataRepresentation];
    UIImage *image = [UIImage imageWithData:data];
    if (self.stillPhotoCompletion) {
        self.stillPhotoCompletion(image, image, image, nil);
    }
}

// 消除方法弃用(过时)的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
//消除实现了废弃的方法的警告。
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {
    
}
#pragma clang diagnostic pop


// 消除方法弃用(过时)的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//消除使用了不建议的Api的警告
//这里写代码
#pragma clang diagnostic pop


@end
