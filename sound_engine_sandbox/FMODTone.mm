//
//  FMODTone.m
//  Resonance
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import "FMODTone.h"
#import "FMODSoundEngine.h"

@interface FMODTone()
{
    FMODSoundEngine * soundEngine;
    
    FMOD::DSP * primaryTone;
    FMOD::DSP * secondaryTone;
    
    FMOD::Channel * primaryChannel;
    FMOD::Channel * secondaryChannel;
    
    ToneType currentToneType;
    float currentFrequency;
    int currentBinauralGap;
    
    bool loaded;
    bool playing;
}
- (void)ensureReleased;
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

-(void)dealloc
{
    [self ensureReleased];
    soundEngine = nil;
}

-(void)ensureReleased
{
    if (primaryChannel) { primaryChannel->stop(); }
    if (secondaryChannel) { secondaryChannel->stop(); }
    if (primaryTone) { primaryTone->release(); primaryTone = NULL; }
    if (secondaryTone) { secondaryTone->release(); secondaryTone = NULL; }
    if (primaryChannel) primaryChannel = NULL;
    if (secondaryChannel) secondaryChannel = NULL;
    loaded = false;
    playing = false;
}

#pragma mark
#pragma ITone methods

-(id)initWithSoundEngine:(id<ISoundEngine>)ise
{
    if (self = [super init])
    {
        soundEngine = ise;
        primaryChannel = secondaryChannel = NULL;
        primaryTone = secondaryTone  = NULL;
        loaded = false; playing = false;
    }
    return self;
}

-(void)load:(ToneType)tt
{
    [self ensureReleased];
    
    if (tt == ToneType::Binaural)
    {
        soundEngine.system->createDSPByType(FMOD_DSP_TYPE_OSCILLATOR, &primaryTone);
        soundEngine.system->createDSPByType(FMOD_DSP_TYPE_OSCILLATOR, &secondaryTone);
    }
    if (tt == ToneType::WhiteNoise)
    {
        soundEngine.system->createDSPByType(FMOD_DSP_TYPE_OSCILLATOR, &primaryTone);
    }
    currentToneType = tt;
    loaded = true;
}

-(void)unload
{
    [self ensureReleased];
}

-(bool)loaded
{
    return loaded;
}

-(ToneType)toneType
{
    return currentToneType;
}

-(void)play
{
    if (currentToneType == ToneType::Binaural)
    {
        primaryTone->setParameter(FMOD_DSP_OSCILLATOR_RATE, currentFrequency);
        soundEngine.system->playDSP(FMOD_CHANNEL_FREE, primaryTone, true, &primaryChannel);
        primaryTone->setParameter(FMOD_DSP_OSCILLATOR_TYPE, 0);
        primaryChannel->setPan(-1.0);
    
        int frequency = 0;
        soundEngine.system->getSoftwareFormat(&frequency, NULL, NULL, NULL, NULL, NULL);
        primaryChannel->setFrequency(frequency);
    
        secondaryTone->setParameter(FMOD_DSP_OSCILLATOR_RATE, currentFrequency + currentBinauralGap);
        soundEngine.system->playDSP(FMOD_CHANNEL_FREE, secondaryTone, true, &secondaryChannel);
        secondaryTone->setParameter(FMOD_DSP_OSCILLATOR_TYPE, 0);
        secondaryChannel->setPan(1.0);
        secondaryChannel->setFrequency(frequency);
        
        primaryChannel->setPaused(false);
        secondaryChannel->setPaused(false);
    }
    if (currentToneType == ToneType::WhiteNoise)
    {
        primaryTone->setParameter(FMOD_DSP_OSCILLATOR_RATE, 100.0);
        soundEngine.system->playDSP(FMOD_CHANNEL_FREE, primaryTone, true, &primaryChannel);
        primaryTone->setParameter(FMOD_DSP_OSCILLATOR_TYPE, 5);
        primaryChannel->setPan(0.0);
        int frequency = 0;
        soundEngine.system->getSoftwareFormat(&frequency, NULL, NULL, NULL, NULL, NULL);
        primaryChannel->setFrequency(frequency);
        
        primaryChannel->setPaused(false);
    }
    playing = true;
}

-(void)stop
{
    if (primaryChannel) primaryChannel->stop();
    if (secondaryChannel) secondaryChannel->stop();
    playing = false;
}

-(bool)playing
{
    return playing;
}

-(void)setPaused:(bool)state
{
    if (primaryChannel) primaryChannel->setPaused(state);
    if (secondaryChannel) secondaryChannel->setPaused(state);
}

-(bool)paused
{
    bool paused = false;
    if (primaryChannel) primaryChannel->getPaused(&paused);
    return paused;
}

-(void)setVolume:(float)value
{
    //float divisor = currentToneType == ToneType::Binaural ? 8.0f : 20.0f;
    //float quartered = value / divisor;
    
	if (primaryChannel) primaryChannel->setVolume(value);
	if (secondaryChannel) secondaryChannel->setVolume(value);
}

-(float)volume
{
    float volume = 0.0f;
    if (primaryChannel) primaryChannel->getVolume(&volume);
    return volume;
}

-(void)setPropertyOfType:(ToneProperty)tp withValue:(float)value
{
    if (tp == ToneProperty::BinauralGap)
    {
        currentBinauralGap = (int)value;
        if (secondaryTone) secondaryTone->setParameter(FMOD_DSP_OSCILLATOR_RATE, currentFrequency + currentBinauralGap);
    }
    if (tp == ToneProperty::Frequency)
    {
        currentFrequency = value;
        
        if (primaryTone) primaryTone->setParameter(FMOD_DSP_OSCILLATOR_RATE, currentFrequency);
        if (secondaryTone) secondaryTone->setParameter(FMOD_DSP_OSCILLATOR_RATE, currentFrequency + currentBinauralGap);
    }
}

-(float)getPropertyOfType:(ToneProperty)tp
{
    if (tp == ToneProperty::BinauralGap) return currentBinauralGap;
    if (tp == ToneProperty::Frequency) return currentFrequency;
    
    return 0.0f;
}

@end
