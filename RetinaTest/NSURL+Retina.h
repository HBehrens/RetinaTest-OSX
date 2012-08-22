//
//  NSURL+Retina.h
//  RetinaTest
//
//  Created by Heiko Behrens on 22.08.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Retina)

-(NSURL*)urlForRetinaFactor:(float)factor;
-(NSURL*)urlForRetinaFactorOfView:(NSView*)view;

@end
