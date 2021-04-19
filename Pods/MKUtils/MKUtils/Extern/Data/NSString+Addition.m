//
//  NSString+Addition.m
//  BeiAi
//
//  Created by Apple on 14-3-11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "NSString+Addition.h"
#import "NSArray+Additions.h"
#import "MarcoConstant.h"

@implementation NSString (Addition)

- (BOOL)isNotEmpty {
    if ([self isKindOfClass:[NSString class]] && self && self.length>0) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringValue:(NSString *)str {
    if (!str) {
        return @"";
    }
    
    if ([str isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)str;
        return [NSString stringWithFormat:@"%@", number];
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    return str;
}

+ (NSString *)queryStringWithParameters:(NSDictionary *)parameters {
    NSMutableString *query = [NSMutableString string];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger index, BOOL *stop) {
        NSString *value = [parameters[key] description];
        key   = [key stringByURLEncoding];
        value = [value stringByURLEncoding];
        [query appendFormat:@"%@%@=%@", (index>0)?@"&":@"", key, value];
    }];
    return [query copy];
}

+ (NSDictionary *)queryToDictionary:(NSString *)query {
    NSArray* keyValues = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary* resultDic = [NSMutableDictionary dictionaryWithCapacity:keyValues.count];
    for (NSString* keyValue in keyValues) {
        NSArray* key_Value = [keyValue componentsSeparatedByString:@"="];
        NSString* key = [key_Value safeObjectAtIndex:0];
        NSString* value = [key_Value safeObjectAtIndex:1];
        [resultDic setValue:[value stringByURLDecoding] forKey:[key stringByURLDecoding]];
    }
    return [resultDic copy];
}

+ (NSString *)intToString:(int)num {
    return [NSString stringWithFormat:@"%d", num];
}

+ (NSString *)integerToString:(NSInteger)num {
    return [NSString stringWithFormat:@"%li", (long)num];
}

+ (BOOL)isInt:(NSString *)str {
    NSScanner* scan = [NSScanner scannerWithString:str];
    int iVal;
    return[scan scanInt:&iVal] && [scan isAtEnd];
}

+ (BOOL)isFloat:(NSString *)str {
    
    NSScanner* scan = [NSScanner scannerWithString:str];
    float fVal;
    return[scan scanFloat:&fVal] && [scan isAtEnd];
}

+ (NSString *)randomStringWithLength:(int)length {
    char codeList[] = "0123456789abcdefghijklmnopqrstuvwxyz";
    NSMutableString *randomString = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++) {
        char codeIndex = arc4random() % 26;
        [randomString appendString:[NSString stringWithFormat:@"%c", codeList[codeIndex]]];
    }
    
    return randomString;
}

#pragma mark - 字符串转换成十六进制
+ (NSString *)stringToHex:(const char *)key len:(NSUInteger)len {
    static char hex[1024];
    char buffer[8];
    for(unsigned n=0; n < len ; ++n) {
        sprintf(buffer, "%02x", (unsigned char)key[n]);
        hex[2*n]=buffer[0];
        hex[2*n+1]=buffer[1];
    }
    hex[len*2]='\0';
    
    return [NSString stringWithUTF8String:hex];
}

#pragma mark -  去除两边的空格
+ (NSString *)stringWithOutSpace:(NSString *)str {
    if(!str)
        return nil;
        
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/** 本地化
 */
+ (NSString *)getStringWithString:(NSString *)aString {
    
	NSString *string = NSLocalizedString(aString, nil);
	return string;
}

#pragma mark - URL Encoding/Decoding

- (NSString *)stringByURLEncoding {
    NSCharacterSet *allowedCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharactersSet];
}

- (NSString *)stringByURLDecoding {
    return [self stringByRemovingPercentEncoding];
}

#pragma mark - base64
+ (NSString *)base64ForData:(NSData *)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i = 0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (CGSize)contentSizeWithFont:(UIFont *)font {
    return [self contentSizeWithFont:font constrainedToSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX)];
}

- (CGSize)contentSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return result;
}

- (NSString *)trim {
    if (![self isKindOfClass:[NSString class]]) {
        return self;
    }
    NSMutableString *bStr = [NSMutableString string];
    [bStr setString:self];
    CFStringTrimWhitespace((CFMutableStringRef) bStr);
    return bStr;
}

@end
