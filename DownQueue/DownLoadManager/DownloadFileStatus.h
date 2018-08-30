//
//  DownloadFileStatus.h
//  DownQueue
//
//  Created by zhengmiaokai on 2018/8/24.
//  Copyright © 2018年 xiaoniu66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFileStatus : NSObject

@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, copy) NSString* URLString;
@property (nonatomic, copy) NSString* filePath;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger length;

@property (nonatomic, readonly, strong) NSString* statusName;
@property (nonatomic, readonly, assign) NSInteger operation;

@end
