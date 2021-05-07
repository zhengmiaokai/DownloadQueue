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

/// 下载配置
@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, copy) NSString* URLString;
@property (nonatomic, copy) NSString* foldName; /// 默认 'Library/Downloads'

/// 下载信息
@property (nonatomic, assign) NSInteger currentLength;
@property (nonatomic, assign) NSInteger totalLength;

@property (nonatomic, copy, readonly) NSString* filePath;
@property (nonatomic, copy, readonly) NSString* tmpPath;

@property (nonatomic, strong) NSURLSessionTask* downloadTask;

- (void)didReceiveData:(NSData *)data;

- (void)didComplete;

- (void)didReceiveResponse:(NSURLResponse *)response;

- (NSUInteger)availableDataLength:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
