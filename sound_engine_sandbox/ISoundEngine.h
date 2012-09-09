//
//  ISoundEngine.h
//  Resonance
//
//  Created by Daniel Stepp on 9/7/12.
//  Copyright (c) 2012 Monomyth Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RESOTypes.h"

@protocol ISound;
@protocol ITone;

@protocol ISoundEngine <NSObject>

-(id)initWithEngineType:(EngineType)et;
+(id<ISoundEngine>)getSingletonOfType:(EngineType)et;
-(void)shutdown;

-(id<ISound>)getSoundForId:(int)identifier;
-(id<ITone>)getToneForId:(int)identifier;

@end