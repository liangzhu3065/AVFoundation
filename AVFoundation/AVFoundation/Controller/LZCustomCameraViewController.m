//
//  LZCustomCameraViewController.m
//  AVFoundation
//
//  Created by lzwang on 2021/12/31.
//

#import "LZCustomCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LZCameraView.h"
#import "LZPhoneManager.h"

@interface LZCustomCameraViewController ()<LZCameraViewDelegate>

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCapturePhotoOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property(nonatomic, strong) dispatch_queue_t sessionQueue;
@property(nonatomic, strong) LZCameraView *cameraView;

@property (nonatomic, strong) LZPhoneManager *phoneManager;


@end

@implementation LZCustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _sessionQueue = dispatch_queue_create("com.avfoundation.session.queue", DISPATCH_QUEUE_SERIAL);
    
    [self setUpSubViews];
    dispatch_async(self.sessionQueue, ^{
        [self setUp];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession startRunning];
        NSLog(@"captureSession startRunning");
    });
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession stopRunning];
    });
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//初始化
- (void)setUp {
    
    //初始化session
    _captureSession = [[AVCaptureSession alloc] init];
    if([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    //获取输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    if (!device) {
        NSLog(@"获取后置摄像头失败");
        return;
    }
    
    //初始化设备输入对象
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //初始化设备输出对象
    _captureStillImageOutput = [[AVCapturePhotoOutput alloc] init];
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    AVCapturePhotoSettings *outputSetting = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [_captureStillImageOutput setPhotoSettingsForSceneMonitoring:outputSetting];
    
    //将输入设备添加到会话中
    if([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        NSLog(@"intput add sucess");
    }
    
    //将输出设备添加会话中
    if([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
        NSLog(@"still image output add sucess");
    }
    
    //创建预览视图,用来实时展示摄像头状态
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cameraView.captureSession = self.captureSession;
        NSLog(@"AVCaptureVideoPreviewLayer set sucess");
    });
}

- (void)setUpSubViews {
    [self.view addSubview:self.cameraView];
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark
#pragma mark 申请授权

- (void)applyAuthorization:(void (^)(BOOL granted))handler{
    //申请相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewWithMessage:@"相机权限受限，请到设置中开启"];
            });
        }
        else {
            //申请麦克风权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (!granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlertViewWithMessage:@"麦克风权限受限，请到设置中开启"];
                    });
                }
                handler(granted);
            }];
        }
    }];
}

#pragma mark LZCameraViewDelegate
- (void)cameraViewDidCancel:(LZCameraView *)cameraView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cameraViewDidTakeStillPhoto:(LZCameraView *)cameraView {
    self.phoneManager = [LZPhoneManager instanceWithPhotoOutput:self.captureStillImageOutput];
    [self.phoneManager takeStillPhoto:self.captureVideoPreviewLayer competion:^(UIImage * _Nullable originImage, UIImage * _Nullable scaledImage, UIImage * _Nullable croppedImage, NSError * _Nullable error) {
        UIImageWriteToSavedPhotosAlbum(originImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
      NSLog(@"保存失败");
   }
   else  {
      NSLog(@"保存成功");
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

#pragma mark View

- (LZCameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[LZCameraView alloc] init];
        _cameraView.delegate = self;
    }
    return _cameraView;
}


@end
