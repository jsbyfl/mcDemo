
#import <Foundation/Foundation.h>

@interface TaskHelper : NSObject

+ (instancetype) sharedInstance;

- (NSTask  *)excuteTaskPath:(NSString *)path argvs:(NSArray *)argvs result:(NSString **)res error:(NSError * __autoreleasing *)error;

- (void)excuteTaskPath:(NSString *)path argvs:(NSArray *)argvs isRunning:(void(^)(NSTask *))runningBlock complete:(void(^)(NSString *,NSError *))completeBlock;

- (void)startCMDApp:(NSString *)path argvs:(NSArray *)argvs;

- (BOOL)processRunning:(NSString *)appName;

@end
