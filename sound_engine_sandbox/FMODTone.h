//
//  FMODTone.h
//  Resonance
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITone.h"

@interface FMODTone : NSObject <ITone>

-(id)initWithSoundEngine:(id<ISoundEngine>)ise;

-(void)load:(ToneType)tt;
-(void)unload;

-(void)play;
-(void)stop;

-(void)setPaused:(bool)state;
-(void)setVolume:(float)value;
-(void)setPropertyOfType:(ToneProperty)tp withValue:(float)value;

@end
