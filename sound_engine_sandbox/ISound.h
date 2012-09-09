//
//  ISound.h
//  Resonance
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISoundEngine.h"

@protocol ISound <NSObject>

-(id)initWithSoundEngine:(id<ISoundEngine>)ise;

-(void)load:(NSString*)url;
-(void)unload;

-(void)play;
-(void)stop;

-(void)setPaused:(bool)state;
-(void)setVolume:(float)value;

-(void)addEffectOfType:(EffectType)et;
-(void)setEffectValueForType:(EffectType)et forParameter:(EffectParameter)ep withValue:(float)value;
-(void)removeEffectOfType:(EffectType)et;

@end