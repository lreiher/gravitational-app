//
//  Arrow.h
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Arrow : SKSpriteNode {
    
}

+(id)arrowWithPosition:(CGPoint)pPosition andPhysicsBody:(BOOL)pBoolPhysicsBody;

-(void)animatePause:(BOOL)enabled duration:(CGFloat)duration;

@end
