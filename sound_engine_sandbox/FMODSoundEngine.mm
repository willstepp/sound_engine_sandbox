//
//  FMODSoundEngine.m
//  sound_engine_sandbox
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import "FMODSoundEngine.h"
#import "FMODSound.h"
#import "FMODTone.h"

@interface FMODSoundEngine()
{
    NSMutableDictionary * sounds;
    NSMutableDictionary * tones;
}
@end

@implementation FMODSoundEngine
@synthesize system;

static FMODSoundEngine * player = nil;
static FMODSoundEngine * recorder = nil;

-(id)init
{
    //enforce client to initWithEngineType
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                        reason:@"-init is not a valid initializer for the class FMODSoundEngine. Use -initWithEngineType"
                        userInfo:nil];
    return nil;
}

#pragma mark
#pragma ISoundEngine methods

+(id<ISoundEngine>) getSingletonOfType:(EngineType)et
{
    switch (et)
    {
        case EngineType::Player:
            {
                if (player == nil)
                    player = [[FMODSoundEngine alloc] initWithEngineType:et];
                return player;
            }
            break;
        case EngineType::Recorder:
            {
                if (recorder == nil)
                    recorder = [[FMODSoundEngine alloc] initWithEngineType:et];
                return recorder;
            }
            break;
        default:
            break;
    }
}

-(id)initWithEngineType:(EngineType)et
{
    if (self = [super init])
    {
        switch (et)
        {
            case EngineType::Player:
                {   
                    FMOD_RESULT result = FMOD_OK;
                    result = FMOD::System_Create(&system);
                    result = system->init(32,
                                          FMOD_INIT_NORMAL | FMOD_INIT_ENABLE_PROFILE,
                                          NULL);
                }
                break;
            case EngineType::Recorder:
                {
                
                }
                break;
            default:
                break;
        }
        sounds = [[NSMutableDictionary alloc] init];
        tones = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)shutdown
{    
    if (sounds) sounds = nil;
    if (tones) tones = nil;
    
    if (system)
    {
        system->release();
        system = NULL;
    }
}

- (id<ISound>) getSoundForId:(int)identifier
{
    FMODSound * s = [sounds objectForKey:[NSNumber numberWithInt:identifier]];
    if (s == NULL)
    {
        s = [[FMODSound alloc] initWithSoundEngine:self];
        [sounds setObject:s forKey:[NSNumber numberWithInt:identifier]];
    }
    return s;
}

- (id<ITone>) getToneForId:(int)identifier
{
    FMODTone * t = [tones objectForKey:[NSNumber numberWithInt:identifier]];
    if (t == NULL)
    {
        t = [[FMODTone alloc] initWithSoundEngine:self];
        [tones setObject:t forKey:[NSNumber numberWithInt:identifier]];
    }
    return t;
}

@end
