//
//  SystemLogManager.h
//  Mac01
//
//  Created by lpc on 2018/7/31.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemLogManager : NSObject

+ (instancetype)sharedManager;

- (void)getUserLoginlogs;

//- (void)systemLogs;

- (void)syslogCmdTest;

@end
