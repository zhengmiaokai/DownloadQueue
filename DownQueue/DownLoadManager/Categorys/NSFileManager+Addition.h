//
//  NSFileManager+Addition.h
//  Basic
//
//  Created by zhengmiaokai on 2018/7/6.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Addition)

/* Document目录
 */
NSString* DocumentPath(void);

/* Library目录
 */
NSString* LibraryPath(void);

/* Temp目录
 */
NSString* TempPath(void);

/** 创建文件夹
 *  folderName 文件夹名
 * directoriesPath 目录路劲
 */
+ (NSString *)forderPathWithFolderName:(NSString*)folderName directoriesPath:(NSString *)directoriesPath;

/** 文件路劲
 *  folderName 文件名
 *  folderPath  文件夹路劲
 */
+ (NSString*)pathWithFileName:(NSString*)fileName foldPath:(NSString*)folderPath;

/** 创建文件--文件夹已经创建的情况
 * filePath 路劲
 **/
+ (BOOL)creatFileWithPath:(NSString*)filePath;

/** 查询绝对路劲文件是否存在
 *  filePath 文件路劲
 */
+ (BOOL)isExistsAtPath:(NSString*)filePath;

/** 删除文件
 *  filePath 文件路劲
 */
+ (BOOL)removefile:(NSString*)filePath;

@end
