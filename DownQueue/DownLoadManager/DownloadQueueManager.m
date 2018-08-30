//
//  PTDownloadMangaer.m
//  Neptune
//
//  Created by zhengmiaokai on 2018/8/17.
//  Copyright © 2018年 NEO Capital. All rights reserved.
//

#import "DownloadQueueManager.h"
#import "DownloadTaskManager.h"

#import "GCDConstant.h"
#import "CategoryConstant.h"

@interface DownloadConfiguration ()

@property (nonatomic , assign) NSInteger totalLength;

@property (nonatomic , strong) NSFileHandle *writeHandle;

@property (nonatomic, strong) NSFileHandle *readHandle;

@end

@implementation DownloadConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.foldName = @"Downloads";
    }
    return self;
}

- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    
    self.filePath = [NSFileManager pathWithFileName:_fileName foldPath:_foldName];
    self.tmpPath = [NSFileManager pathWithFileName:[_fileName MD5Hash] foldPath:_foldName];
}

@end

@implementation DownloadQueueManager

+ (instancetype)sharedInstance {
    static DownloadQueueManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadQueueManager alloc] init];
    });
    return manager;
}

- (NSURLSessionDataTask *)downloadWithConfiguration:
(DownloadConfiguration *)configuration
                                  receiveDataLength:(void(^)(DownloadConfiguration* configuration))receiveDataLength
                                      completeBlock:(void(^)(DownloadConfiguration* configuration))completeBlock {
    
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
    } didComplete:^(NSURLSessionTask *task, NSError *error) {
        //子线程返回
        if ((configuration.currentLength == configuration.totalLength) && (configuration.totalLength > 0)) {
            configuration.currentLength = 0;
            configuration.totalLength = 0;
            
            [configuration.writeHandle closeFile];
            configuration.writeHandle = nil;
            
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
    [configurations enumerateObjectsUsingBlock:^(DownloadConfiguration*  _Nonnull configuration, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DownloadFileStatus* statusModel = [[DownloadFileStatus alloc] init];
        statusModel.fileName = configuration.fileName;
        statusModel.URLString = configuration.URLString;
        
        if ([NSFileManager isExistsAtPath:configuration.filePath]) {
            
            configuration.readHandle = [NSFileHandle fileHandleForReadingAtPath:configuration.filePath];
            if (configuration.readHandle) {
                NSUInteger length = [[configuration.readHandle availableData] length];
                statusModel.status = 1;
                statusModel.length = length;
                statusModel.filePath = configuration.filePath;
                [result addObject:statusModel];
            }
        }
        else {
            configuration.readHandle = [NSFileHandle fileHandleForReadingAtPath:configuration.tmpPath];
            if (configuration.readHandle) {
                NSUInteger length = [[configuration.readHandle availableData] length];
                statusModel.status = 2;
                statusModel.length =length;
                [result addObject:statusModel];
            }
            else {
                statusModel.status = 3;
                statusModel.length = 0;
                [result addObject:statusModel];
            }
        }
    }];
    
    return [result copy];
}

@end
