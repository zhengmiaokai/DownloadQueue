//
//  ViewController.m
//  DownQueue
//
//  Created by zhengmiaokai on 2018/8/23.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "ViewController.h"
#import <MKUtils/NSArray+Additions.h>
#import "DownloadQueueManager.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* configurations;

@property (nonatomic, strong) NSArray <DownloadFileStatus*> * statusArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createViews];
    [self createFields];
}

- (void)createViews {
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)createFields {
    
    self.configurations = [NSMutableArray array];
    
     NSArray* datas = @[@{@"URLString" : @"https://dldir1.qq.com/weixin/mac/WeChat_2.3.17.18.dmg", @"fileName" : @"WeChat_2.3.17.18.dmg"}, @{@"URLString" : @"https://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.0.dmg", @"fileName" : @"Q_V6.5.0.dmg"}];
    
    NSMutableArray* configurations = [NSMutableArray arrayWithCapacity:datas.count];
    
    for (NSDictionary* data in datas) {
        
        NSString* URLString = data[@"URLString"];
        NSString* fileName = data[@"fileName"];
        
        DownloadConfig* config = [[DownloadConfig alloc] init];
        config.URLString = URLString;
        config.fileName = fileName;
        [configurations addObject:config];
    }
    
    /* 查询文件的状态 status: 1已下载、 2、未完成、3未下载、4正在下载 */
    self.statusArr = [[DownloadQueueManager sharedInstance] getDownloadsStatus:configurations];
    
    [_tableView reloadData];
}

- (void)dowloadWithData:(NSInteger)index {
    
    DownloadFileStatus* statusData  = [_statusArr safeObjectAtIndex:index];
    statusData.status = FileStatusTypeLoading;
    
    DownloadConfig* config = [[DownloadConfig alloc] init];
    config.URLString = statusData.URLString;
    config.fileName = statusData.fileName;
    [_configurations addObject:config];
    
    /* 下载（支持断点续传）*/
     __weak typeof(self) weakSelf = self;
    [[DownloadQueueManager sharedInstance] dataTaskWithConfig:config receiveDataLength:^(DownloadConfig *configuration) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        statusData.length = configuration.currentLength;
        [strongSelf.tableView reloadData];
    } completeBlock:^(DownloadConfig *configuration, NSError* error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            statusData.status = FileStatusTypeError;
        } else {
            statusData.status = FileStatusTypeFinish;
            statusData.filePath = configuration.filePath;
        }
        [strongSelf.tableView reloadData];
    }];
}

- (void)suspend:(NSInteger)index {
    /* 挂起 */
    
    DownloadFileStatus* statusData  = [_statusArr safeObjectAtIndex:index];
    
    __weak typeof(self) weakSelf = self;
    [_configurations enumerateObjectsUsingBlock:^(DownloadConfig*  _Nonnull config, NSUInteger idx, BOOL * _Nonnull stop) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([config.URLString isEqualToString:statusData.URLString]) {
            [config.downloadTask suspend];
            statusData.status = FileStatusTypePause;
            [strongSelf.tableView reloadData];
            *stop = YES;
        }
    }];
}

- (void)resume:(NSInteger)index {
    /* 恢复 */
    DownloadFileStatus* statusData  = [_statusArr safeObjectAtIndex:index];
    
    __block BOOL isHave = NO;
    __weak typeof(self) weakSelf = self;
    [_configurations enumerateObjectsUsingBlock:^(DownloadConfig*  _Nonnull config, NSUInteger idx, BOOL * _Nonnull stop) {
       __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([config.URLString isEqualToString:statusData.URLString]) {
            isHave = YES;
            [config.downloadTask resume];
            statusData.status = FileStatusTypeLoading;
            [strongSelf.tableView reloadData];
            *stop = YES;
        }
    }];
    
    if (isHave == NO) {
        [self dowloadWithData:index];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _statusArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentify = @"cellIdentify";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {//可另外封装成子Cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        CGFloat lineHeight = [UIFont systemFontOfSize:18].lineHeight;
        
        UILabel* centerLab = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.bounds.size.width - 120 - 20, (70 - lineHeight) / 2.0, 70,lineHeight)];
        centerLab.font = [UIFont systemFontOfSize:18];
        centerLab.textColor = [UIColor lightGrayColor];
        centerLab.textAlignment = NSTextAlignmentCenter;
        centerLab.tag = 2345;
        [cell.contentView addSubview:centerLab];
        
        UILabel* rightLab = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.bounds.size.width - 50 - 15, (70 - lineHeight) / 2.0, 50, lineHeight)];
        rightLab.font = [UIFont systemFontOfSize:18];
        rightLab.textColor = [UIColor lightGrayColor];
        rightLab.textAlignment = NSTextAlignmentCenter;
        rightLab.tag = 1234;
        [cell.contentView addSubview:rightLab];
    }
    
    DownloadFileStatus* statusData = [_statusArr safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = statusData.fileName;
    
    UILabel* centerLab =[cell.contentView viewWithTag:2345];
    
    centerLab.text = [NSString stringWithFormat:@"%liMB",statusData.length/1024/1024];
    
    UILabel* rightLab = [cell.contentView viewWithTag:1234];
    
    rightLab.text = statusData.statusName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadFileStatus* status = [_statusArr safeObjectAtIndex:indexPath.row];
    
    switch (status.operation) {
        case 1:
            [self dowloadWithData:indexPath.row];
            break;
        case 2:
            [self suspend:indexPath.row];
            break;
        case 3:
            [self resume:indexPath.row];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
