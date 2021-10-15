//
//  Obstacle.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle {
    
}

#pragma mark Initializer

+(id)obstacleWithYPosition:(CGFloat)yPos andString:(NSString*)pString {
    
    return [[Obstacle alloc] initWithYPosition:yPos andString:pString];
}

-(id)initWithYPosition:(CGFloat)yPos andString:(NSString*)pString {
    if (self = [super init]) {
        self.position = CGPointMake([Global globals].GAME_AREA.width, yPos);
        self.zPosition = 18.0;
        self.name = @"obstaclePausable";
    }
    
    [self setupSpriteNodesWithString:pString];
    
    return self;
}

#pragma mark Setup

-(void)setupSpriteNodesWithString:(NSString*)pString {
    
    SKSpriteNode* obst;
    SKTextureAtlas* texAtl = [SKTextureAtlas atlasNamed:@"textureAtlas_TaskObstacles"];
    if ([[NSScanner scannerWithString:pString] scanInteger:nil]) {
        if (pString.length == 1) {
            obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:[NSString stringWithFormat:@"s%c",[pString characterAtIndex:0]]]];
            obst.anchorPoint = CGPointMake(0.0, 0.5);
            obst.position = CGPointMake(0.0, 0.0);
            [self setupPhysicsBodyForElement:obst inPosition:@"s"];
            [self addChild:obst];
        } else {
            for (int i = 0; i < pString.length; i++) {
                if (i == 0) {
                    obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:[NSString stringWithFormat:@"l%c",[pString characterAtIndex:i]]]];
                    obst.anchorPoint = CGPointMake(0.0, 0.5);
                    obst.position = CGPointMake(0.0, 0.0);
                    [self setupPhysicsBodyForElement:obst inPosition:@"l"];
                } else if (i == pString.length - 1) {
                    obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:[NSString stringWithFormat:@"r%c",[pString characterAtIndex:i]]]];
                    obst.anchorPoint = CGPointMake(0.0, 0.5);
                    obst.position = CGPointMake(50.0 * i, 0.0);
                    [self setupPhysicsBodyForElement:obst inPosition:@"r"];
                } else {
                    obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:[NSString stringWithFormat:@"m%c",[pString characterAtIndex:i]]]];
                    obst.anchorPoint = CGPointMake(0.0, 0.5);
                    obst.position = CGPointMake(50.0 * i, 0.0);
                    [self setupPhysicsBodyForElement:obst inPosition:@"m"];
                }
                [self addChild:obst];
            }
        }
    } else {
        if ([pString isEqualToString:@"+"]) {
            obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:@"add"]];
            obst.anchorPoint = CGPointMake(0.0, 0.5);
            obst.position = CGPointMake(0.0, 0.0);
        } else if ([pString isEqualToString:@"-"]) {
            obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:@"subtract"]];
            obst.anchorPoint = CGPointMake(0.0, 0.5);
            obst.position = CGPointMake(0.0, 0.0);
        } else if ([pString isEqualToString:@"*"]) {
            obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:@"multiply"]];
            obst.anchorPoint = CGPointMake(0.0, 0.5);
            obst.position = CGPointMake(0.0, 0.0);
        } else {
            obst = [SKSpriteNode spriteNodeWithTexture:[texAtl textureNamed:@"divide"]];
            obst.anchorPoint = CGPointMake(0.0, 0.5);
            obst.position = CGPointMake(0.0, 0.0);
        }
        [self setupPhysicsBodyForElement:obst inPosition:@"o"];
        [self addChild:obst];
    }
    
    
    
    
    
}

