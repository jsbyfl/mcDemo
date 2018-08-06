//
//  ViewController.m
//  Mac01
//
//  Created by lpc on 2018/7/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import "ViewController.h"
#import "SystemLogManager.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.label.stringValue = @"Mac01";
    self.label.backgroundColor = [NSColor greenColor];
    
    
    NSString *cmdString = @"ps ax | grep Mac01 | grep -v grep | awk '{print $1\" \"$5\" \"$6}'";
//    cmdString = @"defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1 && killall Finder"; //无效
//    cmdString = @"defaults write com.apple.NetworkBrowser DisableAirDrop -bool NO && killall Finder";
//    cmdString = @"ps ax | grep Mac01 | grep -v grep | awk '{print $1\"}'";
    self.cmdTxtView.string = cmdString;
    
    
    

    
    /*
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F raw | tail -5
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F std | tail -5<包含信息类型><Notice>
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F bsd | tail -5
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F xml -T sec | tail -5
     
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F xml -T sec -nodc | tail -5
     
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -B | tail -5

     
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F std > /Users/lpc/Desktop/log_std.txt
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F raw > /Users/lpc/Desktop/logp_raw.txt
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F bsd > /Users/lpc/Desktop/logp_bsd.txt
     syslog -f /private/var/log/DiagnosticMessages/2018.08.02.asl -F xml > /Users/lpc/Desktop/logp_xml.plist
     */
    
    //syslog –d /private/var/log/asl
}

- (IBAction)buttonClick:(id)sender {
    
//    [self testCMDFromCmdTextView];
//    [self appNewAction];
//    [self addTask];
//    [self testLaunch];
    
//    [self testInstall];
    
    
//    [[SystemLogManager sharedManager] getUserLoginlogs];
    
    [self getSysLogs];
}

- (void)getSysLogs
{
    [[SystemLogManager sharedManager] syslogCmdTest];
}


- (void)testCMDFromCmdTextView
{
    NSString *res;
    NSError *error;
    
    NSString *cmdString = self.cmdTxtView.string;
    [self excuteTaskPath:@"/bin/bash" argvs:@[@"-c",cmdString] result:&res error:&error];
    
    NSString *execPath = [[NSBundle mainBundle] executablePath];
    
    NSString *msg = [NSString stringWithFormat:@"cmd=\n%@\n\nres=\n%@\n\nerror=\n%@",cmdString,res,error];
    self.txtView.string = [NSString stringWithFormat:@"%@\n\nexecPath=\n%@",msg,execPath];
}

- (void)testCMD:(NSString *)cmdString
{
    NSString *res;
    NSError *error;
    
    self.cmdTxtView.string = cmdString;
    
    [self excuteTaskPath:@"/bin/bash" argvs:@[@"-c",cmdString] result:&res error:&error];
    
    NSString *execPath = [[NSBundle mainBundle] executablePath];
    
    NSString *msg = [NSString stringWithFormat:@"cmd=\n%@\n\nres=\n%@\n\nerror=\n%@",cmdString,res,error];
    self.txtView.string = [NSString stringWithFormat:@"%@\n\nexecPath=\n%@",msg,execPath];
}


- (void)testInstall
{
    /*
     1、Edit Scheme 设置root
     2、脚本先检验配置目录是否存在，不存在-->创建目录
     */
    
    NSString *res = nil;
    NSError *error = nil;
    
    NSString *appPath = @"/Users/lpc/Desktop/安装包sh测试/out/install01.pkg";
    
    /*
    //不能使用'~/Desktop'
    https://stackoverflow.com/questions/5081846/trying-to-run-nstask-but-getting-an-error
    appPath = @"~/Desktop/安装包sh测试/out/install01.pkg";
    */

    
    /*
    // 安装
     NSString *cmd = @"/usr/sbin/installer -pkg \"/Users/lpc/Desktop/安装包sh测试/out/install01.pkg\" -target /";
     NSArray *argvs = @[@"-pkg",appPath,@"-target",@"/"];
    [self excuteTaskPath:@"/usr/sbin/installer" argvs:argvs result:&res error:&error];
    */
    
    
    NSString *execPath = [[NSBundle mainBundle] executablePath];
    NSString *msg = [NSString stringWithFormat:@"appPath=\n%@\n\nres=\n%@\n\nerror=\n%@",appPath,res,error];
    self.txtView.string = [NSString stringWithFormat:@"%@\n\nexecPath=\n%@",msg,execPath];
}

NSString *RealHomeDirectory() {
    
    NSString *home = NSHomeDirectory();
    NSArray *pathArray = [home componentsSeparatedByString:@"/"];
    NSString *absolutePath;
    if ([pathArray count] > 2) {
        absolutePath = [NSString stringWithFormat:@"/%@/%@", [pathArray objectAtIndex:1], [pathArray objectAtIndex:2]];
    }
    return absolutePath;
}

- (void)appNewAction{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundleMsg = [NSString stringWithFormat:@"bundle=\n[%@]",bundle];
    NSLog(@"%@",bundleMsg);

    NSString *execPath = [bundle executablePath];
    NSString *execPathMsg = [NSString stringWithFormat:@"execPath=\n[%@]",execPath];
    NSLog(@"%@",execPathMsg);
    
    NSString *bundlePath = [bundle bundlePath];
    NSString *bundlePathMsg = [NSString stringWithFormat:@"bundlePath=\n[%@]",bundlePath];
    NSLog(@"%@",bundlePathMsg);
    
    NSString *resourcePath = [bundle resourcePath];
    NSString *resourcePathMsg = [NSString stringWithFormat:@"resourcePath=\n[%@]",resourcePath];
    NSLog(@"%@",resourcePathMsg);
    
    NSString *msg = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",bundleMsg,execPathMsg,bundlePathMsg,resourcePathMsg];
    self.txtView.string = msg;
    
    
//    NSTask *task = [[NSTask alloc]init];
//    [task setLaunchPath:execPath];
//    
//    NSArray *args = @[@"para0",@"para1",@"para2"];
//    task.arguments = args;
//    
//    [task launch];
}


- (void)addTask{
    /*
     task:https://blog.csdn.net/lovechris00/article/details/78145937
     */
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    NSString *commandStr = @"last | grep reboot";
    NSArray *arguments = [NSArray arrayWithObjects:@"-c",commandStr,nil];
    NSLog(@"arguments : %@",arguments);
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
    
    NSLog (@"got\n %@", string);
}

- (void)testLaunch
{
    NSTask *task = [[NSTask alloc] init];
    
    NSString *path = @"/Applications/Calculator.app/Contents/MacOS/Calculator";
//    path = @"/Applications/Safari.app/Contents/MacOS/Safari";
    
    task.launchPath = path;
    
    [task launch];
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

@end
