//
//  UIView+ViewAnimate.h
//  WishBid
//
//  Created by zhengMK on 14-10-20.
//  Copyright (c) 2014年 Wish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

/** frame动画
 *  duration 持续时间
 */
- (void)animateWithFrame:(CGRect)finalFrame duration:(NSTimeInterval)duration;

/** 上下弹动
 *  duration 持续时间
 *  distance 弹动距离
 */
- (void)bouncingUpAndDownWithDuration:(CGFloat)duration distance:(CGFloat)distance;

/** 渐变效果
 *  duration 持续时间
 *  finish 回调
 */
- (void)gradientDuration:(float)duration finish:(void(^)(void))finish;

/** 渐变效果
 *  duration 持续时间
 */
- (void)gradientDuration:(float)duration;

/** 渐变
 *  duration 持续时间
 *  completion 回调
 *  alpha 0:隐藏 1:出现
 */
-(void)fase:(float)duration alpha:(CGFloat)alpha completion:(void (^)(BOOL finished))completion;

/** 导航栏push效果
 *  direction 方向 NO 左 YES 右
 *  duration 持续时间
 */
-(void)pushViewAnimation:(BOOL)direction withDuration:(float)duration;

/** 旋转
 *  duration 时间
 *  rotate 角度 如 60
 *  repeatCount 重复次数
 *  direction x y z
 */
- (void)rotateWithDuration:(NSTimeInterval)duration rotate:(CGFloat)rotate repeatCount:(NSInteger)repeatCount direction:(NSString *)direction;

/** 旋转
 *  duration 时间
 *  rotate 角度 如 60
 *  repeatCount 重复次数
 *  direction x y z
 *  finish 回调
 */
- (void)rotateWithDuration:(NSTimeInterval)duration rotate:(CGFloat)rotate repeatCount:(NSInteger)repeatCount direction:(NSString *)direction finish:(void(^)(void))finish;

/**  缩放
 **  BenginScale 起始
 **  endScale 结束
 **  duration 持续时间
 **/
- (void)scaleAnimationBeginScale:(CGFloat)benginScale endScale:(CGFloat)endScale Duration:(CFTimeInterval)duration;

/**  按钮点击缩放效果(alertView弹窗效果)
 **  duration 持续时间
 **/
- (void)scaleAnimationWithDuration:(CFTimeInterval)duration;

@end
