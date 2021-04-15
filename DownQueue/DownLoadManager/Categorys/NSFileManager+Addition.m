//
//  NSFileManager+Addition.m
//  Basic
//
//  Created by zhengmiaokai on 2018/7/6.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "NSFileManager+Addition.h"

@implementation NSFileManager (Addition)

/* Document目录
 */
NSString* DocumentPath(void) {
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    /*
    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
     */
    return documentPath;
}

/* Library目录
 */
NSString* LibraryPath(void) {
    NSString* libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    return libraryPath;
}

/* Temp目录
 */
NSString* TempPath(void) {
    NSString* tempPath = NSTemporaryDirectory();
    return tempPath;
}

/** 创建文件夹
 *  folderName 文件夹名
 * directoriesPath 目录路劲
 */
+ (NSString *)forderPathWithFolderName:(NSString*)folderName directoriesPath:(NSString *)directoriesPath {
    
    NSString* folderPath = [directoriesPath stringByAppendingPathComponent:folderName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
    return folderPath;
}

/** 文件路劲
 *  folderName 文件名
 *  folderPath  文件夹路劲
 */
+ (NSString*)pathWithFileName:(NSString*)fileName foldPath:(NSString*)folderPath {
    
    NSString* filePath = [folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}

/** 创建文件--文件夹已经创建的情况
 * filePath 路劲
 **/
+ (BOOL)creatFileWithPath:(NSString*)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if(!isDirExist) {
        BOOL bCreateDir = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if(!bCreateDir){
            return NO;
        }
    }
    return YES;
}

/** 查询绝对路劲文件是否存在
 *  filePath 文件路劲
 */
+ (BOOL)isExistsAtPath:(NSString*)filePath {
    
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    return isExists;
}

/** 删除文件
 *  filePath 文件路劲
 */
+ (BOOL)removefile:(NSString*)filePath {
    NSError* error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error == nil) {
        return YES;
    }
    else{
        return NO;
    }
    return success;
}

@end
