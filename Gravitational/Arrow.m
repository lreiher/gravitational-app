//
//  Arrow.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "Arrow.h"
/*-------------------------*/

@implementation Arrow {
    
}

#pragma mark Initializer

+(id)arrowWithPosition:(CGPoint)pPosition andPhysicsBody:(BOOL)pBoolPhysicsBody {
    return [[Arrow alloc] initWithPosition:pPosition andPhysicsBody:pBoolPhysicsBody];
}

-(id)initWithPosition:(CGPoint)pPosition andPhysicsBody:(BOOL)pBoolPhysicsBody {
    if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"arrow"]]) {
        self.position = pPosition;
        self.zPosition = 20.0;
        self.name = @"arrow";
        
        if (pBoolPhysicsBody) [self setupPhysicsBody];
    }
    
    return self;
}

#pragma mark Work

-(void)animatePause:(BOOL)enabled duration:(CGFloat)duration {
    if (enabled) {
        [self removeAllActions];
        self.alpha = 0.0;
        self.physicsBody.categoryBitMask = [Global globals].DUMMY_CAT;
    } else {
        [self runAction:[SKAction fadeAlphaTo:1.0
                                     duration:duration / [Global globals].SPEED]];
    }
}

#pragma mark Setup

-(void)setupPhysicsBody {
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 25 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 50 - offsetY);
    CGPathCloseSubpath(path);
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    self.physicsBody.affectedByGravity = YES;
    self.physicsBody.dynamic = YES;
    self.physicsBody.restitution = 0.3;
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.friction = 0.0;
    self.physicsBody.categoryBitMask = [Global globals].ARROW_CAT;
    self.physicsBody.contactTestBitMask = [Global globals].OBSTACLE_CAT | [Global globals].RESULT_CAT;
    self.physicsBody.collisionBitMask = 1;
    CGPathRelease(path);
}

@end
