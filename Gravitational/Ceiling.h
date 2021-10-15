//
//  Ceiling.h
//  Gravitational
//
//  Created by Lennart Reiher on 23.06.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ceiling : SKSpriteNode {
    
}

+(id)ceilingWithPosition:(CGPoint)pPosition;

-(void)updateScore;
-(void)animatePause:(BOOL)enabled duration:(CGFloat)duration;

@end
