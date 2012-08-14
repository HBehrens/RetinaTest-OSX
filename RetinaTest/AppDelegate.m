//
//  AppDelegate.m
//  RetinaTest
//
//  Created by Heiko Behrens on 14.08.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize webViewPNG = _webViewPNG;
@synthesize webViewTIFF = _webViewTIFF;

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
    
    
}

@end
