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
	
	CC_MD5_CTX md5;
	CC_MD5_Init (&md5);
	CC_MD5_Update (&md5, [self UTF8String], (unsigned int)[self length]);
		
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &md5);
	NSString *MD5String = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0],  digest[1], digest[2],  digest[3],
				   digest[4],  digest[5],
				   digest[6],  digest[7],
				   digest[8],  digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
	return MD5String;
}

- (NSData *)MD5Data {
    CC_MD5_CTX md5;
	CC_MD5_Init (&md5);
	CC_MD5_Update (&md5, [self UTF8String], (unsigned int)[self length]);
    
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &md5);
    
    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
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
    return SHA1String;
}

@end

