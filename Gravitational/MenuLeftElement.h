//
//  MenuLeftElement.h
//  Gravitational
//
//  Created by Lennart Reiher on 12.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MenuLeftElement : SKSpriteNode {
    
}

+(id)menuLeftElementWithPosition:(CGPoint)pPosition;

-(void)handlePanRightWithTranslation:(CGPoint)pTranslation andVelocity:(CGPoint)pVelocity;
-(void)handleQuickSwipeWithTranslation:(CGPoint)pTranlation andVelocity:(CGPoint)pVelocity;
-(BOOL)readyToStart;

@end

