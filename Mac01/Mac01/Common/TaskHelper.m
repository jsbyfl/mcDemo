
#import "TaskHelper.h"
#import "MacroUtil.h"
@implementation TaskHelper

SHAREDINSTANCE(TaskHelper);

//+ (instancetype) sharedInstance
//{
//    static id sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


- (NSTask  *)excuteTaskPath:(NSString *)path argvs:(NSArray *)argvs result:(NSString **)res error:(NSError * __autoreleasing *)error
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return nil;
    }
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = argvs;
    
    NSPipe *outputPipe = [[NSPipe alloc] init];
    NSPipe *errorPipe = [[NSPipe alloc] init];
    [task setStandardOutput:outputPipe];
    [task setStandardError:errorPipe];
    [task waitUntilExit];
    [task launch];
    
    NSFileHandle *outputHandle = [outputPipe fileHandleForReading];
    NSFileHandle *errorHandle = [errorPipe fileHandleForReading];
    NSData *outData = [outputHandle readDataToEndOfFile];
    NSData *errorData = [errorHandle readDataToEndOfFile];
    
    if (outData && outData.length > 0 && (!errorData || errorData.length == 0) ) {
        NSString *outString = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
        if (res != NULL) {
            *res = outString;
        }
    }
    else if(errorData && errorData.length > 0)
    {
        if (error) {
            NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            if (errorString) {
                NSError *err = [[NSError alloc] initWithDomain:@"" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:errorString}];
                (*error) = err;
            }
            else {
                NSError *err = [[NSError alloc] initWithDomain:@"" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"unknown error"}];
                (*error) = err;
            }
        }
    }
    [outputHandle closeFile];
    [errorHandle closeFile];
    return task;
}

- (void)excuteTaskPath:(NSString *)path argvs:(NSArray *)argvs isRunning:(void(^)(NSTask *))runningBlock complete:(void(^)(NSString *,NSError *))completeBlock
{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = argvs;
    
    NSPipe *outputPipe = [[NSPipe alloc] init];
    NSPipe *errorPipe = [[NSPipe alloc] init];
    [task setStandardError:errorPipe];
    [task setStandardOutput:outputPipe];
    [task waitUntilExit];
    [task launch];
    
    runningBlock(task);
    
    NSFileHandle *outputHandle = [outputPipe fileHandleForReading];
    NSFileHandle *errorHandle = [errorPipe fileHandleForReading];
    NSData *outData = [outputHandle readDataToEndOfFile];
    NSData *errorData = [errorHandle readDataToEndOfFile];
    
    NSString *res = nil;
    NSError *error = nil;
    
    if(outData && outData.length > 0)
    {
        NSString *outString = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
        res = outString;
    }
    
    if(errorData && errorData.length > 0)
    {
        NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        if (errorString) {
            NSError *err = [[NSError alloc] initWithDomain:@"" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:errorString}];
            error = err;
        }
        else {
            NSError *err = [[NSError alloc] initWithDomain:@"" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"unknown error"}];
            error = err;
        }
    }
    [outputHandle closeFile];
    [errorHandle closeFile];
    
    completeBlock(res,error);

}

- (void)startCMDApp:(NSString *)path argvs:(NSArray *)argvs
{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = argvs;
    [task waitUntilExit];
    [task launch];

}

- (BOOL)processRunning:(NSString *)appName
{
    NSString *path = @"/bin/ps";
    NSArray *argvs = @[@"aux",@"|grep"];
    
    NSString *res ;
    
    [self excuteTaskPath:path argvs:argvs result:&res error:nil];
    
    return YES;
}




@end
