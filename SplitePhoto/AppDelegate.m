//
//  AppDelegate.m
//  SplitePhoto
//
//  Created by Kasajima Yasuo on 2013/06/23.
//  Copyright (c) 2013年 @kasajei. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


- (IBAction)pressSelectImage:(id)sender {
    NSArray *fileTypes = [NSArray arrayWithObjects:@"png", nil]; 
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = fileTypes;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            if ([panel runModal] == NSFileHandlingPanelOKButton) {
                NSArray* urls = [panel URLs];
                NSURL *url = [urls objectAtIndex:0];
                _url = url;
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
                [self.imageView setImage:image];
            };
        }
    }];
}

- (IBAction)pressSaveImage:(id)sender {
    [self showSavePanel];
}

- (IBAction)changeCalTextFiled:(id)sender {
    NSLog(@"%d",self.calTextField.intValue);
}

- (void)saveImagesWithDirectory:(NSString *)directory baseFileName:(NSString *)baseFileName{
    int cal = self.calTextField.intValue; if ( cal <= 0 ) cal = 1;
    int row = self.rowTextFiled.intValue; if ( row <= 0 ) row = 1;
    NSLog(@"cal:%d,row:%d",cal,row);
    [self.calTextField setStringValue:[NSString stringWithFormat:@"%d",cal]];
    [self.rowTextFiled setStringValue:[NSString stringWithFormat:@"%d",row]];
    
    NSImage *image = self.imageView.image;
    CGSize imageSize = image.size;
    CGSize newSize = CGSizeMake(imageSize.width/cal, imageSize.height/row);
    for (int y = 0; y < row; y++) {
        for (int x = 0; x < cal; x++) {
            CGRect rect = CGRectMake(newSize.width * x, newSize.height * y, newSize.width, newSize.height);
            NSImage *newImage = [self croppedImage:image bounds:rect];
            NSString *fileName = baseFileName;
            if(cal>1 && row >1)
                fileName = [NSString stringWithFormat:@"%@_%d_%d",baseFileName,x,y];
            else if(row == 1)
                fileName = [NSString stringWithFormat:@"%@_%d",baseFileName,x];
            else if(cal == 1)
                fileName = [NSString stringWithFormat:@"%@_%d",baseFileName,y];
            [self saveImage:newImage directory:directory fileName:fileName];
        }
    }
    
    
}

- (void)showSavePanel{
    NSSavePanel *savePanel	= [NSSavePanel savePanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"png",nil];
    // NSSavePanel interface has changed since Mac OSX v10.6.
    [savePanel setAllowedFileTypes:allowedFileTypes];
    [savePanel setCanSelectHiddenExtension:YES];
    if (_url) {
        NSString *string = [_url relativeString];
        NSArray *names = [string componentsSeparatedByString:@"/"];
        [savePanel setNameFieldStringValue:names.lastObject];
        _url = nil;
    }
    NSInteger pressedButton = [savePanel runModal];
    if( pressedButton == NSOKButton ){
        // get file path (use NSURL)
        NSURL * filePath = [savePanel URL];
        NSLog(@"file saved '%@'", filePath);
        NSURL *directory = [savePanel directoryURL];
        NSLog(@"directory %@", directory);
        NSString *fileName = [savePanel nameFieldStringValue];
        NSLog(@"fineNAme %@", fileName);
        fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        NSLog(@"fineNAme %@", fileName);
        
        [self saveImagesWithDirectory:[directory relativePath] baseFileName:fileName];
    }else if( pressedButton == NSCancelButton ){
     	NSLog(@"Cancel button was pressed.");
    }else{
     	// error
    }
}

- (void)saveImage:(NSImage *)image directory:(NSString *)directory fileName:(NSString *)fileName{
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",directory,fileName];
    [imageData writeToFile:filePath atomically:NO];
    NSLog(@"save path %@", filePath);
    
}
- (NSImage *)croppedImage:(NSImage *)image bounds:(CGRect)bounds
{
    NSImage *oldImage = [image copy];
	[oldImage lockFocus];
    NSBitmapImageRep *imgRep = [[oldImage representations] objectAtIndex: 0];
    CGImageRef imageRef = [imgRep CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef, bounds);
    
	NSImage *croppedImage = [[NSImage alloc] initWithCGImage:newImageRef size:bounds.size];
    CGImageRelease(imageRef);
	[oldImage unlockFocus];
    return croppedImage;
}

@end
