//
//  UIBarButtonItem+Addition.m
//  Basic
//
//  Created by zhengmiaokai on 2018/10/10.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "UIBarButtonItem+Addition.h"

@implementation UIBarButtonItem (Addition)

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                            titleColor:(UIColor *)titleColor
                                  font:(UIFont *)font
                                action:(SEL)action
                                target:(id)target {
    
    UIButton* customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [customBtn setTitle:title forState:UIControlStateNormal];
    [customBtn setTitleColor:titleColor forState:UIControlStateNormal];
    customBtn.titleLabel.font = font;
    [customBtn sizeToFit];
    [customBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
    return buttonItem;
}

+ (instancetype)barButtonItemWithImage:(UIImage *)image
                                action:(SEL)action
                                target:(id)target {
    UIButton* customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [customBtn setImage:image forState:UIControlStateNormal];
    [customBtn sizeToFit];
    [customBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
    /*
    [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
     */
    
    return buttonItem;
}

@end
