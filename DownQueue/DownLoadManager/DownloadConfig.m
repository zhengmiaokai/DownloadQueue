//
//  DownloadConfig.m
//  Basic
//
//  Created by mikazheng on 2020/5/28.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import "DownloadConfig.h"
#import <MKUtils/NSFileManager+Addition.h>
#import <MKUtils/NSString+Sign.h>

@interface DownloadConfig ()

@property (nonatomic, strong) NSFileHandle *writeHandle;

@end

@implementation DownloadConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.foldName = @"Downloads";
    }
    return self;
}

- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    
    NSString* folderPath = [NSFileManager forderPathWithFolderName:_foldName directoriesPath:LibraryPath()];
    
    _filePath = [[NSFileManager pathWithFileName:_fileName foldPath:folderPath] copy];
    _tmpPath = [[NSFileManager pathWithFileName:[_fileName MD5] foldPath:folderPath] copy];
}

- (void)didReceiveData:(NSData *)data {
    [self.writeHandle seekToEndOfFile];
    [self.writeHandle writeData:data];
    
    self.currentLength += data.length;
}

- (void)didComplete {
    self.currentLength = 0;
    self.totalLength = 0;
    
    [self.writeHandle closeFile];
    
    NSData* data = [[NSData alloc] initWithContentsOfFile:self.tmpPath];
    [data writeToFile:self.filePath atomically:YES];
    [NSFileManager removefile:self.tmpPath];
}

- (void)didReceiveResponse:(NSURLResponse *)response {
    if (((NSHTTPURLResponse *)response).statusCode/200 == 1) {
        self.totalLength = response.expectedContentLength + self.currentLength;
        
        if ([NSFileManager creatFileWithPath:self.tmpPath]) {
            self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.tmpPath];
        }
    }
}

- (NSUInteger)availableDataLength:(NSString *)path {
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (readHandle) {
        NSUInteger length = [[readHandle availableData] length];
        return length;
    } else {
        return 0;
    }
}

@end
