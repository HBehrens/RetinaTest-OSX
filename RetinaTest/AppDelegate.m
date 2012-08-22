//
//  AppDelegate.m
//  RetinaTest
//
//  Created by Heiko Behrens on 14.08.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "AppDelegate.h"

@interface WebPreferences (WebPreferencesPrivate)
- (void) setDeveloperExtrasEnabled:(BOOL)developerExtrasEnabled;
@end

@implementation AppDelegate
@synthesize webViewPNG = _webViewPNG;
@synthesize webViewTIFF = _webViewTIFF;
@synthesize webViewLogic = _webViewLogic;

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self reloadContent:nil];
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (IBAction)reloadContent:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"samplePNG" withExtension:@"html"];
    [_webViewPNG.mainFrame loadRequest:[NSURLRequest requestWithURL:url]];
    
    url = [[NSBundle mainBundle] URLForResource:@"sampleTIFF" withExtension:@"html"];
    [_webViewTIFF.mainFrame loadRequest:[NSURLRequest requestWithURL:url]];
    
    url = [[NSBundle mainBundle] URLForResource:@"sampleJS" withExtension:@"html"];
    [_webViewLogic.mainFrame loadRequest:[NSURLRequest requestWithURL:url]];
    

    // show inspector for logic webview 
//    WebPreferences *webPrefs = [WebPreferences standardPreferences];
//    [webPrefs setDeveloperExtrasEnabled:YES];
//    _webViewLogic.preferences = webPrefs;
//    id inspector = [[NSClassFromString(@"WebInspectorWindowController") alloc] performSelector:@selector(initWithInspectedWebView:) withObject:_webViewLogic];
//    [inspector performSelector:@selector(showWebInspector:) withObject:nil afterDelay:1.3];
}

#pragma mark - WebResourceLoadDelegate

float scaleFactor(NSView* view) {
    if([view.window respondsToSelector:@selector(backingScaleFactor)])
        return [view.window backingScaleFactor];
    return 1;
}

// adapted from http://stackoverflow.com/a/11068611/196350
// TODO: tidy up
- (NSURL*)urlNamed:(NSString*)name relativeToURL:(NSURL*)rootURL webView:(WebView*)webview
{
    // Make sure the URL is a file URL
    if(![rootURL isFileURL])
    {
        NSString* reason = [NSString stringWithFormat:@"%@ only supports file URLs at this time.", NSStringFromSelector(_cmd)];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    // ommit query
    rootURL = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@", rootURL.path]];
    
    NSArray* parts = [name componentsSeparatedByString:@"."];
    NSString *formatSuffix = [parts lastObject];
    name = [[parts subarrayWithRange:NSMakeRange(0, parts.count-1)] componentsJoinedByString:@"."];
    
    // Various suffixes to try in preference order
    NSString*   scaleSuffix[] =
    {
        @"@2x",
        @""
    };
    NSURL*      imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.%@", rootURL, name, formatSuffix]];
    
    // Iterate through scale suffixes...
    NSInteger   ss, ssStart, ssEnd, ssInc;
    if(scaleFactor(webview) == 2.0f)
    {
        // ...forwards
        ssStart = 0;
        ssInc = 1;
    }
    else
    {
        // ...backwards
        ssStart = (sizeof(scaleSuffix) / sizeof(NSString*)) - 1;
        ssInc = -1;
    }
    ssEnd = ssStart + (ssInc * (sizeof(scaleSuffix) / sizeof(NSString*)));
    for(ss = ssStart; (ss != ssEnd); ss += ssInc)
    {
        // Add all of the suffixes to the URL and test if it exists
        NSString*   nameXX = [name stringByAppendingFormat:@"%@.%@", scaleSuffix[ss], formatSuffix];
        NSURL*      testURL = [rootURL URLByAppendingPathComponent:nameXX];
//        NSLog(@"testing if image exists: %@", testURL);
        if([testURL checkResourceIsReachableAndReturnError:nil])
        {
            imageURL = testURL;
            break;
        }
    }
    
    return imageURL;
}

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource {
    if(request.URL.isFileURL) {
        NSLog(@"request: %@", request);
        NSString *filename = request.URL.lastPathComponent;
        NSURL *rootURL = [request.URL URLByDeletingLastPathComponent];
        NSURL *newURL = [self urlNamed:filename relativeToURL:rootURL webView:sender];
        NSLog(@"newURL: %@", newURL);
        return [NSURLRequest requestWithURL:newURL];
    }
    
    return request;
}

@end
