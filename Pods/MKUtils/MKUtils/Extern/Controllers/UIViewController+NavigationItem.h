//
//  UIViewController+NavigationItem.h
//  Basic
//
//  Created by zhengmiaokai on 2018/10/10.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 设置NavigationItem相关Item */

@interface UIViewController (NavigationItem)

- (void)setRightItemWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                         font:(UIFont *)font
                       action:(SEL)action
                       target:(id)target;

- (void)setLeftItemWithTitle:(NSString *)title
                  titleColor:(UIColor *)titleColor
                        font:(UIFont *)font
                      action:(SEL)action
                      target:(id)target;


- (void)setRightItemWithImage:(UIImage *)image
                       action:(SEL)action
                       target:(id)target;

- (void)setLeftItemWithImage:(UIImage *)image
                      action:(SEL)action
                      target:(id)target;

@end
