//
//  LZVideoRecordingViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/1/5.
//

#import "LZVideoRecordingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LZVideoRecordingViewController ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *captureVideoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *captureVideoDeviceInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;
@property (nonatomic, strong) AVCaptureConnection *captureConnection;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVCaptureConnection *connection;

@end

@implementation LZVideoRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
}

- (void)setUp {
    
    [self addSession];
    //开始配置操作
    [self.session beginConfiguration];

    [self addVideo];
}

- (void)addSession {
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    else {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
}

- (void)addVideo {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    self.captureVideoDevice = device;
    
    [self addVideoInput];
    
    [self addVideoOutput];
}

- (void)addVideoInput {
    NSError *error = nil;
    //input 需要根据device来初始化
    self.captureVideoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureVideoDevice error:&error];
    if([self.session canAddInput:self.captureVideoDeviceInput]) {
        [self.session addInput:self.captureVideoDeviceInput];
    }
}

- (void)addVideoOutput {
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    
    //设置链接管理对象
    self.captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //视频旋转方向设置
    self.captureConnection.videoScaleAndCropFactor = self.captureConnection.videoMaxScaleAndCropFactor;
    //视频稳定设置
    if([self.captureConnection isVideoStabilizationSupported]) {
        self.captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
}

#pragma mark
#pragma mark 相机授权

- (void)applyCameraAuthor {
    BOOL isGranted = YES;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self showAlertViewWithMessage:@"应用相机权限受限,请在设置中启用"];
        isGranted = NO;
    }
    else if(status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
        }];
    }
}

#pragma mark alert
- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [alertVC addAction:ensureAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
