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
-(int)getDSPParameterWithEffectParameter:(EffectParameter)ep;
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

-(int)getDSPParameterWithEffectParameter:(EffectParameter)ep
{
    switch (ep)
    {
        case EffectParameter::Reverb_DryLevel:
            return FMOD_DSP_SFXREVERB_DRYLEVEL;
        case EffectParameter::Reverb_Room:
            return FMOD_DSP_SFXREVERB_ROOM;
        case EffectParameter::Reverb_RoomHF:
            return FMOD_DSP_SFXREVERB_ROOMHF;
        case EffectParameter::Reverb_DecayTime:
            return FMOD_DSP_SFXREVERB_DECAYTIME;
        case EffectParameter::Reverb_DecayHFRatio:
            return FMOD_DSP_SFXREVERB_DECAYHFRATIO;
        case EffectParameter::Reverb_ReflectionsLevel:
            return FMOD_DSP_SFXREVERB_REFLECTIONSLEVEL;
        case EffectParameter::Reverb_ReflectionsDelay:
            return FMOD_DSP_SFXREVERB_REFLECTIONSDELAY;
        case EffectParameter::Reverb_ReverbLevel:
            return FMOD_DSP_SFXREVERB_REVERBLEVEL;
        case EffectParameter::Reverb_ReverbDelay:
            return FMOD_DSP_SFXREVERB_REVERBDELAY;
        case EffectParameter::Reverb_Diffusion:
            return FMOD_DSP_SFXREVERB_DIFFUSION;
        case EffectParameter::Reverb_Density:
            return FMOD_DSP_SFXREVERB_DENSITY;
        case EffectParameter::Reverb_HFReference:
            return FMOD_DSP_SFXREVERB_HFREFERENCE;
        case EffectParameter::Reverb_RoomLF:
            return FMOD_DSP_SFXREVERB_ROOMLF;
        case EffectParameter::Reverb_LFReference:
            return FMOD_DSP_SFXREVERB_LFREFERENCE;
            
        case EffectParameter::Echo_Delay:
            return FMOD_DSP_ECHO_DELAY;
        case EffectParameter::Echo_DecayRatio:
            return FMOD_DSP_ECHO_DECAYRATIO;
        case EffectParameter::Echo_MaxChannels:
            return FMOD_DSP_ECHO_MAXCHANNELS;
        case EffectParameter::Echo_DryMix:
            return FMOD_DSP_ECHO_DRYMIX;
        case EffectParameter::Echo_WetMix:
            return FMOD_DSP_ECHO_WETMIX;
        
        case EffectParameter::Flange_DryMix:
            return FMOD_DSP_FLANGE_DRYMIX;
        case EffectParameter::Flange_WetMix:
            return FMOD_DSP_FLANGE_WETMIX;
        case EffectParameter::Flange_Depth:
            return FMOD_DSP_FLANGE_DEPTH;
        case EffectParameter::Flange_Rate:
            return FMOD_DSP_FLANGE_RATE;
            
        case EffectParameter::Distortion_Level:
            return FMOD_DSP_DISTORTION_LEVEL;
            
        case EffectParameter::Pitch_Value:
            return FMOD_DSP_PITCHSHIFT_PITCH;
        case EffectParameter::Pitch_FFTSize:
            return FMOD_DSP_PITCHSHIFT_FFTSIZE;
        case EffectParameter::Pitch_Overlap:
            return FMOD_DSP_PITCHSHIFT_OVERLAP;
        case EffectParameter::Pitch_MaxChannels:
            return FMOD_DSP_PITCHSHIFT_MAXCHANNELS;
            
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
    FMOD::DSP * effect = [self getDSPWithEffectType:et];
    if (effect)
        effect->setParameter([self getDSPParameterWithEffectParameter:ep], value);
}

@end
