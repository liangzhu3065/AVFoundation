//
//  LZCameraView.m
//  AVFoundation
//
//  Created by lzwang on 2022/1/5.
//

#import "LZCameraView.h"

@interface LZCameraView()

@property (nonatomic, strong) UIButton *flashLightBtn;
@property (nonatomic, strong) UIButton *torchLightBtn;
@property (nonatomic, strong) UIButton *switchCameraBtn;
@property (nonatomic, strong) UIButton *LiveOffBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *takeBtn;

@property (strong, nonatomic)  UIButton *takeButton;//拍照按钮
@property (strong, nonatomic)  UIButton *flashAutoButton;//自动闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOnButton;//打开闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOffButton;//关闭闪光灯按钮
@property (strong, nonatomic)  UIImageView *focusCursor; //聚焦光标

@end


@implementation LZCameraView

//将UIView自带的layer替换成AVCaptureVideoPreviewLayer
+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
        [self setUpSubviews];
    }
    return self;
}

- (void)prepare {
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)setCaptureSession:(AVCaptureSession *)captureSession {
    _captureSession = captureSession;
    self.videoPreviewLayer.session = captureSession;
}

#pragma mark action
- (void)btnClick:(UIButton *)sender {
    if (sender == self.cancelBtn) {
        // 取消
        if(self.delegate && [self.delegate respondsToSelector:@selector(cameraViewDidCancel:)]) {
            [self.delegate cameraViewDidCancel:self];
        }
    }
    else if(sender == self.takeBtn) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(cameraViewDidTakeStillPhoto:)]) {
            [self.delegate cameraViewDidTakeStillPhoto:self];
        }
    }
}
#pragma mark UI
- (void)setUpSubviews {
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.bottom.mas_equalTo(-26);
    }];
    
    [self addSubview:self.takeBtn];
    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-26);
        make.centerX.mas_equalTo(self);
    }];
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)takeBtn {
    if (!_takeBtn) {
        _takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takeBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [_takeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_takeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takeBtn;
}

@end
