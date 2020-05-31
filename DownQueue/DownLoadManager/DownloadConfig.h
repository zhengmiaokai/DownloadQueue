//
//  DownloadConfig.h
//  Basic
//
//  Created by mikazheng on 2020/5/28.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadConfig : NSObject

@property (nonatomic, copy) NSString* fileName;

@property (nonatomic, copy) NSString* foldName;

@property (nonatomic, copy) NSString* URLString;

@property (nonatomic, assign) NSInteger currentLength;

@property (nonatomic, assign) NSInteger totalLength;

@property (nonatomic, strong) NSFileHandle *writeHandle;

@property (nonatomic, strong) NSFileHandle *readHandle;

@property (nonatomic, strong) NSURLSessionTask* downloadTask;

@property (nonatomic, copy, readonly) NSString* filePath;

@property (nonatomic, copy, readonly) NSString* tmpPath;

@end

NS_ASSUME_NONNULL_END
