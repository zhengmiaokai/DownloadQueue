//
//  NSArray+Additions.h
//  Basic
//
//  Created by zhengmiaokai on 16/5/12.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Access)

- (void)addSafeObject:(id _Nullable)anObject;

- (void)insertSafeObject:(id _Nullable)anObject atIndex:(NSInteger)index;

- (void)removeSafeObject:(id _Nullable)anObject;

- (void)removeSafeObjectAtIndex:(NSInteger)index;

@end

@interface NSArray (Additions)

/** 数组初始化容错  参数中有nil即终止添加，返回数组
 ** firstArg ... 不定参数
 **/
+ (NSArray* _Nullable)objects:(id _Nonnull)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

/** 数组初始化容错  如果while后的数组大小<count,返回nil
 ** count 数组大小
 ** firstArg ... 不定参数
 **/
+ (NSArray* _Nullable)arrayWithCount:(NSUInteger)count objects:(id _Nonnull)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

- (id _Nullable)safeObjectAtIndex:(NSUInteger)index;

- (id _Nullable)first;

- (id _Nullable)last;

+ (NSArray * _Nullable)getArray:(NSArray * _Nullable)array;

- (NSString * _Nullable)jsonString;

- (BOOL)isNotEmpty;

@end
