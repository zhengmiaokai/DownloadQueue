//
//  GCDQueue.h
//  Basic
//
//  Created by zhengmiaokai on 2018/8/13.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDQueue : NSObject

+ (void)async_global:(void(^)(void))block;

+ (void)async_main:(void(^)(void))block;

+ (void)delay:(void(^)(void))block timeInterval:(NSTimeInterval)timeInterval;

@end
