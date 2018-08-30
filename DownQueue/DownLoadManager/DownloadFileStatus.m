//
//  DownloadFileStatus.m
//  DownQueue
//
//  Created by zhengmiaokai on 2018/8/24.
//  Copyright © 2018年 xiaoniu66. All rights reserved.
//

#import "DownloadFileStatus.h"

@implementation DownloadFileStatus

- (void)setStatus:(NSInteger)status {
    _status = status;
    
    switch (status) {
        case 1:
            _statusName = @"预览";
            _operation = 0;
            break;
        case 2:
            _statusName = @"继续";
            _operation = 3;
            break;
        case 3:
            _statusName = @"下载";
            _operation = 1;
            break;
        case 4:
            _statusName = @"暂停";
            _operation = 2;
            break;
        default:
            break;
    }
}

@end