-(void)setupPhysicsBodyForElement:(SKSpriteNode*)pElement inPosition:(NSString*)pPos {
    
    CGFloat offsetX = pElement.frame.size.width * pElement.anchorPoint.x;
    CGFloat offsetY = pElement.frame.size.height * pElement.anchorPoint.y;
    
    if ([pPos isEqualToString:@"s"]) {
        CGMutablePathRef path1 = CGPathCreateMutable();
        CGPathMoveToPoint(path1, NULL, 37 - offsetX, 100 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 21 - offsetX, 98 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 12 - offsetX, 94 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 6 - offsetX, 87 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 2 - offsetX, 76 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 0 - offsetX, 50 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 2 - offsetX, 24 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 6 - offsetX, 13 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 12 - offsetX, 6 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 21 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path1, NULL, 37 - offsetX, 0 - offsetY);
        CGPathCloseSubpath(path1);
        
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, NULL, 38 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 54 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 63 - offsetX, 6 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 69 - offsetX, 13 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 73 - offsetX, 24 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 75 - offsetX, 50 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 73 - offsetX, 76 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 69 - offsetX, 87 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 63 - offsetX, 94 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 54 - offsetX, 98 - offsetY);
        CGPathAddLineToPoint(path2, NULL, 38 - offsetX, 100 - offsetY);
        CGPathCloseSubpath(path2);

        SKPhysicsBody* pb1 = [SKPhysicsBody bodyWithPolygonFromPath:path1];
        SKPhysicsBody* pb2 = [SKPhysicsBody bodyWithPolygonFromPath:path2];
        
        CGPathRelease(path1);
        CGPathRelease(path2);
        
        pElement.physicsBody = [SKPhysicsBody bodyWithBodies:@[pb1,pb2]];
    } else if ([pPos isEqualToString:@"l"]) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 50 - offsetX, 100 - offsetY);
        CGPathAddLineToPoint(path, NULL, 33 - offsetX, 99 - offsetY);
        CGPathAddLineToPoint(path, NULL, 18 - offsetX, 94 - offsetY);
        CGPathAddLineToPoint(path, NULL, 9 - offsetX, 87 - offsetY);
        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 68 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 50 - offsetY);
        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 32 - offsetY);
        CGPathAddLineToPoint(path, NULL, 9 - offsetX, 13 - offsetY);
        CGPathAddLineToPoint(path, NULL, 18 - offsetX, 6 - offsetY);
        CGPathAddLineToPoint(path, NULL, 33 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 50 - offsetX, 0 - offsetY);
        CGPathCloseSubpath(path);
        
        pElement.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        CGPathRelease(path);
    } else if ([pPos isEqualToString:@"m"]) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 50 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 50 - offsetX, 100 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 100 - offsetY);
        CGPathCloseSubpath(path);
        
        pElement.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        CGPathRelease(path);
    } else if ([pPos isEqualToString:@"r"]) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 17 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 32 - offsetX, 6 - offsetY);
        CGPathAddLineToPoint(path, NULL, 41 - offsetX, 13 - offsetY);
        CGPathAddLineToPoint(path, NULL, 49 - offsetX, 32 - offsetY);
        CGPathAddLineToPoint(path, NULL, 50 - offsetX, 50 - offsetY);
        CGPathAddLineToPoint(path, NULL, 49 - offsetX, 68 - offsetY);
        CGPathAddLineToPoint(path, NULL, 41 - offsetX, 87 - offsetY);
        CGPathAddLineToPoint(path, NULL, 32 - offsetX, 94 - offsetY);
        CGPathAddLineToPoint(path, NULL, 17 - offsetX, 99 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 100 - offsetY);
        CGPathCloseSubpath(path);
        
        pElement.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        CGPathRelease(path);
    } else if ([pPos isEqualToString:@"o"]) {
        pElement.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:37.5 center:CGPointMake(37.5, 0)];
    }
    
    pElement.physicsBody.dynamic = YES;
    pElement.physicsBody.affectedByGravity = NO;
    pElement.physicsBody.velocity = CGVectorMake(-100.0, 0);
    pElement.physicsBody.linearDamping = 0.0;
    pElement.physicsBody.categoryBitMask = [Global globals].OBSTACLE_CAT;
    pElement.physicsBody.contactTestBitMask = [Global globals].ARROW_CAT;
    pElement.physicsBody.collisionBitMask = 0;
}

@end
