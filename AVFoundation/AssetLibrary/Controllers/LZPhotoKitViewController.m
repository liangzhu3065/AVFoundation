//
//  LZPhotoKitViewController.m
//  AVFoundation
//
//  Created by lzwang on 2022/3/10.
//

#import "LZPhotoKitViewController.h"
#import "LZRootCellModel.h"
#import "LZPickerViewController.h"
@interface LZPhotoKitViewController ()

@end

@implementation LZPhotoKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PhoneKit";
    [self loadData];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PhotosKitCell.json" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *modelArray = [NSArray yy_modelArrayWithClass:[LZRootCellModel class] json:array];
    self.dataArray = [NSMutableArray arrayWithArray:modelArray];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LZRootCellModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    LZRootCellModel *model = self.dataArray[indexPath.row];
    if ([model.title isEqualToString:@"所有照片"]) {
        LZPickerAlbumModel *model = [[LZPickerAlbumModel alloc] init];
        model.type = @"1";
        LZPickerViewController *vc = [[LZPickerViewController alloc] init];
        vc.albumModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([model.title isEqualToString:@"所有视频"])  {
        LZPickerAlbumModel *model = [[LZPickerAlbumModel alloc] init];
        model.type = @"2";
        LZPickerViewController *vc = [[LZPickerViewController alloc] init];
        vc.albumModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        if (model.className) {
            Class class = NSClassFromString(model.className);
            [self.navigationController pushViewController:[[class alloc] init] animated:YES];
        }
    }
    
}

@end
