//
//  PTDownloadMangaer.m
//  Neptune
//
//  Created by zhengmiaokai on 2018/8/17.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "DownloadQueueManager.h"
#import "DownloadTaskQueue.h"
#import "GCDConstant.h"
#import "CategoryConstant.h"

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
                                      completeBlock:(void(^)(DownloadConfig* configuration))completeBlock {
    NSURLSessionDownloadTask* downloadTask = [self downloadTaskWithURLString:configuration.URLString didFinishDownloading:^(NSURLSessionDownloadTask *downloadTask, NSURL *location) {
        // 下载完成，将临时文件移至指定目录
        NSString* directionPath = [location.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        [self moveFile:directionPath toPath:configuration.filePath];
    } didWriteData:^(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        // 回传下载进度
        configuration.currentLength = totalBytesWritten;
        configuration.totalLength = totalBytesExpectedToWrite;
        
        [GCDQueue async_main:^{
            if (receiveDataLength) {
                receiveDataLength(configuration);
            }
        }];
    } didComplete:^(NSURLSessionTask *task, NSData *fileData, NSError *error) {
        // 结束回调
        [GCDQueue async_main:^{
            if (completeBlock) {
                completeBlock(configuration);
            }
        }];
    }];
    
    configuration.downloadTask = downloadTask;
    
    [downloadTask resume];
    
    return downloadTask;
}

/* dataTask */
- (NSURLSessionTask *)dataTaskWithConfig:(DownloadConfig *)configuration
                                  receiveDataLength:(void(^)(DownloadConfig* configuration))receiveDataLength
                                      completeBlock:(void(^)(DownloadConfig* configuration))completeBlock {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:configuration.URLString]];
    
    configuration.readHandle = [NSFileHandle fileHandleForReadingAtPath:configuration.tmpPath];
    
    configuration.currentLength = [[configuration.readHandle availableData] length];
    
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", configuration.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask* downloadTask = [self dataTaskWithRequest:request didReceiveData:^(NSURLSessionDataTask *dataTask, NSData *data) {
        //子线程返回
        [configuration.writeHandle seekToEndOfFile];
        
        [configuration.writeHandle writeData:data];
        
        configuration.currentLength += data.length;
        
        [GCDQueue async_main:^{
            receiveDataLength(configuration);
        }];
    } didReceiveResponse:^NSURLSessionResponseDisposition(NSURLSessionDataTask *dataTask, NSURLResponse *response) {
        NSLog(@"启动任务");
        //子线程返回
        
        configuration.totalLength = response.expectedContentLength + configuration.currentLength;
        
        if ([NSFileManager creatFileWithPath:configuration.tmpPath]) {
            configuration.writeHandle = [NSFileHandle fileHandleForWritingAtPath:configuration.tmpPath];
        }
        
        return NSURLSessionResponseAllow;
    } didComplete:^(NSURLSessionTask *task,  NSData* fileData, NSError *error) {
        //子线程返回
        if ((configuration.currentLength == configuration.totalLength) && (configuration.totalLength > 0)) {
            configuration.currentLength = 0;
            configuration.totalLength = 0;
            
            [configuration.writeHandle closeFile];
            
            [self moveFile:configuration.tmpPath toPath:configuration.filePath];
            
            
            [GCDQueue async_main:^{
                completeBlock(configuration);
            }];
        }
        else {
            NSLog(@"downloadError：%@",error.description);
        }
    }];
    
    configuration.downloadTask = downloadTask;
    
    [downloadTask resume];
    
    return downloadTask;
}

- (void)moveFile:(NSString *)tmpPath toPath:(NSString *)path {
    NSData* data = [[NSData alloc] initWithContentsOfFile:tmpPath];
    [data writeToFile:path atomically:YES];
    [NSFileManager removefile:tmpPath];
}

- (NSArray <DownloadFileStatus*> *)getDownloadsStatus:(NSArray *)configurations {
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:configurations.count];
    //1已下载、 2、未完成、3未下载、4正在下载
    [configurations enumerateObjectsUsingBlock:^(DownloadConfig*  _Nonnull configuration, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DownloadFileStatus* statusModel = [[DownloadFileStatus alloc] init];
        statusModel.fileName = configuration.fileName;
        statusModel.URLString = configuration.URLString;
        
        if ([NSFileManager isExistsAtPath:configuration.filePath]) {
            
            configuration.readHandle = [NSFileHandle fileHandleForReadingAtPath:configuration.filePath];
            if (configuration.readHandle) {
                NSUInteger length = [[configuration.readHandle availableData] length];
                statusModel.status = FileStatusTypeFinish;
                statusModel.length = length;
                statusModel.filePath = configuration.filePath;
                [result addObject:statusModel];
            }
        }
        else {
            configuration.readHandle = [NSFileHandle fileHandleForReadingAtPath:configuration.tmpPath];
            if (configuration.readHandle) {
                NSUInteger length = [[configuration.readHandle availableData] length];
                statusModel.status = FileStatusTypePause;
                statusModel.length =length;
                [result addObject:statusModel];
            }
            else {
                statusModel.status = FileStatusTypeBegin;
                statusModel.length = 0;
                [result addObject:statusModel];
            }
        }
    }];
    
    return [result copy];
}

@end
