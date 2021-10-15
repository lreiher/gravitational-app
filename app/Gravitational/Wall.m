//
//  Wall.m
//  Gravitational
//
//  Created by Lennart Reiher on 24.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "Wall.h"

@implementation Wall {
    SKSpriteNode* wall1;
    SKSpriteNode* wall2;
    SKSpriteNode* wall3;
    SKSpriteNode* wall4;
    SKLabelNode* topResult;
    SKLabelNode* midResult;
    SKLabelNode* bottomResult;
}

#pragma mark Initializer

+(id)wallWithResults:(NSMutableArray*)pResults {
    
    return [[Wall alloc] initWithResults:pResults];
}

-(id)initWithResults:(NSMutableArray*)pResults {
    if (self = [super init]) {
        self.zPosition = 15.0;
        self.name = @"obstaclePausable";
        self.position = CGPointMake([Global globals].GAME_AREA.width, 0);
        
        [self setupWallElements];
        [self setupLabelsWithResults:pResults];
        
        [self move];
    }
    
    return self;
}

#pragma mark Work 

-(void)move {
    SKAction* moveWall = [SKAction moveByX: - [Global globals].GAME_AREA.width * 2  y:0 duration:7 / [Global globals].SPEED];
    [self runAction:moveWall];
}

-(void)letWallDisappear:(SKNode*)touchedNode {
    
    SKAction* moveUpwards = [SKAction moveByX:-[Global globals].GAME_AREA.width/2 y:[Global globals].GAME_AREA.height/2 duration:2.5 / [Global globals].SPEED];
    SKAction* moveDownwards = [SKAction moveByX:-[Global globals].GAME_AREA.width/2 y:-[Global globals].GAME_AREA.height/2 duration:2.5 / [Global globals].SPEED];
    SKAction* fadeAway = [SKAction fadeAlphaTo:0.0 duration:0.5 / [Global globals].SPEED];
    SKAction* remove = [SKAction removeFromParent];
    SKAction* fadeAndRemove = [SKAction sequence:@[fadeAway,remove]];
    
    if ([touchedNode.name isEqualToString:topResult.parent.name]) {
        [wall1 runAction:moveUpwards];
        [wall2 runAction:moveDownwards];
        [wall3 runAction:moveDownwards];
        [wall4 runAction:moveDownwards];
    } else if ([touchedNode.name isEqualToString:midResult.parent.name]) {
        [wall1 runAction:moveUpwards];
        [wall2 runAction:moveUpwards];
        [wall3 runAction:moveDownwards];
        [wall4 runAction:moveDownwards];
    } else {
        [wall1 runAction:moveUpwards];
        [wall2 runAction:moveUpwards];
        [wall3 runAction:moveUpwards];
        [wall4 runAction:moveDownwards];
    }
    
    [self runAction:fadeAndRemove];
}

#pragma mark Setup

-(void)setupWallElements {
    [self setupWall1];
    [self setupWall2];
    [self setupWall3];
    [self setupWall4];
}

-(void)setupWall1 {
    wall1 = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"wall1"]];
    wall1.anchorPoint = CGPointMake(1.0, 1.0);
    wall1.position = CGPointMake(wall1.frame.size.width, [Global globals].GAME_AREA.height - 25.0);
    [self setupPhysicsBodyForWall1];
    [self addChild:wall1];
}

-(void)setupWall2 {
    wall2 = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"wall2"]];
    wall2.anchorPoint = CGPointMake(1.0, 0.0);
    wall2.position = CGPointMake(wall1.frame.size.width, [Global globals].GAME_AREA.height / 2 + 2.5);
    [self setupPhysicsBodyForWall2];
    [self addChild:wall2];
}

-(void)setupWall3 {
    wall3 = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"wall3"]];
    wall3.anchorPoint = CGPointMake(1.0, 1.0);
    wall3.position = CGPointMake(wall1.frame.size.width, [Global globals].GAME_AREA.height / 2 - 2.5);
    [self setupPhysicsBodyForWall3];
    [self addChild:wall3];
}

-(void)setupWall4 {
    wall4 = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"wall4"]];
    wall4.anchorPoint = CGPointMake(1.0, 0.0);
    wall4.position = CGPointMake(wall1.frame.size.width, 25.0);
    [self setupPhysicsBodyForWall4];
    [self addChild:wall4];
}

