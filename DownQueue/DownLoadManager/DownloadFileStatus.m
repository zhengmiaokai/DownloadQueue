//
//  DownloadFileStatus.m
//  DownQueue
//
//  Created by zhengmiaokai on 2018/8/24.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "DownloadFileStatus.h"

@implementation DownloadFileStatus

- (void)setStatus:(FileStatusType)status {
    _status = status;
    
    switch (status) {
        case FileStatusTypeFinish:
            _statusName = @"预览";
            _operation = FileOperationTypeOpen;
            break;
        case FileStatusTypePause:
            _statusName = @"继续";
            _operation = FileOperationTypeContinue;
            break;
        case FileStatusTypeBegin:
            _statusName = @"下载";
            _operation = FileOperationTypeDownload;
            break;
        case FileStatusTypeLoading:
            _statusName = @"暂停";
            _operation = FileOperationTypePause;
            break;
        case FileStatusTypeError:
            _statusName = @"失败";
            _operation = FileOperationTypeError;
            break;
        default:
            break;
    }
}

@end

