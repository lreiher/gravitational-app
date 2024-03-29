//
//  Floor.h
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Floor : SKSpriteNode {
    
}

+(id)floorWithPosition:(CGPoint)pPosition;

-(void)animatePause:(BOOL)enabled duration:(CGFloat)duration;
-(void)handlePanDownWithTranslation:(CGPoint)translation andVelocity:(CGPoint)velocity;
-(void)handleQuickSwipeWithTranslation:(CGPoint)translation andVelocity:(CGPoint)velocity;
-(BOOL)needsToBeUnpaused;

@end