-(void)setupPhysicsBodyForWall1 {
    CGFloat offsetX = wall1.frame.size.width * wall1.anchorPoint.x;
    CGFloat offsetY = wall1.frame.size.height * wall1.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 0 - offsetX, 93 - offsetY);
                CGPathAddLineToPoint(path, NULL, 23 - offsetX, 12 - offsetY);
                CGPathAddLineToPoint(path, NULL, 89 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 188 - offsetX, 28 - offsetY);
                CGPathAddLineToPoint(path, NULL, 188 - offsetX, 93 - offsetY);
            } else {
                CGPathMoveToPoint(path, NULL, 0 - offsetX, 69 - offsetY);
                CGPathAddLineToPoint(path, NULL, 18 - offsetX, 11 - offsetY);
                CGPathAddLineToPoint(path, NULL, 84 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 182 - offsetX, 30 - offsetY);
                CGPathAddLineToPoint(path, NULL, 182 - offsetX, 69 - offsetY);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 0 - offsetX, 118 - offsetY);
                CGPathAddLineToPoint(path, NULL, 26 - offsetX, 15 - offsetY);
                CGPathAddLineToPoint(path, NULL, 92 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 190 - offsetX, 26 - offsetY);
                CGPathAddLineToPoint(path, NULL, 190 - offsetX, 118 - offsetY);
            } else {
                CGPathMoveToPoint(path, NULL, 0 - offsetX, 82 - offsetY);
                CGPathAddLineToPoint(path, NULL, 21 - offsetX, 12 - offsetY);
                CGPathAddLineToPoint(path, NULL, 87 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 186 - offsetX, 30 - offsetY);
                CGPathAddLineToPoint(path, NULL, 186 - offsetX, 82 - offsetY);
            }
        } else {
            //iPad
        }
    }
    
    CGPathCloseSubpath(path);
    
    wall1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    wall1.physicsBody.dynamic = NO;
    wall1.physicsBody.affectedByGravity = NO;
    
    CGPathRelease(path);
}

-(void)setupPhysicsBodyForWall2 {
    CGFloat offsetX = wall2.frame.size.width * wall2.anchorPoint.x;
    CGFloat offsetY = wall2.frame.size.height * wall2.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 148 - offsetX, 161 - offsetY);
                CGPathAddLineToPoint(path, NULL, 50 - offsetX, 133 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 87 - offsetY);
                CGPathAddLineToPoint(path, NULL, 8 - offsetX, 30 - offsetY);
                CGPathAddLineToPoint(path, NULL, 68 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 148 - offsetX, 0 - offsetY);
            } else {
                CGPathMoveToPoint(path, NULL, 145 - offsetX, 142 - offsetY);
                CGPathAddLineToPoint(path, NULL, 49 - offsetX, 113 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 66 - offsetY);
                CGPathAddLineToPoint(path, NULL, 5 - offsetX, 30 - offsetY);
                CGPathAddLineToPoint(path, NULL, 65 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 145 - offsetX, 0 - offsetY);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 147 - offsetX, 158 - offsetY);
                CGPathAddLineToPoint(path, NULL, 51 - offsetX, 134 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 89 - offsetY);
                CGPathAddLineToPoint(path, NULL, 8 - offsetX, 30 - offsetY);
                CGPathAddLineToPoint(path, NULL, 68 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 147 - offsetX, 0 - offsetY);
            } else {
                CGPathMoveToPoint(path, NULL, 147 - offsetX, 154 - offsetY);
                CGPathAddLineToPoint(path, NULL, 50 - offsetX, 126 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 80 - offsetY);
                CGPathAddLineToPoint(path, NULL, 7 - offsetX, 30 - offsetY);
                CGPathAddLineToPoint(path, NULL, 67 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 147 - offsetX, 0 - offsetY);
            }
        } else {
            //iPad
        }
    }
    
    CGPathCloseSubpath(path);
    
    wall2.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    wall2.physicsBody.dynamic = NO;
    wall2.physicsBody.affectedByGravity = NO;
    
    CGPathRelease(path);
}

