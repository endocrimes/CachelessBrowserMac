//
//  StoryAppDelegate.h
//  CachelessBrowserMac
//
//  Created by Daniel Tomlinson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

NSURLConnection *connection;
NSMutableData* data;
NSMutableArray *lines;
@interface StoryAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableArray *lines;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *URL;
- (IBAction)go:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)openURL:(NSString *)url;
- (IBAction)open:(NSString *)url;
@property (weak) IBOutlet WebView *web;

@end
