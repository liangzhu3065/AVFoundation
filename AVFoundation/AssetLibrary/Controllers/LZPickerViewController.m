//
//  LZPickerViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/10.
//

#import "LZPickerViewController.h"
#import "LZPickerCollectionCell.h"
#import "LZAlbumBrowserViewController.h"

static NSString *albumCollectionViewCell = @"LYFAlbumCollectionViewCell";

@interface LZPickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *albumCollectionView;

@end

@implementation LZPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片选择器";
    [self.view addSubview:self.albumCollectionView];
    [self.albumCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setAlbumModel:(LZPickerAlbumModel *)albumModel {
    _albumModel = albumModel;
    if ([albumModel.type isEqualToString:@"1"]) {
        [self getAllPhotosFromAlbum];
    }
    else if( [albumModel.type isEqualToString:@"2"]){
        [self getAllVideosFromAlbum];
    }
    else {
        [self.albumCollectionView reloadData];
    }
}

#pragma mark private
//获取所有图片
- (void)getAllPhotosFromAlbum {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchResult *results = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
        self.albumModel.assets = results;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.albumCollectionView reloadData];
        });
    });
}

- (void)getAllVideosFromAlbum {
    PHFetchResult *results = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    _albumModel.assets = results;
    [self.albumCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumModel.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZPickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:albumCollectionViewCell forIndexPath:indexPath];

    cell.row = indexPath.row;
    cell.contentView.backgroundColor = [UIColor blueColor];
    cell.asset = self.albumModel.assets[indexPath.row];
    [cell loadImage:indexPath];
//    cell.isSelect = [self.albumModel.selectRows containsObject:@(indexPath.row)];

    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    cell.selectPhotoAction = ^(PHAsset *asset) {
//        BOOL isReloadCollectionView = NO;
//        if ([weakSelf.albumModel.selectRows containsObject:@(indexPath.row)]) {
//            [weakSelf.albumModel.selectRows removeObject:@(indexPath.row)];
//            [LYFPhotoManger standardPhotoManger].choiceCount--;
//
//            isReloadCollectionView = [LYFPhotoManger standardPhotoManger].choiceCount == 9;
//        } else {
//            if ([LYFPhotoManger standardPhotoManger].maxCount == [LYFPhotoManger standardPhotoManger].choiceCount) {
//                return;
//            }
//
//            [weakSelf.albumModel.selectRows addObject:@(indexPath.row)];
//            [LYFPhotoManger standardPhotoManger].choiceCount++;
//            isReloadCollectionView = [LYFPh®otoManger standardPhotoManger].choiceCount == 10;
//        }
//
//        if (isReloadCollectionView) {
//            [weakSelf.albumCollectionView reloadData];
//        } else {
//            weakCell.isSelect = [weakSelf.albumModel.selectRows containsObject:@(indexPath.row)];
//        }
    };

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 20.f) / 3.f, (kScreenWidth - 20.f) / 3.f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LZAlbumBrowserViewController *vc = [[LZAlbumBrowserViewController alloc] init];
    [vc showAlbumIn:self.albumModel atIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UICollectionView *)albumCollectionView {
    if (!_albumCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5.f;
        layout.minimumInteritemSpacing = 5.f;
        
        _albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _albumCollectionView.delegate = self;
        _albumCollectionView.dataSource = self;
        _albumCollectionView.backgroundColor = [UIColor whiteColor];
        _albumCollectionView.scrollEnabled = YES;
        _albumCollectionView.alwaysBounceVertical = YES;
        
        [_albumCollectionView registerClass:[LZPickerCollectionCell class] forCellWithReuseIdentifier:albumCollectionViewCell];
    }
    
    return _albumCollectionView;
}
@end
