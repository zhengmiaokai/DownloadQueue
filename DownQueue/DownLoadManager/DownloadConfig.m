//
//  DownloadConfig.m
//  Basic
//
//  Created by mikazheng on 2020/5/28.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import "DownloadConfig.h"
#import "CategoryConstant.h"

@interface DownloadConfig ()

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

@end
