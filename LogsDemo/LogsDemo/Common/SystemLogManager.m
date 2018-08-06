
#import "SystemLogManager.h"
#include <utmpx.h>
#include <string.h>

#include <syslog.h>

#import "TaskHelper.h"
#import "FileManager.h"

@implementation SystemLogManager

+ (instancetype)sharedManager
{
    static SystemLogManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc] init];
    });
    return _manager;
}

- (NSArray<LoginLogModel *> *)getUserLoginlogs
{
    /*
     https://stackoverflow.com/questions/14341230/objective-c-users-login-and-logout-time
     https://blog.csdn.net/luoweifu/article/details/20288549
     https://gist.github.com/pudquick/7fa89716fe2a8f6cdc084958671b7b58
     
     https://apple.stackexchange.com/questions/120668/list-failed-login-attempts-on-mavericks
     
     https://en.wikipedia.org/wiki/Utmp#utmp.2C_wtmp_and_btmp
     
     日志文件基础知识
     https://www.ibm.com/developerworks/cn/aix/library/au-satlogfilebasics/index.html
     cat /private/var/log/system.log | grep "Failed to authenticate"
     cat /private/var/log/system.log | grep "Failed to"
     sudo grep 'Failed to authenticate' /private/var/log/system.log
     */
    
    
    NSMutableArray <LoginLogModel *>*list = [NSMutableArray array];
    
    setutxent_wtmp(0); // 0 = reverse chronological order
    
    struct utmpx *bp = NULL;
    while ((bp = getutxent_wtmp()) != NULL) {
        char *ut_line = bp->ut_line;
        if (strcmp(ut_line, "console") != 0){
            continue;
        }
        
        short type = bp->ut_type;
        long tv_sec = bp->ut_tv.tv_sec;
        //char *ct = ctime(&tv_sec);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
        dateFormatter.timeZone = zone;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tv_sec];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        
        switch (type) {
//            case EMPTY:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s EMPTY %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//            case RUN_LVL:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s RUN_LVL %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//            case BOOT_TIME:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s BOOT_TIME %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//            case OLD_TIME:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s OLD_TIME %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//                
//            case INIT_PROCESS:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s INIT_PROCESS %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//            case LOGIN_PROCESS:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s INIT_PROCESS %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
            case USER_PROCESS:{
                LoginLogModel *model = [[LoginLogModel alloc] init];
                model.type = type;
                model.type_desc = @"login";
                model.dateString = dateStr;
                model.user = [NSString stringWithFormat:@"%s",bp->ut_user];
                [list addObject:model];
                break;
            }
            case DEAD_PROCESS:{
                LoginLogModel *model = [[LoginLogModel alloc] init];
                model.type = type;
                model.type_desc = @"logout";
                model.dateString = dateStr;
                model.user = [NSString stringWithFormat:@"%s",bp->ut_user];
                [list addObject:model];
                break;
            }
                
//            case ACCOUNTING:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s ACCOUNTING %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//            case SIGNATURE:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s SIGNATURE %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//            case SHUTDOWN_TIME:{
//                NSString *msg = [NSString stringWithFormat:@"type:%d %s SHUTDOWN_TIME %@\n",type,bp->ut_user,dateStr];
//                printf("%s",[msg UTF8String]);
//                break;
//            }
//                
            default:{
                NSString *msg = [NSString stringWithFormat:@"%s other_user_type:%d %@\n",bp->ut_user,type,dateStr];
                printf("%s",[msg UTF8String]);
            }
                break;
        }
        
    };
    endutxent_wtmp();
    
    
    return [list copy];
}

