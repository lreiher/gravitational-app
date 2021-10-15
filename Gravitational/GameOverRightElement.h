//
//  GameOverRightElement.h
//  Gravitational
//
//  Created by Lennart Reiher on 18.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverRightElement : SKSpriteNode {
    
}

+(id)gameOverRightElementWithPosition:(CGPoint)pPosition;

-(void)handlePanLeftWithTranslation:(CGPoint)pTranslation andVelocity:(CGPoint)pVelocity;
-(void)handleQuickSwipeWithTranslation:(CGPoint)pTranslation andVelocity:(CGPoint)pVelocity;
-(BOOL)readyToReplay;

@end
