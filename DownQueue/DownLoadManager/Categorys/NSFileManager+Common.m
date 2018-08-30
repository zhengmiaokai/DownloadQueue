//
//  NSFileManager+Common.m
//  Basic
//
//  Created by zhengmiaokai on 2018/7/6.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "NSFileManager+Common.h"

@implementation NSFileManager (Common)

/** 文件夹路劲
 *  foldName  文件名
 */
+ (NSString*)filePath:(NSString*)foldName
{
    NSString* filePath = [self createFileDirectories:foldName];//文件夹;
    return filePath;
}

/** 创建文件
 *  folderName 文件夹路劲
 *  fileName  文件名
 */
+ (NSString*)pathWithFileName:(NSString*)fileName foldPath:(NSString*)folderName {
    
    NSString* folderPath = [self createFileDirectories:folderName];
    
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

/** 创建文件夹
 *  folderName 文件夹名
 */
+ (NSString *)createFileDirectories:(NSString*)folderName {
    
    NSString* libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    /*
     NSString* cachesPath = [libraryPath stringByAppendingPathComponent:@"Caches"];
     */
    NSString* folderPath = [libraryPath stringByAppendingPathComponent:folderName];
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
