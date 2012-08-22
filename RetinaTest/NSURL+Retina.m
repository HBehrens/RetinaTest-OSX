//
//  NSURL+Retina.m
//  RetinaTest
//
//  Created by Heiko Behrens on 22.08.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "NSURL+Retina.h"

@implementation NSURL (Retina)

-(NSURL*)urlForRetinaFactor:(float)factor {
    if(!self.isFileURL)
        return self;
    
    NSString* fileName = [self lastPathComponent];
    NSArray* parts = [fileName componentsSeparatedByString:@"."];
    NSString *formatSuffix = [parts lastObject];
    NSString* baseName = [[parts subarrayWithRange:NSMakeRange(0, parts.count-1)] componentsJoinedByString:@"."];
    
    // if filename already contains @2x-suffix remove this again so the lowres version can be picked if available
    if([baseName hasSuffix:@"@2x"])
        baseName = [baseName substringToIndex:baseName.length-3];
    
    NSString* scaleSuffix = factor == 2 ? @"@2x" : @"";
    
    // NOTE: query parameter might carry cache buster, hence the NSURL#path
    NSURL* potentialResult = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@/%@%@.%@", self.URLByDeletingLastPathComponent.path, baseName, scaleSuffix, formatSuffix]];
    if([potentialResult checkResourceIsReachableAndReturnError:nil])
        return potentialResult;
    
    return self;
}

-(NSURL*)urlForRetinaFactorOfView:(NSView*)view {
    float factor = 1;
    if([view.window respondsToSelector:@selector(backingScaleFactor)])
        factor = [view.window backingScaleFactor];
    
    return [self urlForRetinaFactor:factor];
}

@end
