//
//  DownloadTaskQueue.h
//  Basic
//
//  Created by zhengMK on 2018/8/19.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadTaskQueue : NSObject

- (NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)URLString didFinishDownloading:(void(^)(NSURLSessionDownloadTask *downloadTask, NSURL *location))finishDownloading
                                           didWriteData:(void(^)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))writeData
                                            didComplete:(void(^)(NSURLSessionTask *task, NSData* fileData, NSError *error))complete;

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData didFinishDownloading:(void(^)(NSURLSessionDownloadTask *downloadTask, NSURL *location))finishDownloading
                                            didWriteData:(void(^)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))writeData
                                             didComplete:(void(^)(NSURLSessionTask *task, NSData* fileData, NSError *error))complete;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSMutableURLRequest *)request  didReceiveData:(void(^)(NSURLSessionDataTask *dataTask, NSData *data))receiveData
                           didReceiveResponse:(NSURLSessionResponseDisposition (^)(NSURLSessionDataTask *dataTask, NSURLResponse *response))receiveResponse
                                  didComplete:(void(^)(NSURLSessionTask *task, NSData* fileData, NSError *error))complete;

@end

@interface NSURLSessionTask (TaskCategory)

@property (nonatomic, strong) NSString* identify;

@end

@interface URLSessionTaskItem : NSObject

@property (nonatomic, copy) void(^didComplete)(NSURLSessionTask *task, NSData *fileData, NSError *error);

@property (nonatomic, copy) NSString* identify;

@end

@interface URLSessionDataTaskItem : URLSessionTaskItem

@property (nonatomic, copy) void(^didReceiveData)(NSURLSessionDataTask *dataTask, NSData *data);
@property (nonatomic, copy) NSURLSessionResponseDisposition (^didReceiveResponse)(NSURLSessionDataTask *dataTask, NSURLResponse *response);

@property (nonatomic, strong) NSMutableData* fileData;

@end

@interface URLSessionDownloadTaskItem : URLSessionTaskItem

@property (nonatomic, copy) void(^didFinishDownloading)(NSURLSessionDownloadTask *downloadTask, NSURL *location);
@property (nonatomic, copy) void(^didWriteData)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

@end
