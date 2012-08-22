//
//  AppDelegate.h
//  RetinaTest
//
//  Created by Heiko Behrens on 14.08.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
- (IBAction)reloadContent:(id)sender;
@property (weak) IBOutlet WebView *webViewTIFF;
@property (weak) IBOutlet WebView *webViewLogic;


@end
