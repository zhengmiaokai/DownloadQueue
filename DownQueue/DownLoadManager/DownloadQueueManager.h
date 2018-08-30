//
//  PTDownloadMangaer.h
//  Neptune
//
//  Created by zhengmiaokai on 2018/8/17.
//  Copyright © 2018年 NEO Capital. All rights reserved.
//

#import "DownloadTaskManager.h"
#import "DownloadFileStatus.h"

@interface DownloadConfiguration : NSObject

@property (nonatomic, copy) NSString* fileName;

@property (nonatomic, copy) NSString* foldName;

@property (nonatomic, copy) NSString* filePath;

@property (nonatomic, copy) NSString* tmpPath;

@property (nonatomic, copy) NSString* URLString;

@property (nonatomic, strong) NSURLSessionDataTask* downloadTask;

@property (nonatomic , assign) NSInteger currentLength;

@end

@interface DownloadQueueManager : DownloadTaskManager

+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)downloadWithConfiguration:
(DownloadConfiguration *)configuration
                                  receiveDataLength:(void(^)(DownloadConfiguration* configuration))receiveDataLength
                                      completeBlock:(void(^)(DownloadConfiguration* configuration))completeBlock;

- (NSArray <DownloadFileStatus*> *)getDownloadsStatus:(NSArray *)configurations;

@end
