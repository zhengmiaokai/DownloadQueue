//
//  UIDevice+Utils.m
//  Basic
//
//  Created by zhengmiaokai on 2018/10/11.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "UIDevice+Utils.h"
#import <Photos/Photos.h>

@implementation UIDevice (Utils)

#pragma mark -- 开启相册权限弹窗
+ (void)PHAuthorizationStatusWithBlock:(void(^)(BOOL isAuthor))block {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(status == PHAuthorizationStatusAuthorized);
        });
    }];
}

#pragma mark -- 相册权限
+ (BOOL)checkPhotoAuth {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status != PHAuthorizationStatusAuthorized && status != PHAuthorizationStatusNotDetermined) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - 相机权限
+ (BOOL)checkCameraAuth {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus != AVAuthorizationStatusAuthorized && authStatus != AVAuthorizationStatusNotDetermined) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
