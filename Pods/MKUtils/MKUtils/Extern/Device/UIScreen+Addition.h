//
//  UIScreen+Addition.h
//  Basic
//
//  Created by zhengmiaokai on 2018/11/29.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define isNotchScreen  [UIScreen notchScreen]

#define kStatusBarHeight  [UIScreen statusBarHeight]

@interface UIScreen (Addition)

/* 判读是否为刘海屏 */
+ (BOOL)notchScreen;

/* 状态栏高度 */
+ (CGFloat)statusBarHeight;

@end
