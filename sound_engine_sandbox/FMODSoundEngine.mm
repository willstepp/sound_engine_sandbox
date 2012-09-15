//
//  FMODSoundEngine.m
//  Resonance
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
    
    EngineType type;
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
                        reason:@"-init is not a valid initializer for the class FMODSoundEngine. Use -instance"
                        userInfo:nil];
    return nil;
}

#pragma mark
#pragma ISoundEngine methods

+(id<ISoundEngine>) instance:(EngineType)et
{
    if (et == EngineType::Player)
    {
        if (player == nil)
            player = [[FMODSoundEngine alloc] initWithEngineType:et];
        return player;
    }
    if (et == EngineType::Recorder)
    {
        if (recorder == nil)
            recorder = [[FMODSoundEngine alloc] initWithEngineType:et];
        return recorder;
    }
    return nil;
}

-(id)initWithEngineType:(EngineType)et
{
    type = et;
    
    if (self = [super init])
    {
        if (et == EngineType::Player)
        {
            FMOD_RESULT result = FMOD_OK;
            result = FMOD::System_Create(&system);
            result = system->init(32,
                                  FMOD_INIT_NORMAL | FMOD_INIT_ENABLE_PROFILE,
                                  NULL);
        }
        if (et == EngineType::Recorder)
        {
            
        }
        sounds = [[NSMutableDictionary alloc] init];
        tones = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)deinstance
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

-(void)startRecording:(NSString*)fileName
{
    if (type == EngineType::Recorder)
    {
        [self deinstance];
        FMOD_RESULT result = FMOD_OK;
        result = FMOD::System_Create(&system);
        result = system->setOutput(FMOD_OUTPUTTYPE_WAVWRITER);
        
        char fn[200] = {0};
        [fileName getCString:fn maxLength:200 encoding:NSASCIIStringEncoding];
        system->init(32, FMOD_INIT_NORMAL | FMOD_INIT_ENABLE_PROFILE, fn);
        //iterate through all sounds and tones of player instance, grabbing the necessary sound data and instantiating the equivalent sound tone
    }
}

-(void)stopRecording
{
    if (type == EngineType::Recorder)
    {
        [self deinstance];
    }
}

@end
