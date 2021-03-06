//
//  PTDownloadMangaer.m
//  Neptune
//
//  Created by zhengmiaokai on 2018/8/17.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "DownloadQueueManager.h"
#import <MKUtils/NSFileManager+Addition.h>
#import "DownloadTaskQueue.h"

@implementation DownloadQueueManager

+ (instancetype)sharedInstance {
    static DownloadQueueManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

/* downloadTask */
- (NSURLSessionTask *)downloadTaskWithConfig:(DownloadConfig *)configuration
                                  receiveDataLength:(void(^)(DownloadConfig* configuration))receiveDataLength
                                      completeBlock:(void(^)(DownloadConfig* configuration, NSError* error))completeBlock {
    NSURLSessionDownloadTask* downloadTask = [self downloadTaskWithURLString:configuration.URLString didFinishDownloading:^(NSURLSessionDownloadTask *downloadTask, NSURL *location) {
        // 下载完成，将临时文件移至指定目录
        NSString* directionPath = [location.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        [self moveFile:directionPath toPath:configuration.filePath];
    } didWriteData:^(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        // 回传下载进度
        configuration.currentLength = totalBytesWritten;
        configuration.totalLength = totalBytesExpectedToWrite;
        
        if (receiveDataLength) {
            dispatch_async(dispatch_get_main_queue(), ^{
                receiveDataLength(configuration);
            });
        }
    } didComplete:^(NSURLSessionTask *task, NSData *fileData, NSError *error) {
        // 结束回调
        if (completeBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(configuration, error);
            });
        }
    }];
    
    configuration.downloadTask = downloadTask;
    
    [downloadTask resume];
    
    return downloadTask;
}

- (void)moveFile:(NSString *)tmpPath toPath:(NSString *)filePath {
    NSData* data = [[NSData alloc] initWithContentsOfFile:tmpPath];
    [data writeToFile:filePath atomically:YES];
    [NSFileManager removefile:tmpPath];
}

/* dataTask */
- (NSURLSessionTask *)dataTaskWithConfig:(DownloadConfig *)configuration
                                  receiveDataLength:(void(^)(DownloadConfig* configuration))receiveDataLength
                                      completeBlock:(void(^)(DownloadConfig* configuration, NSError* error))completeBlock {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:configuration.URLString]];
    
    configuration.currentLength = [configuration availableDataLength:configuration.tmpPath];
    
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", configuration.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask* downloadTask = [self dataTaskWithRequest:request didReceiveData:^(NSURLSessionDataTask *dataTask, NSData *data) {
        //子线程返回
        [configuration didReceiveData:data];
        
        if (receiveDataLength) {
            dispatch_async(dispatch_get_main_queue(), ^{
                receiveDataLength(configuration);
            });
        }
    } didReceiveResponse:^NSURLSessionResponseDisposition(NSURLSessionDataTask *dataTask, NSURLResponse *response) {
        //子线程返回
        [configuration didReceiveResponse:response];
        
        return NSURLSessionResponseAllow;
    } didComplete:^(NSURLSessionTask *task,  NSData* fileData, NSError *error) {
        //子线程返回
        if (!error) {
            [configuration didComplete];
            
            if (completeBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(configuration, error);
                });
            }
        } else {
            if (completeBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(configuration, error);
                });
            }
        }
    }];
    
    configuration.downloadTask = downloadTask;
    
    [downloadTask resume];
    
    return downloadTask;
}

- (NSArray <DownloadFileStatus*> *)getDownloadsStatus:(NSArray *)configurations {
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:configurations.count];
    //1已下载、 2、未完成、3未下载、4正在下载
    [configurations enumerateObjectsUsingBlock:^(DownloadConfig*  _Nonnull configuration, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DownloadFileStatus* statusModel = [[DownloadFileStatus alloc] init];
        statusModel.fileName = configuration.fileName;
        statusModel.URLString = configuration.URLString;
        
        if ([NSFileManager isExistsAtPath:configuration.filePath]) {
            
            NSUInteger length = [configuration availableDataLength:configuration.filePath];
            if (length != 0) {
                statusModel.status = FileStatusTypeFinish;
                statusModel.length = length;
                statusModel.filePath = configuration.filePath;
                [result addObject:statusModel];
            }
        } else {
            NSUInteger length = [configuration availableDataLength:configuration.tmpPath];
            if (length != 0) {
                statusModel.status = FileStatusTypePause;
                statusModel.length =length;
                [result addObject:statusModel];
            } else {
                statusModel.status = FileStatusTypeBegin;
                statusModel.length = 0;
                [result addObject:statusModel];
            }
        }
    }];
    
    return [result copy];
}

@end
