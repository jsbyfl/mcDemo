//
//  LoginLogsWindowController.m
//  LogsDemo
//
//  Created by lpc on 2018/8/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import "LoginLogsWindowController.h"
#import "SystemLogManager.h"

@interface LoginLogsWindowController ()<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *listTabView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation LoginLogsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.title = @"用户登录/退出日志";

    self.dataArray = [[SystemLogManager sharedManager] getUserLoginlogs];
    self.listTabView.delegate = self;
    self.listTabView.dataSource = self;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 60;
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
        cellView.textField.font = [NSFont labelFontOfSize:16];
        
        LoginLogModel *model = [self.dataArray objectAtIndex:row];
        NSString *string = [NSString stringWithFormat:@"-----序号:%ld ~ 总数:%ld-------\n%@ %@ %@",row+1,self.dataArray.count,model.user,model.type_desc,model.dateString];
        cellView.textField.stringValue = string;
        
        return cellView;
    }
    return cellView;
}

////设置每行容器视图
//- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
//    TableRow * rowView = [[TableRow alloc]init];
//    return rowView;
//}


@end
