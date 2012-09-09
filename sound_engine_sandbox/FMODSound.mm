//
//  FMODSound.m
//  Resonance
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import "FMODSound.h"
#import "FMODSoundEngine.h"

@interface FMODSound()
{
    FMOD::Sound * sound;
    FMOD::Channel * channel;
    
    FMOD::DSP * reverb;
    FMOD::DSP * pitch;
    FMOD::DSP * distortion;
    FMOD::DSP * echo;
    FMOD::DSP * flange;
    
    FMODSoundEngine * soundEngine;
}
-(void)ensureSoundReleased;
-(FMOD::DSP*)getDSPWithEffectType:(EffectType)et;
-(FMOD_DSP_TYPE)getDSPTypeWithEffectType:(EffectType)et;
@end

@implementation FMODSound

-(id)init
{
    //enforce client to use initWithSoundEngine
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                        reason:@"-init is not a valid initializer for the class FMODSound. Use -initWithSoundEngine"
                        userInfo:nil];
    return nil;
}

-(void)dealloc
{
    [self ensureSoundReleased];
    soundEngine = nil;
}

-(void)ensureSoundReleased
{
    if (sound)
    {
        channel->stop();
        sound->release();
        sound = NULL;
    }
}

-(FMOD::DSP*)getDSPWithEffectType:(EffectType)et
{
    switch (et)
    {
        case EffectType::Reverb:
            return reverb;
        case EffectType::Pitch:
            return pitch;
        case EffectType::Distortion:
            return distortion;
        case EffectType::Echo:
            return echo;
        case EffectType::Flange:
            return flange;
        default:
            return NULL;
    }
}

-(FMOD_DSP_TYPE)getDSPTypeWithEffectType:(EffectType)et
{
    switch(et)
    {
        case EffectType::Reverb:
            return FMOD_DSP_TYPE_SFXREVERB;
        case EffectType::Pitch:
            return FMOD_DSP_TYPE_PITCHSHIFT;
        case EffectType::Echo:
            return FMOD_DSP_TYPE_ECHO;
        case EffectType::Distortion:
            return FMOD_DSP_TYPE_DISTORTION;
        case EffectType::Flange:
            return FMOD_DSP_TYPE_FLANGE;
        default:
            return FMOD_DSP_TYPE_UNKNOWN;
    }
}

#pragma mark
#pragma ISound methods

-(id)initWithSoundEngine:(id<ISoundEngine>)ise
{
    if (self = [super init])
    {
        soundEngine = ise;
        reverb = pitch = distortion = echo = flange = 0;
    }
    return self;
}

-(void)load:(NSString*)url
{
    [self ensureSoundReleased];
    
    FMOD_RESULT result = FMOD_OK;
    char buffer[200] = {0};
    
    //create stream
    [url getCString:buffer maxLength:200 encoding:NSASCIIStringEncoding];
    result = soundEngine.system->createStream(buffer, FMOD_SOFTWARE | FMOD_LOOP_NORMAL, NULL, &sound);
}

-(void)unload
{
    [self ensureSoundReleased];
}

-(void)play
{
    soundEngine.system->playSound(FMOD_CHANNEL_FREE, sound, false, &channel);
}

-(void)stop
{
    channel->stop();
}

-(void)setPaused:(bool)state
{
    channel->setPaused(state);
}

-(void)setVolume:(float)value
{
    float normalized_volume = value / 100.0f;
    channel->setVolume(normalized_volume);
}

-(void)addEffectOfType:(EffectType)et;
{
    FMOD::DSP * effect = [self getDSPWithEffectType:et];
    if (effect) effect->remove();
    
    soundEngine.system->createDSPByType([self getDSPTypeWithEffectType:et], &effect);
    channel->addDSP(effect, 0);
}

-(void)removeEffectOfType:(EffectType)et
{
    FMOD::DSP * effect = [self getDSPWithEffectType:et];
    if (effect) effect->remove();
}

-(void)setEffectValueForType:(EffectType)et forParameter:(EffectParameter)ep withValue:(float)value
{
}

@end
