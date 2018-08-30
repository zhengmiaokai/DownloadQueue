//
//  DownloadTaskManager.m
//  Basic
//
//  Created by zhengMK on 2018/8/19.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "DownloadTaskManager.h"
#import <objc/runtime.h>

#import "CategoryConstant.h"

static const void *identifyKey = &identifyKey;

@implementation NSURLSessionTask (TaskCategory)

- (NSString *)identify {
    NSString* identify = objc_getAssociatedObject(self, identifyKey);
    return identify;
}

- (void)setIdentify:(NSString *)identify {
    objc_setAssociatedObject(self, identifyKey, identify, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation URLSessionTaskItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.identify = [[NSString randomStringWithLength:8] MD5Hash];
    }
    return self;
}

@end


@implementation URLSessionDataTaskItem

@end

@implementation URLSessionDownloadTaskItem

@end

@interface DownloadTaskManager () <NSURLSessionDownloadDelegate,NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession* session;

@property (nonatomic, strong) NSOperationQueue* queue;

@property (nonatomic, strong) NSMutableArray* taskItems;

@end

@implementation DownloadTaskManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.taskItems = [NSMutableArray array];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        self.queue = queue;
        
        NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
        self.session = session;
    }
    return self;
}

- (NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)URLString didFinishDownloading:(void(^)(NSURLSessionDownloadTask *downloadTask, NSURL *location))finishDownloading
                                           didWriteData:(void(^)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))writeData
                                            didComplete:(void(^)(NSURLSessionTask *task, NSError *error))complete {
    
    NSURLSessionDownloadTask* downloadTask = [_session downloadTaskWithURL:[NSURL URLWithString:URLString]];
    
    URLSessionDownloadTaskItem* taskItem = [[URLSessionDownloadTaskItem alloc] init];
    taskItem.didFinishDownloading = finishDownloading;
    taskItem.didWriteData  =  writeData;
    taskItem.didComplete = complete;
    [_taskItems addObject:taskItem];
    
    downloadTask.identify = taskItem.identify;
    
    return downloadTask;
}

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData didFinishDownloading:(void(^)(NSURLSessionDownloadTask *downloadTask, NSURL *location))finishDownloading
                                      didWriteData:(void(^)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))writeData
                                             didComplete:(void(^)(NSURLSessionTask *task, NSError *error))complete {
    
    NSURLSessionDownloadTask* downloadTask = [_session downloadTaskWithResumeData:resumeData];
    
    URLSessionDownloadTaskItem* taskItem = [[URLSessionDownloadTaskItem alloc] init];
    taskItem.didFinishDownloading = finishDownloading;
    taskItem.didWriteData =  writeData;
    taskItem.didComplete = complete;
    [_taskItems addObject:taskItem];
    
    downloadTask.identify = taskItem.identify;
    
    return downloadTask;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSMutableURLRequest *)request  didReceiveData:(void(^)(NSURLSessionDataTask *dataTask, NSData *data))receiveData
                             didReceiveResponse:(NSURLSessionResponseDisposition (^)(NSURLSessionDataTask *dataTask, NSURLResponse *response))receiveResponse
                                    didComplete:(void(^)(NSURLSessionTask *task, NSError *error))complete {
    
    NSURLSessionDataTask* dataTask = [_session dataTaskWithRequest:request];
    
    URLSessionDataTaskItem* taskItem = [[URLSessionDataTaskItem alloc] init];
    taskItem.didReceiveData = receiveData;
    taskItem.didReceiveResponse =  receiveResponse;
    taskItem.didComplete = complete;
    [_taskItems addObject:taskItem];

    dataTask.identify = taskItem.identify;
    
    return dataTask;
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(__unused NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    __block URLSessionTaskItem* taskItem = nil;
    [self.taskItems enumerateObjectsUsingBlock:^(URLSessionTaskItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([task.identify isEqualToString:obj.identify]) {
            taskItem = obj;
            taskItem.didComplete(task, error);
            *stop = YES;
        }
    }];
    
    if (taskItem && [self.taskItems containsObject:taskItem]) {
        [self.taskItems removeObject:taskItem];
    }
    
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    NSFileHandle
    
    [self.taskItems enumerateObjectsUsingBlock:^(URLSessionDataTaskItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[URLSessionDataTaskItem class]] && [dataTask.identify isEqualToString:obj.identify]) {
            obj.didReceiveData(dataTask, data);
            *stop = YES;
        }
    }];
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    __block NSURLSessionResponseDisposition disposition;
    
    [self.taskItems enumerateObjectsUsingBlock:^(URLSessionDataTaskItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[URLSessionDataTaskItem class]] && [dataTask.identify isEqualToString:obj.identify]) {
            disposition = obj.didReceiveResponse(dataTask, response);
            *stop = YES;
        }
    }];
    
    completionHandler(disposition);
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    [self.taskItems enumerateObjectsUsingBlock:^(URLSessionDownloadTaskItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[URLSessionDownloadTaskItem class]] && [downloadTask.identify isEqualToString:obj.identify]) {
            obj.didFinishDownloading(downloadTask, location);
            *stop = YES;
        }
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    [self.taskItems enumerateObjectsUsingBlock:^(URLSessionDownloadTaskItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[URLSessionDownloadTaskItem class]] && [downloadTask.identify isEqualToString:obj.identify]) {
            obj.didWriteData(downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            *stop = YES;
        }
    }];
}

@end
