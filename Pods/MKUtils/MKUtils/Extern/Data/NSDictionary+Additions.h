//
//  NSDictionary+Additions.h
//  Basic
//
//  Created by zhengMK on 16/4/2.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Additions)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (void)removeSafeOjectForKey:(id)aKey;

@end

@interface NSDictionary (Additions)

+ (NSDictionary *)getDictionary:(id)dict;
- (BOOL)isNotEmpty;

- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int)intForKey:(NSString *)key;
- (int)intForKey:(NSString *)key defaultValue:(int)defaultValue;

- (int)uintForKey:(NSString *)key;
- (int)uintForKey:(NSString *)key defaultValue:(int)defaultValue;

- (float)floatForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;

- (NSDate *)dateForKey:(NSString *)key;

- (time_t)timeForKey:(NSString *)key;
- (time_t)timeForKey:(NSString *)key defaultValue:(time_t)defaultValue;

- (long long)longLongForKey:(NSString *)key;
- (long long)longLongForKey:(NSString *)key defaultValue:(long long)defaultValue;

- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSDictionary *)dictionaryForKey:(NSString *)key;

- (NSArray *)arrayValueForKey:(NSString *)key;

- (double)doubleForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;

- (NSString *)jsonString;

@end
