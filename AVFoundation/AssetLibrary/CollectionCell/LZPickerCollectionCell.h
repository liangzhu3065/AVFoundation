//
//  LZPickerCollectionCell.h
//  AVFoundation
//
//  Created by lzwang on 2022/3/10.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LZPickerCollectionCellAction)(PHAsset *asset);

@interface LZPickerCollectionCell : UICollectionViewCell

/// cell所在位置（indexPath.row）
@property (nonatomic, assign) NSInteger row;

///照片
@property (nonatomic, strong) PHAsset *asset;

/// 选中事件
@property (nonatomic, copy) LZPickerCollectionCellAction selectPhotoAction;

/// 是否被选中
@property (nonatomic, assign) BOOL isSelect;


-(void)loadImage:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
