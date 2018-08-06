//
//  ViewController.h
//  Mac01
//
//  Created by lpc on 2018/7/4.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSButton *button;
@property (unsafe_unretained) IBOutlet NSTextView *txtView;
@property (unsafe_unretained) IBOutlet NSTextView *cmdTxtView;

@end

