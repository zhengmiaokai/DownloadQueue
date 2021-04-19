//
//  UIView+NTFrame.m
//  Basic
//
//  Created by zhengmiaokai on 15/3/20.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

- (void)setLayer_cornerRadius:(CGFloat)cornerRadius;

- (void)drawsAsynchronously:(void(^)(CGContextRef context))drawsBlock imageBlock:(void(^)(UIImage* image))imageBlock;

@end


@interface UIView (Gesture)

/* 添加Control到View */
- (void)addControl_target:(id)target action:(SEL)action;

/* 添加Tap手势到View */
- (void)addTarget:(id)target action:(SEL)action;

/* 移除target事件 */
- (void)removeAllTarget;

@end

@interface UIView (Frame)

@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat right;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;

@property(nonatomic,readonly) CGRect screenFrame;

@end
