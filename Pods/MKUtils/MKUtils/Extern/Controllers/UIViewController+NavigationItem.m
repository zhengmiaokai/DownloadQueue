//
//  UIViewController+NavigationItem.m
//  Basic
//
//  Created by zhengmiaokai on 2018/10/10.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "UIViewController+NavigationItem.h"
#import "UIBarButtonItem+Addition.h"

@implementation UIViewController (NavigationItem)

- (void)setRightItemWithTitle:(NSString *)title
                            titleColor:(UIColor *)titleColor
                                  font:(UIFont *)font
                                action:(SEL)action
                       target:(id)target {
    
    UIBarButtonItem* rightItem = [UIBarButtonItem barButtonItemWithTitle:title titleColor:titleColor font:font action:action target:target];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setLeftItemWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                         font:(UIFont *)font
                       action:(SEL)action
                      target:(id)target {
    
    UIBarButtonItem* leftItem = [UIBarButtonItem barButtonItemWithTitle:title titleColor:titleColor font:font action:action target:target];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)setRightItemWithImage:(UIImage *)image
                                action:(SEL)action
                       target:(id)target {
    
    UIBarButtonItem* rightItem = [UIBarButtonItem barButtonItemWithImage:image action:action target:target];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setLeftItemWithImage:(UIImage *)image
                       action:(SEL)action
                      target:(id)target {
    
    UIBarButtonItem* leftItem = [UIBarButtonItem barButtonItemWithImage:image action:action target:target];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

@end
