//
//  GCDSemaphore.m
//  Basic
//
//  Created by zhengmiaokai on 2018/8/13.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "GCDSemaphore.h"

@interface GCDSemaphore ()

@property (nonatomic) dispatch_semaphore_t semaphore;

@end

@implementation GCDSemaphore

- (instancetype)initWithValue:(long)value {
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(value);
    }
    return self;
}

+ (instancetype)semaphore {
    GCDSemaphore* semaphore = [[GCDSemaphore alloc] initWithValue:1];
    return semaphore;
}

- (void)wait {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

- (void)signal {
    dispatch_semaphore_signal(_semaphore);
}

@end