-(void)setupPhysicsBodyForWall3 {
    CGFloat offsetX = wall3.frame.size.width * wall3.anchorPoint.x;
    CGFloat offsetY = wall3.frame.size.height * wall3.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 148 - offsetX, 161 - offsetY);
                CGPathAddLineToPoint(path, NULL, 68 - offsetX, 161 - offsetY);
                CGPathAddLineToPoint(path, NULL, 8 - offsetX, 131 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 74 - offsetY);
                CGPathAddLineToPoint(path, NULL, 50 - offsetX, 28 - offsetY);
                CGPathAddLineToPoint(path, NULL, 148 - offsetX, 0 - offsetY);
            } else {
                CGPathMoveToPoint(path, NULL, 145 - offsetX, 142 - offsetY);
                CGPathAddLineToPoint(path, NULL, 65 - offsetX, 142 - offsetY);
                CGPathAddLineToPoint(path, NULL, 5 - offsetX, 112 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 76 - offsetY);
                CGPathAddLineToPoint(path, NULL, 49 - offsetX, 29 - offsetY);
                CGPathAddLineToPoint(path, NULL, 145 - offsetX, 0 - offsetY);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 147 - offsetX, 158 - offsetY);
                CGPathAddLineToPoint(path, NULL, 68 - offsetX, 158 - offsetY);
                CGPathAddLineToPoint(path, NULL, 8 - offsetX, 128 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 69 - offsetY);
                CGPathAddLineToPoint(path, NULL, 51 - offsetX, 24 - offsetY);
                CGPathAddLineToPoint(path, NULL, 147 - offsetX, 0 - offsetY);
            } else {
                CGPathMoveToPoint(path, NULL, 147 - offsetX, 154 - offsetY);
                CGPathAddLineToPoint(path, NULL, 67 - offsetX, 154 - offsetY);
                CGPathAddLineToPoint(path, NULL, 7 - offsetX, 124 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 74 - offsetY);
                CGPathAddLineToPoint(path, NULL, 50 - offsetX, 28 - offsetY);
                CGPathAddLineToPoint(path, NULL, 147 - offsetX, 0 - offsetY);
            }
        } else {
            //iPad
        }
    }
    
    CGPathCloseSubpath(path);
    
    wall3.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    wall3.physicsBody.dynamic = NO;
    wall3.physicsBody.affectedByGravity = NO;
    
    CGPathRelease(path);
}

-(void)setupPhysicsBodyForWall4 {
    CGFloat offsetX = wall4.frame.size.width * wall4.anchorPoint.x;
    CGFloat offsetY = wall4.frame.size.height * wall4.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 188 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 188 - offsetX, 65 - offsetY);
                CGPathAddLineToPoint(path, NULL, 89 - offsetX, 93 - offsetY);
                CGPathAddLineToPoint(path, NULL, 23 - offsetX, 81 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
            } else {                
                CGPathMoveToPoint(path, NULL, 182 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 182 - offsetX, 39 - offsetY);
                CGPathAddLineToPoint(path, NULL, 84 - offsetX, 69 - offsetY);
                CGPathAddLineToPoint(path, NULL, 18 - offsetX, 58 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                CGPathMoveToPoint(path, NULL, 190 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 190 - offsetX, 92 - offsetY);
                CGPathAddLineToPoint(path, NULL, 92 - offsetX, 118 - offsetY);
                CGPathAddLineToPoint(path, NULL, 26 - offsetX, 103 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
            } else {
                CGPathMoveToPoint(path, NULL, 186 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, NULL, 186 - offsetX, 52 - offsetY);
                CGPathAddLineToPoint(path, NULL, 87 - offsetX, 82 - offsetY);
                CGPathAddLineToPoint(path, NULL, 21 - offsetX, 70 - offsetY);
                CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
            }
        } else {
            //iPad
        }
    }
    
    CGPathCloseSubpath(path);
    
    wall4.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    wall4.physicsBody.dynamic = NO;
    wall4.physicsBody.affectedByGravity = NO;
    
    CGPathRelease(path);
}

-(void)setupLabelsWithResults:(NSMutableArray*)pResults {
    NSInteger random = arc4random_uniform(6);
    switch (random) {
        case 1:
            [self setupTopResult:[pResults objectAtIndex:0] correct:YES];
            [self setupMidResult:[pResults objectAtIndex:2] correct:NO];
            [self setupBottomResult:[pResults objectAtIndex:1] correct:NO];
            break;
        case 2:
            [self setupTopResult:[pResults objectAtIndex:1] correct:NO];
            [self setupMidResult:[pResults objectAtIndex:2] correct:NO];
            [self setupBottomResult:[pResults objectAtIndex:0] correct:YES];
            break;
        case 3:
            [self setupTopResult:[pResults objectAtIndex:2] correct:NO];
            [self setupMidResult:[pResults objectAtIndex:0] correct:YES];
            [self setupBottomResult:[pResults objectAtIndex:1] correct:NO];
            break;
        case 4:
            [self setupTopResult:[pResults objectAtIndex:2] correct:NO];
            [self setupMidResult:[pResults objectAtIndex:1] correct:NO];
            [self setupBottomResult:[pResults objectAtIndex:0] correct:YES];
            break;
        case 5:
            [self setupTopResult:[pResults objectAtIndex:1] correct:NO];
            [self setupMidResult:[pResults objectAtIndex:0] correct:YES];
            [self setupBottomResult:[pResults objectAtIndex:2] correct:NO];
            break;
        default:
            [self setupTopResult:[pResults objectAtIndex:0] correct:YES];
            [self setupMidResult:[pResults objectAtIndex:1] correct:NO];
            [self setupBottomResult:[pResults objectAtIndex:2] correct:NO];
            break;
    }
}

