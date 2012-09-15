//
//  RESOViewController.m
//  Resonance
//
//  Created by Daniel Stepp on 9/6/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "RESOViewController.h"
#import "FMODSoundEngine.h"
#import "ISound.h"
#import "ITone.h"

#define __PACKED __attribute__((packed))    /* gcc packed */

@interface RESOViewController ()
{
    id<ISoundEngine> player;
    id<ISound> sound;
    id<ITone> tone;
}
@end

@implementation RESOViewController
@synthesize loadButton;
@synthesize playButton;
@synthesize pauseButton;
@synthesize reverbButton;
@synthesize reverbSlider;
@synthesize volumeSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    player = nil;
    sound = nil;
    tone = nil;
    
    [reverbSlider setMinimumValue:-10000.0f];
    [reverbSlider setMaximumValue:0.0f];
    [reverbSlider setValue:0.0f];
    
    [volumeSlider setMinimumValue:0.0f];
    [volumeSlider setMaximumValue:100.0f];
    [volumeSlider setValue:50.0f];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    player = [FMODSoundEngine instance];
    //sound = [player getSoundForId:Module::One];
    tone = [player getToneForId:Module::One];
}

- (void)viewWillDisappear:(BOOL)animated
{
    sound = nil;
    tone = nil;
    player = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loadUnloadSound:(id)sender
{
    static bool loaded = false;
    if (!loaded)
    {
        //[sound load:[NSString stringWithFormat:@"%@/drumloop.wav", [[NSBundle mainBundle] resourcePath]]];
        [tone load:ToneType::WhiteNoise];
        [self.loadButton setTitle:@"Unload" forState:UIControlStateNormal];
        loaded = true;
    }
    else
    {
        //[sound unload];
        [tone unload];
        [self.loadButton setTitle:@"Load" forState:UIControlStateNormal];
        loaded = false;
    }
}

- (IBAction)playStopSound:(id)sender
{
    static bool playing = false;
    if (!playing)
    {
        //[sound play];
        //[sound setVolume:[volumeSlider value]];
        [tone setVolume:[volumeSlider value]];
        [tone play];
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
        playing = true;
    }
    else
    {
        //[sound stop];
        [tone stop];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        playing = false;
    }
}

- (IBAction)pauseUnpauseSound:(id)sender
{
    static bool paused = false;
    if (!paused)
    {
        //[sound setPaused:true];
        [tone setPaused:true];
        [self.pauseButton setTitle:@"Unpause" forState:UIControlStateNormal];
        paused = true;
    }
    else
    {
        //[sound setPaused:false];
        //[sound setVolume:[volumeSlider value]];
        [tone setVolume:[volumeSlider value]];
        [tone setPaused:false];
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        paused = false;
    }
}

- (IBAction)enableDisableReverb:(id)sender
{
    static bool reverbEnabled = false;
    if (!reverbEnabled)
    {
        [sound addEffectOfType:EffectType::Reverb];
        [sound setEffectValueForType:EffectType::Reverb forParameter:EffectParameter::Reverb_Room withValue:[reverbSlider value]];
        [self.reverbButton setTitle:@"Disable Reverb" forState:UIControlStateNormal];
        reverbEnabled = true;
    }
    else
    {
        [sound removeEffectOfType:EffectType::Reverb];
        [self.reverbButton setTitle:@"Enable Reverb" forState:UIControlStateNormal];
        reverbEnabled = false;
    }
}

- (IBAction)changeReverbLevel:(id)sender
{
    //[sound setEffectValueForType:EffectType::Reverb forParameter:EffectParameter::Reverb_Room withValue:[reverbSlider value]];
}

- (IBAction)changeSoundVolume:(id)sender
{
    float normalized = [volumeSlider value] / 100.0f;
    //[sound setVolume:normalized];
    [tone setVolume:normalized];
}

@end
