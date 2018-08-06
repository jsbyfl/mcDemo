//
//  ViewController.m
//  LogsDemo
//
//  Created by lpc on 2018/8/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import "ViewController.h"
#import "LoginLogsWindowController.h"
#import "ProcessLogsWindowController.h"

@implementation ViewController
{
    LoginLogsWindowController *loginWC;
    ProcessLogsWindowController *processWC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSButton *loginBtn = [[NSButton alloc] initWithFrame:NSMakeRect(50, 50, 150, 100)];
//    [loginBtn setTitle:@"Login/out logs"];
//    loginBtn.bezelStyle = NSBezelStyleRegularSquare;
//    loginBtn.target = self;
//    loginBtn.action = @selector(showLoginLogs);
//    [self.view addSubview:loginBtn];
//    
//    
//    NSButton *downloadBtn = [[NSButton alloc] initWithFrame:NSMakeRect(250, 50, 150, 100)];
//    [downloadBtn setTitle:@"test"];
//    downloadBtn.bezelStyle = NSBezelStyleRegularSquare;
//    downloadBtn.target = self;
//    downloadBtn.action = @selector(testAct);
//    [self.view addSubview:downloadBtn];
}


- (IBAction)showLoginLogs:(id)sender
{
    if (loginWC) {
        [loginWC.window orderOut:nil];
        loginWC = nil;
    }
    
    loginWC = [[LoginLogsWindowController alloc] initWithWindowNibName:NSStringFromClass([LoginLogsWindowController class])];
    [loginWC.window orderFront:nil];
}


- (IBAction)showProcessLogs:(id)sender
{
    if (processWC) {
        [processWC.window orderOut:nil];
        processWC = nil;
    }
    
    processWC = [[ProcessLogsWindowController alloc] initWithWindowNibName:NSStringFromClass([ProcessLogsWindowController class])];
    [processWC.window orderFront:nil];
}


@end
