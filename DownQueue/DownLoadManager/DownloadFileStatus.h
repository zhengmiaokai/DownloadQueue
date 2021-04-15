//
//  DownloadFileStatus.h
//  DownQueue
//
//  Created by zhengmiaokai on 2018/8/24.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FileStatusType) {
    FileStatusTypeFinish       = 1,
    FileStatusTypePause        = 2,
    FileStatusTypeBegin        = 3,
    FileStatusTypeLoading      = 4,
    FileStatusTypeError        = 5,
};

typedef NS_ENUM(NSInteger, FileOperationType) {
    FileOperationTypeOpen        = 0,
    FileOperationTypeDownload    = 1,
    FileOperationTypePause       = 2,
    FileOperationTypeContinue    = 3,
    FileOperationTypeError       = 4,
};

@interface DownloadFileStatus : NSObject

@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, copy) NSString* URLString;
@property (nonatomic, copy) NSString* filePath;
@property (nonatomic, assign) FileStatusType status;
@property (nonatomic, assign) NSInteger length;

@property (nonatomic, readonly, strong) NSString* statusName;
@property (nonatomic, readonly, assign) FileOperationType operation;

@end
