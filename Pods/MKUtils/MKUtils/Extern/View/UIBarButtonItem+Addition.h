//
//  UIBarButtonItem+Addition.h
//  Basic
//
//  Created by zhengmiaokai on 2018/10/10.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Addition)

/** 生成纯文本的UIBarButtonItem
 ** title 标题
 ** titleColor 文本颜色
 ** font 字体大小
 **/
+ (instancetype)barButtonItemWithTitle:(NSString *)title
                            titleColor:(UIColor *)titleColor
                                  font:(UIFont *)font
                                action:(SEL)action
                                target:(id)target;

/** 生成纯图片的UIBarButtonItem
 ** image 图片
 **/
+ (instancetype)barButtonItemWithImage:(UIImage *)image
                                action:(SEL)action
                                target:(id)target;

@end