- (void)systemLogs
{
    /*
     https://crucialsecurity.wordpress.com/2011/06/22/the-apple-system-log-%E2%80%93-part-1/
     http://wiki.jikexueyuan.com/project/unix/system-logging.html
     
     https://www.w3cschool.cn/unix/ew9l1pdl.html
     
     [ASLMessageID 82134] [Time 1531900894] [TimeNanoSec 159632000] [Level 5] [PID 45] [UID 0] [GID 0] [ReadGID 80] [Host PADDYLONG-MC0] [Sender kextd] [Facility daemon] [Message kextcache updated kernel boot caches] [com.apple.message.domain com.apple.kext.caches] [com.apple.message.signature updatedCaches] [com.apple.message.result success] [SenderMachUUID 32D783F4-0983-3815-8E07-4721080AD351]
     */
    
    NSString *path = @"/Users/lpc/Desktop/logp_xml.plist";
    
    NSError *error;
    NSString *result_string = [NSString stringWithContentsOfFile:path encoding:NSISOLatin1StringEncoding error:&error];
    //NSArray *list = [result_string componentsSeparatedByString:@"\n"]; //ASLMessageID 27748 27537 211
    
    //以"ASLMessageID"分割
    NSArray *list = [result_string componentsSeparatedByString:@"[ASLMessageID"];
    NSMutableArray *t_list = [list mutableCopy];
    if (t_list.count > 0) {
        [t_list removeObjectAtIndex:0];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NSString *item in t_list)
        {
            NSString *t_item = [@"ASLMessageID" stringByAppendingString:item];
            NSArray *item_list = [t_item componentsSeparatedByString:@"] ["];
            
            printf("\n=====\n");

            for (int i = 0; i < item_list.count; i++)
            {
                NSString *subItem = item_list[i];
                if (i == item_list.count - 1){
                    subItem = [subItem stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    subItem = [subItem stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                }
                const char *c_s = [subItem UTF8String];
                printf("%s\n",c_s);
            }
        }
    });
    
    NSLog(@"-=================%ld",t_list.count);
}

- (void)getSystemLogs:(void (^)(NSArray<ProcessLogModel *> *))block
{
    /*
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F raw -B
     cmd = @"syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F raw | tail -n 10";
     cmd = @"syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F raw | tail -n 10 >> /Users/lpc/Desktop/01log.txt";
     
     [ASLMessageID 82134] [Time 1531900894] [TimeNanoSec 159632000] [Level 5] [PID 45] [UID 0] [GID 0] [ReadGID 80] [Host PADDYLONG-MC0] [Sender kextd] [Facility daemon] [Message kextcache updated kernel boot caches] [com.apple.message.domain com.apple.kext.caches] [com.apple.message.signature updatedCaches] [com.apple.message.result success] [SenderMachUUID 32D783F4-0983-3815-8E07-4721080AD351]
     */
    
    NSMutableArray *datas = [NSMutableArray array];
    
    NSString *directory = [[FileManager sharedInstance] createAppRootDirectory];
    NSString *tempPath = [directory stringByAppendingPathComponent:@".syslog_temp_xml.plist"];
    [[FileManager sharedInstance] createFilePath:tempPath];
    
    NSString *srcPath = [SystemLogManager xmlLogPath];
    
    NSString *cmd = @"syslog -d /var/log/DiagnosticMessages -F raw > /Users/lpc/Desktop/01log.txt";
    cmd = [NSString stringWithFormat:@"syslog -f %@ -F xml -u -B > %@",srcPath,tempPath];
    cmd = [NSString stringWithFormat:@"syslog -f %@ -F xml -T local -B > %@",srcPath,tempPath];
    
    NSString *res;
    NSError *error;
    
    [[TaskHelper sharedInstance] excuteTaskPath:@"/bin/bash" argvs:@[@"-c",cmd] result:&res error:&error];
    
    sleep(1.5);
    
    
    NSArray *list = [NSArray arrayWithContentsOfFile:tempPath];
    // 删除临时文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]){
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory]){
        [[NSFileManager defaultManager] removeItemAtPath:directory error:nil];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NSDictionary *t_dic in list)
        {
            ProcessLogModel *model = [[ProcessLogModel alloc] initWithDic:t_dic];
            [datas addObject:model];
            
            [t_dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
                
                NSString *msg = [NSString stringWithFormat:@"%@--%@",key,obj];
                const char *c_s = [msg UTF8String];
                printf("%s\n",c_s);
            }];
        }
        
        if (block) {
            block(datas);
        }
    });
}


+ (NSString *)xmlLogPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";

    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [NSDate date];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    /*
     /private/var/log/DiagnosticMessages/2018.08.02.asl
     */
    NSString *path = [NSString stringWithFormat:@"/private/var/log/DiagnosticMessages/%@.asl",dateStr];
    
    return path;
}

@end


