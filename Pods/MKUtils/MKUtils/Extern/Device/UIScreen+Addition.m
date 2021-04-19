//
//  UIScreen+Addition.m
//  Basic
//
//  Created by zhengmiaokai on 2018/11/29.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "UIScreen+Addition.h"

@implementation UIScreen (Addition)

#pragma mark -- 是否为刘海屏
+ (BOOL)notchScreen {
    BOOL iPhoneXSeries = ([self statusBarHeight]==20) ? NO : YES;
    return iPhoneXSeries;
}

#pragma mark -- 状态栏高度
+ (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
