//
//  AppDelegate.h
//  SplitePhoto
//
//  Created by Kasajima Yasuo on 2013/06/23.
//  Copyright (c) 2013年 @kasajei. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSURL *_url;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *calTextField;
@property (weak) IBOutlet NSTextField *rowTextFiled;
- (IBAction)pressSelectImage:(id)sender;
- (IBAction)pressSaveImage:(id)sender;
- (IBAction)changeCalTextFiled:(id)sender;

@end
