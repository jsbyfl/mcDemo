//
//  LoginLogModel.h
//  LogsDemo
//
//  Created by lpc on 2018/8/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginLogModel : NSObject

@property (nonatomic,assign) short type;
@property (nonatomic,copy) NSString *type_desc;

@property (nonatomic,copy) NSString *user;
@property (nonatomic,copy) NSString *dateString;

@end
