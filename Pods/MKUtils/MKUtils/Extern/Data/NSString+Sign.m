//
// NSString+Sign.m
// Originally created for MyFile
//
// Created by Árpád Goretity, 2011. Some infos were grabbed from StackOverflow.
// Released into the public domain. You can do whatever you want with this within the limits of applicable law (so nothing nasty!).
// I'm not responsible for any damage related to the use of this software. There's NO WARRANTY AT ALL.
//

#import "NSString+Sign.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Sign)

- (NSString *)MD5 {
    if (self.length == 0) {
        return @"";
    }
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]]; //X为大写
    }
    return [ret lowercaseString];
}

- (NSString*)SHA1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void) CC_SHA1( [data bytes], (CC_LONG)[data length], hash );
    
    NSData *SHA1Data = [NSData dataWithBytes:hash length: CC_SHA1_DIGEST_LENGTH];
    const unsigned *SHA1Bytes = [SHA1Data bytes];
    
    NSString *SHA1String = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x",
                           ntohl(SHA1Bytes[0]), ntohl(SHA1Bytes[1]), ntohl(SHA1Bytes[2]),
                           ntohl(SHA1Bytes[3]), ntohl(SHA1Bytes[4])];
    return [SHA1String lowercaseString];
}

@end