-(void)setupMidResult:(NSString*)pString correct:(BOOL)correct{
    midResult = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    midResult.fontSize = 30;
    midResult.fontColor = [Global globals].FONT_COLOR;
    midResult.text = pString;
    midResult.name = @"result";
    SKSpriteNode* container = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:1.0 alpha:0.0] size:CGSizeMake(40, midResult.frame.size.height)];
    container.anchorPoint = CGPointMake(1.0, 0.5);
    midResult.position = CGPointMake(-midResult.frame.size.width / 2, -midResult.frame.size.height / 2);
    [container addChild:midResult];
    
    container.position = CGPointMake(wall1.frame.size.width - 100, [Global globals].GAME_AREA.height / 2);
    
    [self setupPhysicsBodyFor:container];
    [self addChild:container];
    if (correct) {
        container.name = @"correctMid";
    } else {
        container.name = @"wrong";
    }
}

-(void)setupTopResult:(NSString*)pString correct:(BOOL)correct{
    topResult = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    topResult.fontSize = 30;
    topResult.fontColor = [Global globals].FONT_COLOR;
    topResult.text = pString;
    topResult.name = @"result";
    SKSpriteNode* container = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:1.0 alpha:0.0] size:CGSizeMake(40, topResult.frame.size.height)];
    container.anchorPoint = CGPointMake(1.0, 0.5);
    container.zRotation = 16.0 / 180.0 * M_PI;
    topResult.position = CGPointMake(-topResult.frame.size.width / 2, -topResult.frame.size.height / 2);
    [container addChild:topResult];
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                container.position = CGPointMake(wall1.frame.size.width - 118, 3 * [Global globals].GAME_AREA.height / 4 + 4);
            } else {
                container.position = CGPointMake(wall1.frame.size.width - 118, 3 * [Global globals].GAME_AREA.height / 4 + 5);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                container.position = CGPointMake(wall1.frame.size.width - 118, 3 * [Global globals].GAME_AREA.height / 4 - 7);
            } else {
                container.position = CGPointMake(wall1.frame.size.width - 118, 3 * [Global globals].GAME_AREA.height / 4 + 5);
            }
        } else {
            //iPad
        }
    }
    
    [self setupPhysicsBodyFor:container];
    [self addChild:container];
    if (correct) {
        container.name = @"correctTop";
    } else {
        container.name = @"wrong";
    }
}

-(void)setupBottomResult:(NSString*)pString correct:(BOOL)correct{
    bottomResult = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    bottomResult.fontSize = 30;
    bottomResult.fontColor = [Global globals].FONT_COLOR;
    bottomResult.text = pString;
    bottomResult.name = @"result";
    SKSpriteNode* container = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:1.0 alpha:0.0] size:CGSizeMake(40, bottomResult.frame.size.height)];
    container.anchorPoint = CGPointMake(1.0, 0.5);
    container.zRotation = - 16.0 / 180.0 * M_PI;
    bottomResult.position = CGPointMake(-bottomResult.frame.size.width / 2, -bottomResult.frame.size.height / 2);
    [container addChild:bottomResult];
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                container.position = CGPointMake(wall1.frame.size.width - 118, [Global globals].GAME_AREA.height / 4 - 3);
            } else {
                container.position = CGPointMake(wall1.frame.size.width - 118, [Global globals].GAME_AREA.height / 4 - 4);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                container.position = CGPointMake(wall1.frame.size.width - 118, [Global globals].GAME_AREA.height / 4 + 9);
            } else {
                container.position = CGPointMake(wall1.frame.size.width - 118, [Global globals].GAME_AREA.height / 4 - 4);
            }
        } else {
            //iPad
        }
    }
    
    [self setupPhysicsBodyFor:container];
    [self addChild:container];
    if (correct) {
        container.name = @"correctBottom";
    } else {
        container.name = @"wrong";
    }
}

-(void)setupPhysicsBodyFor:(SKSpriteNode*)pContainer {
    pContainer.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(pContainer.size.width, pContainer.size.height) center:CGPointMake(-pContainer.size.width / 2, 0)];
    pContainer.physicsBody.dynamic = NO;
    pContainer.physicsBody.affectedByGravity = NO;
    pContainer.physicsBody.categoryBitMask = [Global globals].RESULT_CAT;
    pContainer.physicsBody.collisionBitMask = 1;
}

@end
