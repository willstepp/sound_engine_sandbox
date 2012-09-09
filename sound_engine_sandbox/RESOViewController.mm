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

#define __PACKED __attribute__((packed))    /* gcc packed */

@interface RESOViewController ()
{
    id<ISoundEngine> player;
    id<ISound> sound;
    id<ITone> tone;
}
@end

@implementation RESOViewController

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
    player = [FMODSoundEngine getSingletonOfType:EngineType::Player];
    sound = [player getSoundForId:Module::One];
    
    [sound load:[NSString stringWithFormat:@"%@/swish.wav", [[NSBundle mainBundle] resourcePath]]];
    [sound play];
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

@end
