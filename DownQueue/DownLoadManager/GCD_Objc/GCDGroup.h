//
//  GCDGroup.h
//  Basic
//
//  Created by zhengmiaokai on 2018/8/13.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDGroup : NSObject

- (void)enter; //+1   为0时触发nitify

- (void)leave; //-1   为0时触发nitify

- (void)async:(void(^)(void))block;//异步并行

- (void)notify:(void(^)(void))block;//回调到主线程

- (void)wait:(NSTimeInterval)timeInterval;//类似于 sleep(2),阻塞线程 随着 enter->leave 失效

@end
