//
//  FMODTone.m
//  sound_engine_sandbox
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import "FMODTone.h"
#import "FMODSoundEngine.h"

@interface FMODTone()
{
    FMODSoundEngine * soundEngine;
}
@end

@implementation FMODTone

-(id)init
{
    //enforce client use to initWithSoundEngine
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class FMODTone. Use -initWithSoundEngine"
                                 userInfo:nil];
    return nil;
}

#pragma mark
#pragma ITone methods

-(id)initWithSoundEngine:(id<ISoundEngine>)ise
{
    if (self = [super init])
    {
        soundEngine = ise;
    }
    return self;
}

-(void)load:(ToneType)tt
{
    
}

-(void)unload
{
    
}

-(void)play
{
    
}

-(void)stop
{
    
}

-(void)setPaused:(bool)state
{
    
}

-(void)setVolume:(float)value
{
    
}

-(void)setPropertyOfType:(ToneProperty)tp withValue:(float)value
{
    
}

@end
