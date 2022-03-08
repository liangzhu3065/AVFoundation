//
//  LZAnimatedTransitioningObject.h
//  AVFoundation
//
//  Created by lzwang on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//参考：https://juejin.cn/post/6844903730370838535

typedef NS_ENUM(NSUInteger, LZTransitionAnimationObjectType) {
    LZTransitionAnimationObjectTypePush,
    LZTransitionAnimationObjectTypePop,
    LZTransitionAnimationObjectTypePresent,
    LZTransitionAnimationObjectTypeDismiss
};

@interface LZAnimatedTransitioningObject : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) LZTransitionAnimationObjectType type;

- (instancetype)initWithTransitionAnimationObjectType:(LZTransitionAnimationObjectType)type;

+ (instancetype)instanceWithTransitionAnimationObjectType:(LZTransitionAnimationObjectType)type;

@end

NS_ASSUME_NONNULL_END
