//
//  PauseButton.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "PauseButton.h"

@implementation PauseButton

+(id)pauseButtonWithPosition:(CGPoint)pPosition {
    return [[PauseButton alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"pause"]]) {
        self.position = pPosition;
        self.zPosition = 40.0;
        self.name = @"pauseGame";
    }
    
    return self;
}

@end
