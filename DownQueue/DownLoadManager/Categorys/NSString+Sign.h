//
// NSString+Sign.h
// Originally created for MyFile
//
// Created by Árpád Goretity, 2011. Some infos were grabbed from StackOverflow.
// Released into the public domain. You can do whatever you want with this within the limits of applicable law (so nothing nasty!).
// I'm not responsible for any damage related to the use of this software. There's NO WARRANTY AT ALL.
// MD5

#import <Foundation/Foundation.h>

@interface NSString (Sign)

- (NSString *)MD5;

- (NSData *)MD5Data;

- (NSString*)SHA1;

@end

