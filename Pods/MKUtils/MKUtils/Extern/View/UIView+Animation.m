//
//  UIView+ViewAnimate.m
//  WishBid
//
//  Created by zhengMK on 14-10-20.
//  Copyright (c) 2014年 Wish. All rights reserved.
//

#import "UIView+Animation.h"
#import <QuartzCore/QuartzCore.h>

#define KRotationKey @"rotationAnimation"
#define KTranslationAnimationKey @"translationAnimation"

@implementation UIView (Animation)

- (void)animateWithFrame:(CGRect)finalFrame duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.frame = finalFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bouncingUpAndDownWithDuration:(CGFloat)duration distance:(CGFloat)distance {
    
    CAKeyframeAnimation* translationAnimation;
    translationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    translationAnimation.values = @[[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:distance],[NSNumber numberWithFloat:0]];
    translationAnimation.duration = duration;
    translationAnimation.cumulative = YES;
    translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translationAnimation.removedOnCompletion = YES;
    translationAnimation.repeatCount = 1;
    [self.layer addAnimation:translationAnimation forKey:KTranslationAnimationKey];
}

- (void)gradientDuration:(float)duration finish:(void(^)(void))finish {
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"animation"];
    
    if (finish != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            finish();
        });
    }
}

- (void)gradientDuration:(float)duration
{
    [self gradientDuration:duration finish:nil];
}

- (void)fase:(float)duration alpha:(CGFloat)alpha completion:(void (^)(BOOL finished))completion {
    
    self.alpha = alpha == 1?0:1;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = alpha;//0:隐藏 1:出现
    } completion:completion];
}

- (void)pushViewAnimation:(BOOL)direction withDuration:(float)duration {
    
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    animation.type = kCATransitionPush;
    
    if (direction == NO )
    {
        animation.subtype = kCATransitionFromLeft;
    }
    if (direction == YES )
    {
        animation.subtype = kCATransitionFromRight;
    }
    
    [self.layer addAnimation:animation forKey:@"animation"];
}

- (void)rotateWithDuration:(NSTimeInterval)duration rotate:(CGFloat)rotate repeatCount:(NSInteger)repeatCount direction:(NSString *)direction {
    [self rotateWithDuration:duration rotate:rotate repeatCount:repeatCount direction:direction finish:nil];
}

- (void)rotateWithDuration:(NSTimeInterval)duration rotate:(CGFloat)rotate repeatCount:(NSInteger)repeatCount direction:(NSString *)direction finish:(void(^)(void))finish {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.rotation.%@", direction]];
    
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat: M_PI/180.f*rotate]; // 终止角度
    
    [self.layer addAnimation:animation forKey:@"rotate-layer"];
    
    if (finish != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatCount * duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            finish();
        });
    }
}

- (void)scaleAnimationBeginScale:(CGFloat)benginScale endScale:(CGFloat)endScale Duration:(CFTimeInterval)duration {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.scale"]];
    
    animation.duration = duration;
    animation.repeatCount = 0;
    animation.fromValue = [NSNumber numberWithFloat:benginScale]; // 起始
    animation.toValue = [NSNumber numberWithFloat:endScale]; // 终止
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animation forKey:@"scale-layer"];
}

- (void)scaleAnimationWithDuration:(CFTimeInterval)duration {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:animation forKey:@"scaleAnimation"];
}

/* 二维码扫描-镂空效果
UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
//镂空
 UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(44, 100, 287, 327); cornerRadius:0];
[path appendPath:rectPath];
[path setUsesEvenOddFillRule:YES];

CAShapeLayer *fillLayer = [CAShapeLayer layer];
fillLayer.path = path.CGPath;
fillLayer.fillRule = kCAFillRuleEvenOdd;
fillLayer.fillColor = [UIColor blackColor].CGColor;
fillLayer.opacity = 0.5;
[self.layer addSublayer:fillLayer];
 */

@end
