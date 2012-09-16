//
//  RESOViewController.h
//  Resonance
//
//  Created by Daniel Stepp on 9/6/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESOViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton * loadButton;
@property (weak, nonatomic) IBOutlet UIButton * playButton;
@property (weak, nonatomic) IBOutlet UIButton * pauseButton;
@property (weak, nonatomic) IBOutlet UIButton * reverbButton;
@property (weak, nonatomic) IBOutlet UISlider * reverbSlider;
@property (weak, nonatomic) IBOutlet UISlider * volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton * recordButton;

- (IBAction)loadUnloadSound:(id)sender;
- (IBAction)playStopSound:(id)sender;
- (IBAction)pauseUnpauseSound:(id)sender;
- (IBAction)enableDisableReverb:(id)sender;
- (IBAction)changeReverbLevel:(id)sender;
- (IBAction)changeSoundVolume:(id)sender;
- (IBAction)startStopRecording:(id)sender;

@end
