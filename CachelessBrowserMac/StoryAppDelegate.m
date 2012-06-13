//
//  StoryAppDelegate.m
//  CachelessBrowserMac
//
//  Created by Daniel Tomlinson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoryAppDelegate.h"
#import "WebPreferencesPrivate.h"
#import "WebKit/WebPreferences.h"
@implementation StoryAppDelegate
@synthesize web = _web;
@synthesize connection = _connection;
@synthesize lines = _lines;
@synthesize data = _data;
@synthesize window = _window;
@synthesize URL = _URL;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
      [NSURLCache setSharedURLCache:sharedCache];
//    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    WebPreferences *preg = [[WebPreferences alloc]init];
    [preg setDeveloperExtrasEnabled:YES];
    [_web setPreferences:preg];
    [_web setFrameLoadDelegate:self];
    [self FetchHTMLCode:@"http://dantomlin.co.uk/distribution/cachelessver.txt"];
   // [self open:@"http://google.com"];
    
}
- (void)webViewDidStartLoad:(WebView *)webView
{
}
- (IBAction)open:(NSString *)url{
    NSURL *myurl = [NSURL URLWithString:url];
    if(!myurl.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", url];
        url = [NSURL URLWithString:modifiedURLString];
    }
    /*URL Requst Object
     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
     
     //Load the request in the UIWebView.
     [[_web mainFrame] loadRequest:requestObj];
     */
    NSURLRequest*request=[NSURLRequest requestWithURL:myurl];
    StoryAppDelegate *myTempDel = [[StoryAppDelegate alloc]init];
    NSWindow *newWindow = [[NSWindow alloc]init];
    newWindow = [self window];
    [myTempDel setWindow:newWindow];
    [myTempDel openURL:url];

    [newWindow makeKeyAndOrderFront:NSApp];
    NSLog(@"Request Window");
}
- (IBAction)openURL:(NSString *)url{
    NSURL *myurl = [NSURL URLWithString:url];
    if(!myurl.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", url];
        url = [NSURL URLWithString:modifiedURLString];
    }
    /*URL Requst Object
     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
     
     //Load the request in the UIWebView.
     [[_web mainFrame] loadRequest:requestObj];
     */
    NSURLRequest*request=[NSURLRequest requestWithURL:myurl];
  //  StoryAppDelegate *myTempDel = [[StoryAppDelegate alloc]init];
    
    [[_web mainFrame] loadRequest:request];
    NSLog(@"Request sent");
}
- (void)webView:(WebView *)webView didFinishLoadForFrame:(WebFrame *)frame
{
  NSLog(@"webViewDidFinishLoading");
    NSString *curl;
    curl =[webView mainFrameURL];
    _URL.stringValue = curl;
}
- (void)webView:(WebView *)webView didFailLoadWithError:(NSError *)error
{
   }
- (IBAction)go:(id)sender {
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:_URL.stringValue];
    if(!url.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", _URL.stringValue];
        url = [NSURL URLWithString:modifiedURLString];
    }
    /*URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [[_web mainFrame] loadRequest:requestObj];
   */
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [[_web mainFrame] loadRequest:request];
    NSLog(@"Request sent");

}

- (IBAction)refresh:(id)sender {
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:[_web mainFrameURL]];
    NSLog(@"Refreshing");
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [[_web mainFrame] loadRequest:requestObj];
    

}

-(void)FetchHTMLCode:(NSString *)url{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"req sent");
	
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (_data==nil) _data = [[NSMutableData alloc] initWithCapacity:2048];
    [_data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
         NSString *result= [[NSString alloc] initWithData:_data encoding:NSASCIIStringEncoding];
    NSLog([NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]);
    if ([result intValue] > [[NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]intValue]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"An awesome update has been released!\nWould you like to download it now?"];
        [alert setAlertStyle:NSWarningAlertStyle];
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            NSURL* Appurl = [NSURL URLWithString:@"http://dantomlin.co.uk/distribution/cacheless.zip"];
            NSData* Appdata = [NSData dataWithContentsOfURL:Appurl];
            
            // get the documents directory
            NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, 
                                                                     NSUserDomainMask, YES);
            NSString* documentsDir = [pathArray objectAtIndex:0];
            NSString* localFile = [documentsDir stringByAppendingPathComponent:@"cacheless.zip"];
            
            // write the downloaded file to documents dir
            [Appdata writeToFile:localFile atomically:YES];
        }
    }
}
@end
