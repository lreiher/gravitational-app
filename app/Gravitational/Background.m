//
//  Background.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "Background.h"
/*-------------------------*/

@implementation Background {
    
}

#pragma mark Initializer

+(id)backgroundWithPosition:(CGPoint)pPosition {
    return [[Background alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[[Global globals] textureNamed:@"bg_overlay"]]) {
        self.alpha = 0.04;
        self.anchorPoint = CGPointMake(0.5, 0.0);
        self.position = pPosition;
        self.zPosition = 10.0;
        
        [self moveBackground];
    }
    
    return self;
}

#pragma mark Work

-(void)moveBackground {
    SKAction* moveBackground = [SKAction moveByX:-[Global globals].GAME_AREA.width / 2 y:0 duration:30.0];
    SKAction* resetBackground = [SKAction moveByX:[Global globals].GAME_AREA.width / 2 y:0 duration:0.0];
    SKAction* animateBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBackground,resetBackground]]];
    [self runAction:animateBackgroundForever];
}

@end
