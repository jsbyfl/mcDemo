//
//  ProcessLogModel.h
//  LogsDemo
//
//  Created by lpc on 2018/8/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessLogModel : NSObject

@property (nonatomic,copy) NSDictionary *tempDic;

@property (nonatomic,copy) NSString *ASLMessageID;
@property (nonatomic,copy) NSString *Time;
@property (nonatomic,copy) NSString *TimeNanoSec;
@property (nonatomic,copy) NSString *Level;

@property (nonatomic,copy) NSString *PID;
@property (nonatomic,copy) NSString *UID;
@property (nonatomic,copy) NSString *GID;
@property (nonatomic,copy) NSString *ReadGID;

@property (nonatomic,copy) NSString *Host;
@property (nonatomic,copy) NSString *Sender;
@property (nonatomic,copy) NSString *SenderMachUUID;

- (id)initWithDic:(NSDictionary *)dic;

- (NSString *)getDesc_string;

@end
