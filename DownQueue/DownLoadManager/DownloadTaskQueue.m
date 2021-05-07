//
//  DownloadTaskQueue.m
//  Basic
//
//  Created by zhengMK on 2018/8/19.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "DownloadTaskQueue.h"
#import <objc/runtime.h>
#import <MKUtils/NSString+Addition.h>
#import <MKUtils/NSString+Sign.h>

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
        self.identify = [[NSString randomStringWithLength:8] MD5];
    }
    return self;
}

@end


@implementation URLSessionDataTaskItem

@end

@implementation URLSessionDownloadTaskItem

@end

@interface DownloadTaskQueue () <NSURLSessionDownloadDelegate,NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession* session;

@property (nonatomic, strong) NSOperationQueue* queue;

@property (nonatomic, strong) NSMutableDictionary* taskItems;

@end

@implementation DownloadTaskQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.taskItems = [NSMutableDictionary dictionary];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        self.queue = queue;
        
        NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
        self.session = session;
    }
    return self;
}

- (NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)URLString didFinishDownloading:(void(^)(NSURLSessionDownloadTask *downloadTask, NSURL *location))finishDownloading
                                           didWriteData:(void(^)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))writeData
                                            didComplete:(void(^)(NSURLSessionTask *task, NSData* fileData, NSError *error))complete {
    
    NSURLSessionDownloadTask* downloadTask = [_session downloadTaskWithURL:[NSURL URLWithString:URLString]];
    
    URLSessionDownloadTaskItem* taskItem = [[URLSessionDownloadTaskItem alloc] init];
    taskItem.didFinishDownloading = finishDownloading;
    taskItem.didWriteData  =  writeData;
    taskItem.didComplete = complete;
    [_taskItems setValue:taskItem forKey:taskItem.identify];
    
    downloadTask.identify = taskItem.identify;
    
    return downloadTask;
}

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData didFinishDownloading:(void(^)(NSURLSessionDownloadTask *downloadTask, NSURL *location))finishDownloading
                                      didWriteData:(void(^)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))writeData
                                             didComplete:(void(^)(NSURLSessionTask *task, NSData* fileData, NSError *error))complete {
    
    NSURLSessionDownloadTask* downloadTask = [_session downloadTaskWithResumeData:resumeData];
    
    URLSessionDownloadTaskItem* taskItem = [[URLSessionDownloadTaskItem alloc] init];
    taskItem.didFinishDownloading = finishDownloading;
    taskItem.didWriteData =  writeData;
    taskItem.didComplete = complete;
    [_taskItems setValue:taskItem forKey:taskItem.identify];
    
    downloadTask.identify = taskItem.identify;
    
    return downloadTask;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSMutableURLRequest *)request  didReceiveData:(void(^)(NSURLSessionDataTask *dataTask, NSData *data))receiveData
                             didReceiveResponse:(NSURLSessionResponseDisposition (^)(NSURLSessionDataTask *dataTask, NSURLResponse *response))receiveResponse
                                    didComplete:(void(^)(NSURLSessionTask *task, NSData* fileData, NSError *error))complete {
    
    NSURLSessionDataTask* dataTask = [_session dataTaskWithRequest:request];
    
    URLSessionDataTaskItem* taskItem = [[URLSessionDataTaskItem alloc] init];
    taskItem.didReceiveData = receiveData;
    taskItem.didReceiveResponse =  receiveResponse;
    taskItem.didComplete = complete;
    
    @synchronized (self) {
        [_taskItems setValue:taskItem forKey:taskItem.identify];
    }

    dataTask.identify = taskItem.identify;
    
    return dataTask;
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(__unused NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    URLSessionTaskItem* taskItem = nil;
    @synchronized (self) {
        taskItem = [_taskItems valueForKey:task.identify];
    }
    
    if (taskItem) {
        NSData* fileData = nil;
        if ([taskItem isKindOfClass:[URLSessionDataTaskItem class]]) {
           fileData = ((URLSessionDataTaskItem *)taskItem).fileData;
        }
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse *)task.response;
        
        NSError *error = nil;
        if (response.statusCode/200 == 1) {
            error = nil;
        } else {
            if (fileData) {
                NSString* desc = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
                error = [NSError errorWithDomain:desc code:response.statusCode userInfo:nil];
            } else {
                error = [NSError errorWithDomain:@"无效地址" code:response.statusCode userInfo:nil];
            }
            fileData = nil;
        }
        
        taskItem.didComplete(task, fileData, error);
        [_taskItems removeObjectForKey:task.identify];
    }
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    URLSessionDataTaskItem* taskItem = nil;
    @synchronized (self) {
        taskItem = [_taskItems valueForKey:dataTask.identify];
    }
    
    if ([taskItem isKindOfClass:[URLSessionDataTaskItem class]]) {
        if (taskItem.fileData == nil) {
            taskItem.fileData = [NSMutableData data];
        }
        [taskItem.fileData appendData:data];
        taskItem.didReceiveData(dataTask, data);
    }
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    URLSessionDataTaskItem* taskItem = nil;
    @synchronized (self) {
        taskItem = [_taskItems valueForKey:dataTask.identify];
    }
    
    NSURLSessionResponseDisposition _disposition = NSURLSessionResponseAllow;
    
    if ([taskItem isKindOfClass:[URLSessionDataTaskItem class]]) {
        _disposition = taskItem.didReceiveResponse(dataTask, response);
    }
    
    completionHandler(_disposition);
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    URLSessionDownloadTaskItem* taskItem = nil;
    @synchronized (self) {
        taskItem = [_taskItems valueForKey:downloadTask.identify];
    }
    
    if ([taskItem isKindOfClass:[URLSessionDownloadTaskItem class]]) {
        taskItem.didFinishDownloading(downloadTask, location);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    URLSessionDownloadTaskItem* taskItem = nil;
    @synchronized (self) {
        taskItem = [_taskItems valueForKey:downloadTask.identify];
    }
    
    if ([taskItem isKindOfClass:[URLSessionDownloadTaskItem class]]) {
        taskItem.didWriteData(downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

@end
