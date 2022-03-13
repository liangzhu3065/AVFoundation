//
//  LZAlbumListViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/12.
//

#import "LZAlbumListViewController.h"
#import "LZPickerAlbumModel.h"
#import <Photos/Photos.h>
#import "LZPickerViewController.h"

@interface LZAlbumListViewController ()

@end

@implementation LZAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册集合";
    
    [self loadData];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)loadData {
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取系统相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            //获取相册名字
            LZPickerAlbumModel *model = [[LZPickerAlbumModel alloc] init];
            model.albumName = collection.localizedTitle;
            NSLog(@"系统相册:%@",model.albumName);
            
            //获取相册资源
            PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            model.assets = results;
            
            [self.dataArray addObject:model];
        }
        
        //获取自定义相册
        PHFetchResult *customAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in customAlbums) {
            LZPickerAlbumModel *model = [[LZPickerAlbumModel alloc] init];
            model.albumName = collection.localizedTitle;
            NSLog(@"自定义相册：%@",model.albumName);
            
            PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            model.assets = results;
            [self.dataArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LZPickerAlbumModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%lu)",model.albumName,(unsigned long)model.assets.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    LZPickerAlbumModel *model = self.dataArray[indexPath.row];
    LZPickerViewController *vc = [[LZPickerViewController alloc] init];
    vc.albumModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
