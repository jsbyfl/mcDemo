//
//  ProcessLogsWindowController.m
//  LogsDemo
//
//  Created by lpc on 2018/8/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import "ProcessLogsWindowController.h"
#import "SystemLogManager.h"

@interface ProcessLogsWindowController ()<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *listTabView;
@property (nonatomic,strong) NSArray *dataArray;
@property (unsafe_unretained) IBOutlet NSTextView *detailTextV;

@end

@implementation ProcessLogsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.title = @"系统诊断日志";
    
    self.listTabView.delegate = self;
    self.listTabView.dataSource = self;
    
    self.detailTextV.font = [NSFont systemFontOfSize:16];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SystemLogManager sharedManager] getSystemLogs:^(NSArray *datas) {
            // 倒序
            NSArray *list = [[datas reverseObjectEnumerator] allObjects];
            self.dataArray = [list copy];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.listTabView reloadData];
                if (self.dataArray.count > 0) {
                    [self showDetailWithRow:0];
                }
            });
        }];
    });
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 110;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _dataArray.count;
}

//View-base
//设置某个元素的具体视图
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    // 1.创建可重用的cell:
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    // 2. 根据重用标识，设置cell 数据
    if( [tableColumn.identifier isEqualToString:@"column_cell_id"] ){
        cellView.textField.font = [NSFont labelFontOfSize:15];
        
        ProcessLogModel *model = [self.dataArray objectAtIndex:row];
        NSMutableString *string = [NSMutableString stringWithFormat:@"-----序号:%ld ~ 总数:%ld-------\n",row+1,self.dataArray.count];
        [string appendFormat:@"进程名称: %@\n",model.Sender];
        [string appendFormat:@"进程ID: %@\n",model.PID];
        [string appendFormat:@"Time: %@\n",model.Time];
        [string appendFormat:@"Host: %@",model.Host];
        cellView.textField.stringValue = string;
        
        return cellView;
    }
    return cellView;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    [self showDetailWithRow:row];
    return YES;
}

- (void)showDetailWithRow:(NSInteger)row
{
    ProcessLogModel *model = [self.dataArray objectAtIndex:row];
    NSString *string = [NSString stringWithFormat:@"%@",model.getDesc_string];
    self.detailTextV.string = string;
}

////设置每行容器视图
//- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
//    TableRow * rowView = [[TableRow alloc]init];
//    return rowView;
//}

@end
