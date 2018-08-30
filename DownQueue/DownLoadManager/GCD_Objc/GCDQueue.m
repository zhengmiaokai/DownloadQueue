//
//  GCDQueue.m
//  Basic
//
//  Created by zhengmiaokai on 2018/8/13.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "GCDQueue.h"

@implementation GCDQueue

+ (void)async_global:(void(^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

+ (void)async_main:(void(^)(void))block {
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)delay:(void(^)(void))block timeInterval:(NSTimeInterval)timeInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}


@end
