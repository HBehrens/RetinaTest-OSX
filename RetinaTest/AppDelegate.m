//
//  AppDelegate.m
//  RetinaTest
//
//  Created by Heiko Behrens on 14.08.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "AppDelegate.h"
#import "NSURL+Retina.h"

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

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource {
    if(request.URL.isFileURL) {
        return [NSURLRequest requestWithURL:[request.URL urlForRetinaFactorOfView:sender]];
    }
    return request;
}

@end
