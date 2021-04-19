//
//  NSArray+Additions.m
//  Basic
//
//  Created by zhengmiaokai on 16/5/12.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#import "NSArray+Additions.h"
#import "NSObject+Additions.h"

@implementation NSMutableArray (Access)

- (void)addSafeObject:(id _Nullable)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void)insertSafeObject:(id _Nullable)anObject atIndex:(NSInteger)index {
    if (anObject && (index >=0) && (index <= self.count)) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)removeSafeObject:(id _Nullable)anObject {
    if (anObject && [self containsObject:anObject]) {
        [self removeObject:anObject];
    }
}

- (void)removeSafeObjectAtIndex:(NSInteger)index {
    if ((index >=0) && (index < self.count)) {
        [self removeObjectAtIndex:index];
    }
}

@end

@implementation NSArray (Additions)

+ (instancetype)objects:(id)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    NSArray* results = nil;
    
    if(firstArg) {
        @autoreleasepool {
            NSMutableArray* tempArr = [NSMutableArray array];
            [tempArr addObject:firstArg];
            
            va_list args;
            id object;
            va_start(args, firstArg);
            
            while ((object = va_arg(args, id)))
            {
                [tempArr addObject:object];
            }
            va_end(args);
            
            results = [NSArray arrayWithArray:tempArr];
        }
    }
    
    return results;
}

+ (instancetype)arrayWithCount:(NSUInteger)count objects:(id)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    NSArray* results = nil;
    
    if(firstArg)
    {
        @autoreleasepool {
            NSMutableArray* tempArr = [NSMutableArray array];
            [tempArr addObject:firstArg];
            
            va_list args;
            id object;
            va_start(args, firstArg);
            
            while ((object = va_arg(args, id))) {
                [tempArr addObject:object];
            }
            va_end(args);
            
            if (count == tempArr.count) {
                results = [NSArray arrayWithArray:tempArr];
            }
        }
    }
    
    return results;
}

- (id _Nullable)safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    } else {
        return nil;
    }
}

- (id _Nullable)first {
    return [self count] > 0 ? [self objectAtIndex:0] : nil;
}

- (id _Nullable)last {
    return [self lastObject];
}

+ (NSArray *)getArray:(NSArray *)array {
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array;
    }
    return [NSArray array];
}

- (BOOL)isNotEmpty {
    return self && [self isKindOfClass:[NSArray class]] && [self count] > 0;
}

- (NSString *)jsonString {
    if (checkSetAvailable(self)) {
        @try {
            NSData *postData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
            NSString* jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            return jsonString;
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } else {
        return nil;
    }
}

@end
