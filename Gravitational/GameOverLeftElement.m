//
//  GameOverLeftElement.m
//  Gravitational
//
//  Created by Lennart Reiher on 18.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "GameOverLeftElement.h"
/*-------------------------*/

@implementation GameOverLeftElement {

}

#pragma mark Initializer

+(id)gameOverLeftElementWithPosition:(CGPoint)pPosition {
    return [[GameOverLeftElement alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[[Global globals] textureNamed:@"gameover_left"]]) {
        self.anchorPoint = CGPointMake(0.0, 0.0);
        self.position = CGPointMake(pPosition.x - self.frame.size.width, pPosition.y);
        self.zPosition = 25.0;
        self.name = @"gameOverLeftElement";
    }
    
    [self moveIn];
    
    return self;
}

#pragma mark Work

-(void)moveIn {
    [self runAction:[SKAction moveByX:self.frame.size.width
                                    y:0 duration:0.4 / [Global globals].SPEED]];
}

@end
