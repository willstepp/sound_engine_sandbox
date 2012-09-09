//
//  FMODSoundEngine.h
//  sound_engine_sandbox
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISoundEngine.h"

#import "fmod.hpp"
#import "fmod_errors.h"

@interface FMODSoundEngine : NSObject <ISoundEngine>

@property (readonly) FMOD::System * system;

-(id)initWithEngineType:(EngineType)et;

+(id<ISoundEngine>)getSingletonOfType:(EngineType)et;
-(void)shutdown;

-(id<ISound>)getSoundForId:(int)identifier;
-(id<ITone>)getToneForId:(int)identifier;

@end
