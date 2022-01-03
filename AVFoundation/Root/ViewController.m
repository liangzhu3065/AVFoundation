//
//  ViewController.m
//  AVFoundation
//
//  Created by lzwang on 2021/12/30.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LZRootCellModel.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AVFoundation";
    [self loadData];

    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
}


#pragma mark data

/**
 1、json数据可以是字典，也可以是数组；
 2、读取文件，直接用string，或者使用data，然后再转换成自己想要的数据
 */
- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RootCell.json" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.dataArray = [NSArray yy_modelArrayWithClass:[LZRootCellModel class] json:array];
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    if (model.className) {
        Class class = NSClassFromString(model.className);
        [self.navigationController pushViewController:[[class alloc] init] animated:YES];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark UI
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}
@end
