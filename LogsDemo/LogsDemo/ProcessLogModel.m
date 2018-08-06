//
//  ProcessLogModel.m
//  LogsDemo
//
//  Created by lpc on 2018/8/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import "ProcessLogModel.h"

@implementation ProcessLogModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.tempDic = [dic copy];
        
        self.ASLMessageID = dic[@"ASLMessageID"];
        self.Time = dic[@"Time"];
        self.TimeNanoSec = dic[@"TimeNanoSec"];
        self.Level = dic[@"Level"];
        
        self.PID = dic[@"PID"];
        self.UID = dic[@"UID"];
        self.GID = dic[@"GID"];
        self.ReadGID = dic[@"ReadGID"];
        
        self.Host = dic[@"Host"];
        self.Sender = dic[@"Sender"];
        self.SenderMachUUID = dic[@"SenderMachUUID"];
    }
    return self;
}

- (NSString *)Level
{
    /*
     https://blog.csdn.net/yangxuan12580/article/details/51497069
     */
    
    NSString *level_string = @"";
    switch (_Level.intValue) {
        case 0:
            level_string = @"LOG_EMERG";
            level_string = [level_string stringByAppendingString:@"(0_system is unusable)"];
            break;
        case 1:
            level_string = @"LOG_ALERT";
            level_string = [level_string stringByAppendingString:@"(1_action must be taken immediately)"];
            break;
        case 2:
            level_string = @"LOG_CRIT";
            level_string = [level_string stringByAppendingString:@"(2_critical conditions)"];
            break;
        case 3:
            level_string = @"LOG_ERR";
            level_string = [level_string stringByAppendingString:@"(3_error conditions)"];
            break;
        case 4:
            level_string = @"LOG_WARNING";
            level_string = [level_string stringByAppendingString:@"(4_warning conditions)"];
            break;
        case 5:
            level_string = @"LOG_NOTICE";
            level_string = [level_string stringByAppendingString:@"(5_normal but significant condition)"];
            break;
        case 6:
            level_string = @"LOG_INFO";
            level_string = [level_string stringByAppendingString:@"(6_informational)"];
            break;
        case 7:
            level_string = @"LOG_DEBUG";
            level_string = [level_string stringByAppendingString:@"(7_debug-level messages)"];
            break;
        default:
            break;
    }
    
    return level_string;
}

- (NSString *)getDesc_string;
{
//    NSMutableString *tempStr = [NSMutableString string];
//    
//    [self.tempDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
//        if ([key isEqualToString:@"Level"]) {
//            value = self.Level;
//        }
//        NSString *str = [NSString stringWithFormat:@"%@ %@",key,value];
//        [tempStr appendString:str];
//        if (!(*stop)) {
//            [tempStr appendString:@"\n"];
//        }
//    }];

    
    return self.tempDic.description;
}


@end
