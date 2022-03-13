//
//  LZAlbumBrowserViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/13.
//

#import "LZAlbumBrowserViewController.h"
#import "LZImageBrowserCell.h"


static NSString *browserCollectionViewCell = @"browserCollectionViewCell";

@interface LZAlbumBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) LZPickerAlbumModel *albumModel;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation LZAlbumBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片浏览器";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(0);
    }];
    [self.collectionView reloadData];
    //reloadData后，collectionView可能还未加载完所有的cell，此时执行了scrollToItemAtIndexPath: atScrollPosition: animated:之后不会有任何反应
    dispatch_async (dispatch_get_main_queue (), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
       });
}

- (void)showAlbumIn:(LZPickerAlbumModel *)model atIndex:(NSInteger)index {
    self.albumModel = model;
    self.currentIndex = index;
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumModel.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:browserCollectionViewCell forIndexPath:indexPath];

    cell.row = indexPath.row;
//    cell.contentView.backgroundColor = [UIColor blueColor];
    cell.asset = self.albumModel.assets[indexPath.row];
    [cell loadImage:indexPath];
//    cell.isSelect = [self.albumModel.selectRows containsObject:@(indexPath.row)];

//    __weak typeof(self) weakSelf = self;
//    __weak typeof(cell) weakCell = cell;
//    cell.selectPhotoAction = ^(PHAsset *asset) {
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
//    };

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[LZImageBrowserCell class] forCellWithReuseIdentifier:browserCollectionViewCell];
    }
    
    return _collectionView;
}
@end
