//
//  LZCustomCameraViewController.m
//  AVFoundation
//
//  Created by lzwang on 2021/12/31.
//

#import "LZCustomCameraViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface LZCustomCameraViewController ()

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property(nonatomic, strong) AVCaptureOutput *outPut;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) AVCaptureConnection *connection;

@end

@implementation LZCustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark
#pragma mark 相机授权

@end
