//
//  GCDGroup.m
//  Basic
//
//  Created by zhengmiaokai on 2018/8/13.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "GCDGroup.h"

@interface GCDGroup ()

@property (nonatomic) dispatch_group_t group;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation GCDGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        self.group = dispatch_group_create();
        self.queue = dispatch_queue_create("GCD_CONCURRENT_QUEUE", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)enter {
    dispatch_group_enter(_group);
}

- (void)leave {
    dispatch_group_leave(_group);
}

- (void)async:(void(^)(void))block {
    dispatch_group_async(_group, _queue, block);
}

- (void)notify:(void(^)(void))block {
    dispatch_group_notify(_group, dispatch_get_main_queue(), block);
}

- (void)wait:(NSTimeInterval)timeInterval {
    dispatch_group_wait(_group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)));
}

@end
