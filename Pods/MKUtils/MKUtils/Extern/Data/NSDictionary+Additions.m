//
//  NSDictionary+Additions.m
//  Basic
//
//  Created by zhengMK on 16/4/2.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#import "NSDictionary+Additions.h"
#import "NSObject+Additions.h"

@implementation NSMutableDictionary (Additions)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)removeSafeOjectForKey:(id)aKey {
    if (aKey) {
        [self removeObjectForKey:aKey];
    }
}

@end

@implementation NSDictionary (Additions)

+ (NSDictionary *)getDictionary:(id)dict {
    if (!dict) {
        return [NSDictionary dictionary];
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionary];
    }
    
    return dict;
}

- (BOOL)isNotEmpty {
    return self && [self isKindOfClass:[NSDictionary class]] && [[self allKeys] count] > 0;
}

- (BOOL)boolForKey:(NSString *)key {
    return [self boolForKey:key defaultValue:NO];
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == [NSNull null] ? defaultValue
    : [[self objectForKey:key] boolValue];
}

- (int)intForKey:(NSString *)key {
    return [self intForKey:key defaultValue:0];
}

- (int)uintForKey:(NSString *)key
{
    return [self uintForKey:key defaultValue:0];
}

- (float)floatForKey:(NSString *)key {
    return [self floatForKey:key defaultValue:0.0];
}

- (int)intForKey:(NSString *)key defaultValue:(int)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] intValue];
}

- (int)uintForKey:(NSString *)key defaultValue:(int)defaultValue {
    return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] unsignedIntValue];
}

- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] floatValue];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    NSObject *obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }
    return nil;
}

- (NSArray *)arrayValueForKey:(NSString *)key {
    NSObject *obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    }
    return nil;
}

- (NSDate *)dateForKey:(NSString *)key {
    id timeObject = [self objectForKey:key];
    
    if ([timeObject isKindOfClass:[NSNull class]] || timeObject == nil) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    
    NSDate *destDate = [dateFormatter dateFromString:timeObject];
    
    if (destDate == nil) {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        destDate = [dateFormatter dateFromString:timeObject];
    }
    
    return destDate;
}

- (time_t)timeForKey:(NSString *)key {
    return [self timeForKey:key defaultValue:0];
}

- (time_t)timeForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	id timeObject = [self objectForKey:key];
    if ([timeObject isKindOfClass:[NSNumber class]]) {
        NSNumber *n = (NSNumber *)timeObject;
        CFNumberType numberType = CFNumberGetType((CFNumberRef)n);
        NSTimeInterval t;
        if (numberType == kCFNumberLongLongType) {
            t = [n longLongValue] / 1000;
        }
        else {
            t = [n longValue];
        }
        return t;
    }
    else if ([timeObject isKindOfClass:[NSString class]]) {
        NSString *stringTime = timeObject;
        if (stringTime.length == 13) {
            long long llt = [stringTime longLongValue];
            NSTimeInterval t = llt / 1000;
            return t;
        }
        else if (stringTime.length == 10) {
            long long lt = [stringTime longLongValue];
            NSTimeInterval t = lt;
            return t;
        }
        else {
            if (!stringTime || (id)stringTime == [NSNull null]) {
                stringTime = @"";
            }
            struct tm created;
            time_t now;
            time(&now);
            
            if (stringTime) {
                if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
                    if (strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created) == NULL) {
                        strptime([stringTime UTF8String], "%Y-%m-%d %H:%M:%s", &created);
                    }
                }
                return mktime(&created);
            }
        }
    }
	return defaultValue;
}

- (long long)longLongForKey:(NSString *)key {
    return [self longLongForKey:key defaultValue:0];
}

- (long long)longLongForKey:(NSString *)key defaultValue:(long long)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] longLongValue];
}

- (double)doubleForKey:(NSString *)key {
    return [self doubleForKey:key defaultValue:0];
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] doubleValue];
}

- (NSString *)stringForKey:(NSString *)key {
    return [self stringForKey:key defaultValue:nil];
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    if ([self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null]) {
        return defaultValue;
    }
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSNumber class]]) {
        return [result stringValue];
    }
    return result;
}

- (NSArray *)arrayObjectForKey:(NSString *)key
                  defaultValue:(NSArray *)defaultValue {
    id obj = [self objectForKey:key];
	return obj == nil || obj == [NSNull null] || ![obj isKindOfClass:[NSArray class]]
    ? defaultValue : obj;
}

- (NSArray *)arrayObjectForKey:(NSString *)key  {
    return [self arrayObjectForKey:key defaultValue:nil];
}

- (NSDictionary *)dictionaryObjectForKey:(NSString *)key
                            defaultValue:(NSDictionary *)defaultValue {
    id obj = [self objectForKey:key];
	return obj == nil || obj == [NSNull null] || ![obj isKindOfClass:[NSDictionary class]]
    ? defaultValue : obj;
}

- (NSDictionary *)dictionaryObjectForKey:(NSString *)key {
    return [self dictionaryObjectForKey:key defaultValue:nil];
}

- (NSString *)jsonString {
    if (checkSetAvailable(self)) {
        @try {
            NSData *postData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
            NSString* jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            return jsonString;
        } @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else {
        return nil;
    }
}


@end
