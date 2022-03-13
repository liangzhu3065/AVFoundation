//
//  LZTabelViewController.h
//  AVFoundation
//
//  Created by lzwang on 2022/3/10.
//

#import "LZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZTabelViewController : LZBaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
