//
//  UIView+NTFrame.m
//  Basic
//
//  Created by zhengmiaokai on 15/3/20.
//
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (void)setLayer_cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)drawsAsynchronously:(void(^)(CGContextRef context))drawsBlock imageBlock:(void(^)(UIImage* image))imageBlock {
    /*
     self.layer.drawsAsynchronously
     */
    CGSize size = self.bounds.size;
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        drawsBlock(context);
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge  id)resultImage.CGImage;
            imageBlock(resultImage);
        });
    });
}

@end

@implementation UIView (Gesture)

- (void)addControl_target:(id)target action:(SEL)action {
    UIControl* control = [[UIControl alloc] initWithFrame:self.bounds];
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
}

- (void)addTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)removeAllTarget {
    for (UIGestureRecognizer* recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }
    self.userInteractionEnabled = NO;
}

@end

@implementation UIView (Frame)

//上边坐标
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)aTop {
    CGRect frame = self.frame;
    frame.origin.y = aTop;
    self.frame = frame;
}

//左边坐标
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)aLeft {
    CGRect frame = self.frame;
    frame.origin.x = aLeft;
    self.frame = frame;
}

//下边坐标
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)aBottom {
    CGRect frame = self.frame;
    frame.origin.y = aBottom - self.frame.size.height;
    self.frame = frame;
}

//右边坐标
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)aRight {
    CGRect frame = self.frame;
    frame.origin.x = aRight - self.frame.size.width;
    self.frame = frame;
}

//中心位置
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)aCenterX {
    CGPoint center = self.center;
    center.x = aCenterX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)aCenterY {
    CGPoint center = self.center;
    center.y = aCenterY;
    self.center = center;
}

//宽度
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)aWidth {
    CGRect frame = self.frame;
    frame.size.width = aWidth;
    self.frame = frame;
}

//高度
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)aHeight {
    CGRect frame = self.frame;
    frame.size.height = aHeight;
    self.frame = frame;
}

- (CGFloat)screenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)screenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

@end
