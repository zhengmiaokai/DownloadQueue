//
//  NSFileManager+Common.h
//  Basic
//
//  Created by zhengmiaokai on 2018/7/6.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Common)

/** 文件夹路劲
 *  foldName  文件名
 */
+ (NSString*)filePath:(NSString*)foldName;

/** 创建文件
 *  folderName 文件夹路劲
 *  fileName  文件名
 */
+ (NSString*)pathWithFileName:(NSString*)fileName foldPath:(NSString*)folderName;

/** 创建文件--文件夹已经创建的情况
 * filePath 路劲
 **/
+ (BOOL)creatFileWithPath:(NSString*)filePath;

/** 查询绝对路劲文件是否存在
 *  filePath 文件路劲
 */
+ (BOOL)isExistsAtPath:(NSString*)filePath;

/** 创建文件夹
 *  folderName 文件夹名
 */
+ (NSString *)createFileDirectories:(NSString*)folderName;

/** 删除文件
 *  filePath 文件路劲
 */
+ (BOOL)removefile:(NSString*)filePath;

@end
