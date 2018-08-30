//
//  NSString+Addition.h
//  BeiAi
//
//  Created by Apple on 14-3-11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Addition)

/** 判断是不是空
 */
+ (BOOL)isNotEmpty:(NSString *)string;

/** 强装换
 */
+ (NSString *)stringValue:(NSString *)str;

/** int 转 string
 */
+ (NSString *)intToString:(int)num;

/** integer 转 string
 */
+ (NSString *)integerToString:(NSInteger)num;

/** 随机生成多少位的字符串
 */
+ (NSString *)randomStringWithLength:(int)length;

/** 字符串转换成十六进制
 */
+ (NSString *)stringToHex:(const char *)key len:(NSUInteger)len;

/** 去除前后的空格
 */
+ (NSString *)stringWithOutSpace:(NSString *)str ;

/** 是否全数字
 */
+ (BOOL)isInt:(NSString *)str ;

/** 是否小数
 */
+ (BOOL)isFloat:(NSString *)str ;

/** 本地化转化
 */
+ (NSString *)getStringWithString:(NSString *)aString;

/** base64
 */
+ (NSString *)base64ForData:(NSData *)theData;


@end

