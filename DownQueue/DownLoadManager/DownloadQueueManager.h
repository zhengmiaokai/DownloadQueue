//
//  PTDownloadMangaer.h
//  Neptune
//
//  Created by zhengmiaokai on 2018/8/17.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "DownloadTaskQueue.h"
#import "DownloadFileStatus.h"
#import "DownloadConfig.h"

@interface DownloadQueueManager : DownloadTaskQueue

+ (instancetype)sharedInstance;

- (NSURLSessionTask *)downloadTaskWithConfig:(DownloadConfig *)configuration
                                        receiveDataLength:(void(^)(DownloadConfig* configuration))receiveDataLength
                                           completeBlock:(void(^)(DownloadConfig* configuration))completeBlock;

- (NSURLSessionTask *)dataTaskWithConfig:(DownloadConfig *)configuration
                                  receiveDataLength:(void(^)(DownloadConfig* configuration))receiveDataLength
                                      completeBlock:(void(^)(DownloadConfig* configuration))completeBlock;

- (NSArray <DownloadFileStatus*> *)getDownloadsStatus:(NSArray *)configurations;

@end
