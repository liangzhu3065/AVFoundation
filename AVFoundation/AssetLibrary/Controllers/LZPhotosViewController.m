//
//  LZPhotosViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/9.
//

#import "LZPhotosViewController.h"
#import "LZPickerAlbumModel.h"
#import "LZPickerViewController.h"

@interface LZPhotosViewController ()
<
PHPickerViewControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, strong) NSMutableArray *albumArray;

@end

@implementation LZPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _albumArray = [NSMutableArray array];
    
    
    [self.view addSubview:self.headImgView];
    self.headImgView.backgroundColor = [UIColor redColor];
    self.headImgView.layer.cornerRadius = 40;
    self.headImgView.layer.masksToBounds = YES;
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(40);
        make.width.height.mas_equalTo(80);
    }];
    
    UIButton *imagePickerBtn = [self getButtonWithTitle:@"相册-ImagePicker"];
    [imagePickerBtn addTarget:self action:@selector(imagePickerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imagePickerBtn];
    [imagePickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headImgView.mas_bottom).offset(30);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *albumBtn = [self getButtonWithTitle:@"相册-PHPicker"];
    [albumBtn addTarget:self action:@selector(albumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
    [albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(imagePickerBtn.mas_bottom).offset(30);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *fetchBtn = [self getButtonWithTitle:@"相册-PHFetch"];
    [fetchBtn addTarget:self action:@selector(fetchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fetchBtn];
    [fetchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(albumBtn.mas_bottom).offset(30);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - UIImagePicker
- (void)imagePickerBtnClick {
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        self.headImgView.image = image;
    }
}


#pragma mark - PHPicker
- (void)albumBtnClick {
    if (@available(iOS 14,*)) {
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
        configuration.filter = [PHPickerFilter imagesFilter]; // 可配置查询用户相册中文件的类型，支持三种
        configuration.selectionLimit = 3; // 默认为1，为0时表示可多选。
      
        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        picker.delegate = self;
        picker.view.backgroundColor = [UIColor whiteColor];//注意需要进行暗黑模式适配
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
          // picker vc，在选完图片后需要在回调中手动 dismiss
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
  [picker dismissViewControllerAnimated:YES completion:nil];
    
  if (!results || !results.count) {
      return;
  }
  NSItemProvider *itemProvider = results.firstObject.itemProvider;
  if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
      __weak typeof(self) weakSelf = self;
      [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
          if ([object isKindOfClass:UIImage.class]) {
              __strong typeof(self) strongSelf = weakSelf;
              dispatch_async(dispatch_get_main_queue(), ^{
                  strongSelf.headImgView.image = (UIImage *)object;
              });
          }
      }];
  }
}

#pragma mark - fetch
- (void)fetchBtnClick {
    //申请权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                [self loadPhotoData];
            }
            else {
                NSLog(@"相册未授权");
            }
        });
    }];
}

- (void)loadPhotoData {
    //所有智能相册（关于type与subtype的参数含义，可以参考：https://www.jianshu.com/p/687157a50426）
    //PHAssetCollectionSubtypeSmartAlbumUserLibrary （相机）
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (PHAssetCollection *collection in smartAlbums) {
        LZPickerAlbumModel *model = [[LZPickerAlbumModel alloc] init];
        model.collection = collection;
        [self.albumArray addObject:model];
    }
    
    LZPickerViewController *pickerVC = [[LZPickerViewController alloc] init];
    pickerVC.albumModel = self.albumArray.firstObject;
//    pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerVC animated:YES completion:nil];
}


//- <  获取相册里的所有图片的PHAsset对象  >
- (NSArray *)getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    // 存放所有图片对象
    NSMutableArray *assets = [NSMutableArray array];
    
    // 是否按创建时间排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    // 获取所有图片对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    // 遍历
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [assets addObject:asset];
    }];
    return assets;
}

// - <  根据PHAsset获取图片信息  >
- (void)accessToImageAccordingToTheAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void(^)(UIImage *image,NSDictionary *info))completion
{
    static PHImageRequestID requestID = -2;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, 500);
    if (requestID >= 1 && size.width / width == scale) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:requestID];
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.resizeMode = resizeMode;
    
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result,info);
        });
    }];

}
#pragma mark - View
- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
    }
    return _headImgView;
}

- (UIButton *)getButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}
@end
