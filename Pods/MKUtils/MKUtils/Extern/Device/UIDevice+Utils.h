//
//  UIDevice+Utils.h
//  Basic
//
//  Created by zhengmiaokai on 2018/10/11.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Utils)

/* 开启相册权限弹窗（新IOS系统默认开启，用该方法唤起开关入口） */
+ (void)PHAuthorizationStatusWithBlock:(void(^)(BOOL isAuthor))block;

/* 相册权限 */
+ (BOOL)checkPhotoAuth;

/* 相机权限 */
+ (BOOL)checkCameraAuth;

@end
