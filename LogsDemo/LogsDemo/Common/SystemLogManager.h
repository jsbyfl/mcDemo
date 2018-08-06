
#import <Foundation/Foundation.h>
#import "LoginLogModel.h"
#import "ProcessLogModel.h"

@interface SystemLogManager : NSObject

+ (instancetype)sharedManager;

- (NSArray <LoginLogModel *>*)getUserLoginlogs;

//- (void)systemLogs;

- (void)getSystemLogs:(void(^)(NSArray <ProcessLogModel *>*))block;

@end
