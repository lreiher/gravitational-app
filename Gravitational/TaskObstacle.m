//
//  TaskObstacle.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "TaskObstacle.h"

@implementation TaskObstacle

+(id)taskObstacleWithSymbol:(NSString*)pSymbol andPosition:(CGPoint)pPosition andScale:(CGFloat)pScale {
    return [[TaskObstacle alloc] initWithSymbol:pSymbol andPosition:pPosition andScale:pScale];
}

-(id)initWithSymbol:(NSString*)pSymbol andPosition:(CGPoint)pPosition andScale:(CGFloat)pScale{
    if ([pSymbol isEqualToString:@"="]) {
        if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"operatorObstacle"]]) {
            //physics object
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[self pathForOperatorObstacleWithSpriteNode:self]];
            self.physicsBody.dynamic = YES;
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.velocity = CGVectorMake(-80.0, 0);
            self.physicsBody.linearDamping = 0.0;
            
            self.scale = pScale;
            self.position = CGPointMake(pPosition.x + self.size.width, pPosition.y);
            self.zPosition = 18.0;
            
            //operator displayed on obstacle
            SKLabelNode* symbol = [SKLabelNode labelNodeWithFontNamed:@"Unispace Bold"];
            symbol.fontColor = [SKColor blackColor];
            symbol.fontSize = 400;
            symbol.text = pSymbol;
            symbol.xScale = 0.5 / self.xScale * self.size.width / symbol.frame.size.width;
            symbol.yScale = 0.25 / self.yScale * self.size.height / symbol.frame.size.height;
            symbol.position = CGPointMake(0, -1.3 * symbol.frame.size.height);
            
            [self addChild:symbol];
        }
    } else if ([pSymbol isEqualToString:@"+"]) {
        if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"operatorObstacle"]]) {
            //physics object
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[self pathForOperatorObstacleWithSpriteNode:self]];
            self.physicsBody.dynamic = YES;
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.velocity = CGVectorMake(-80.0, 0);
            self.physicsBody.linearDamping = 0.0;
            
            self.scale = pScale;
            self.position = CGPointMake(pPosition.x + self.size.width, pPosition.y);
            self.zPosition = 18.0;
            
            //operator displayed on obstacle
            SKLabelNode* symbol = [SKLabelNode labelNodeWithFontNamed:@"Unispace"];
            symbol.fontColor = [SKColor blackColor];
            symbol.fontSize = 400;
            symbol.text = pSymbol;
            symbol.xScale = 0.5 / self.xScale * self.size.width / symbol.frame.size.width;
            symbol.yScale = 0.5 / self.yScale * self.size.height / symbol.frame.size.height;
            symbol.position = CGPointMake(0, -symbol.frame.size.height);
            
            [self addChild:symbol];
        }
    } else if ([pSymbol isEqualToString:@"-"]) {
        if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"operatorObstacle"]]) {
            //physics object
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[self pathForOperatorObstacleWithSpriteNode:self]];
            self.physicsBody.dynamic = YES;
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.velocity = CGVectorMake(-80.0, 0);
            self.physicsBody.linearDamping = 0.0;
            
            self.scale = pScale;
            self.position = CGPointMake(pPosition.x + self.size.width, pPosition.y);
            self.zPosition = 18.0;
            
            //operator displayed on obstacle
            SKLabelNode* symbol = [SKLabelNode labelNodeWithFontNamed:@"Unispace"];
            symbol.fontColor = [SKColor blackColor];
            symbol.fontSize = 400;
            symbol.text = pSymbol;
            symbol.xScale = 0.5 / self.xScale * self.size.width / symbol.frame.size.width;
            symbol.yScale = 0.25 / self.yScale * self.size.height / symbol.frame.size.height;
            symbol.position = CGPointMake(0, -5 * symbol.frame.size.height);
            
            [self addChild:symbol];
        }
    } else if ([pSymbol isEqualToString:@"*"]) {
        if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"operatorObstacle"]]) {
            //physics object
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[self pathForOperatorObstacleWithSpriteNode:self]];
            self.physicsBody.dynamic = YES;
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.velocity = CGVectorMake(-80.0, 0);
            self.physicsBody.linearDamping = 0.0;
            
            self.scale = pScale;
            self.position = CGPointMake(pPosition.x + self.size.width, pPosition.y);
            self.zPosition = 18.0;
            
            //operator displayed on obstacle
            SKLabelNode* symbol = [SKLabelNode labelNodeWithFontNamed:@"Unispace"];
            symbol.fontColor = [SKColor blackColor];
            symbol.fontSize = 400;
            symbol.text = pSymbol;
            symbol.xScale = 0.5 / self.xScale * self.size.width / symbol.frame.size.width;
            symbol.yScale = 0.5 / self.yScale * self.size.height / symbol.frame.size.height;
            symbol.position = CGPointMake(0, -1.35 * symbol.frame.size.height);
            
            [self addChild:symbol];
        }
    } else {
        if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"digitObstacle"]]) {
            //physics object
            self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[self pathForDigitObstacleWithSpriteNode:self]];
            self.physicsBody.dynamic = YES;
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.velocity = CGVectorMake(-80.0, 0);
            self.physicsBody.linearDamping = 0.0;
            
            self.scale = pScale;
            self.position = CGPointMake(pPosition.x + self.size.width, pPosition.y);
            self.zPosition = 18.0;
            
            //digit displayed on obstacle
            SKLabelNode* symbol = [SKLabelNode labelNodeWithFontNamed:@"Unispace"];
            symbol.fontColor = [SKColor blackColor];
            symbol.fontSize = 400;
            symbol.text = pSymbol;            
            symbol.xScale = 0.5 / self.xScale * self.size.width / symbol.frame.size.width;
            symbol.yScale = 0.5 / self.yScale * self.size.height / symbol.frame.size.height;
            symbol.position = CGPointMake(0, -symbol.frame.size.height / 2);
            
            [self addChild:symbol];
        }
    }
    
    return self;
}

-(CGMutablePathRef)pathForOperatorObstacleWithSpriteNode:(SKSpriteNode*)pSprite {
    CGFloat offsetX = pSprite.frame.size.width * pSprite.anchorPoint.x;
    CGFloat offsetY = pSprite.frame.size.height * pSprite.anchorPoint.y;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 36 - offsetX, 99 - offsetY);
    CGPathAddLineToPoint(path, NULL, 27 - offsetX, 97 - offsetY);
    CGPathAddLineToPoint(path, NULL, 19 - offsetX, 93 - offsetY);
    CGPathAddLineToPoint(path, NULL, 12 - offsetX, 87 - offsetY);
    CGPathAddLineToPoint(path, NULL, 5 - offsetX, 79 - offsetY);
    CGPathAddLineToPoint(path, NULL, 1 - offsetX, 69 - offsetY);
    CGPathAddLineToPoint(path, NULL, -1 - offsetX, 61 - offsetY);
    CGPathAddLineToPoint(path, NULL, -1 - offsetX, 36 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 26 - offsetY);
    CGPathAddLineToPoint(path, NULL, 7 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 14 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 21 - offsetX, 5 - offsetY);
    CGPathAddLineToPoint(path, NULL, 30 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 37 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 62 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 72 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 80 - offsetX, 5 - offsetY);
    CGPathAddLineToPoint(path, NULL, 86 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 93 - offsetX, 18 - offsetY);
    CGPathAddLineToPoint(path, NULL, 97 - offsetX, 26 - offsetY);
    CGPathAddLineToPoint(path, NULL, 99 - offsetX, 37 - offsetY);
    CGPathAddLineToPoint(path, NULL, 99 - offsetX, 62 - offsetY);
    CGPathAddLineToPoint(path, NULL, 99 - offsetX, 69 - offsetY);
    CGPathAddLineToPoint(path, NULL, 94 - offsetX, 80 - offsetY);
    CGPathAddLineToPoint(path, NULL, 86 - offsetX, 89 - offsetY);
    CGPathAddLineToPoint(path, NULL, 75 - offsetX, 96 - offsetY);
    CGPathAddLineToPoint(path, NULL, 62 - offsetX, 99 - offsetY);
    
    return path;
    
    CFRelease(path);
}

-(CGMutablePathRef)pathForDigitObstacleWithSpriteNode:(SKSpriteNode*)pSprite {
    CGFloat offsetX = pSprite.frame.size.width * pSprite.anchorPoint.x;
    CGFloat offsetY = pSprite.frame.size.height * pSprite.anchorPoint.y;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 10 - offsetX, 99 - offsetY);
    CGPathAddLineToPoint(path, NULL, 6 - offsetX, 98 - offsetY);
    CGPathAddLineToPoint(path, NULL, 3 - offsetX, 96 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 92 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 90 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 8 - offsetY);
    CGPathAddLineToPoint(path, NULL, 1 - offsetX, 5 - offsetY);
    CGPathAddLineToPoint(path, NULL, 3 - offsetX, 3 - offsetY);
    CGPathAddLineToPoint(path, NULL, 5 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 9 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 89 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 94 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 97 - offsetX, 3 - offsetY);
    CGPathAddLineToPoint(path, NULL, 98 - offsetX, 5 - offsetY);
    CGPathAddLineToPoint(path, NULL, 99 - offsetX, 9 - offsetY);
    CGPathAddLineToPoint(path, NULL, 99 - offsetX, 90 - offsetY);
    CGPathAddLineToPoint(path, NULL, 98 - offsetX, 94 - offsetY);
    CGPathAddLineToPoint(path, NULL, 95 - offsetX, 98 - offsetY);
    CGPathAddLineToPoint(path, NULL, 90 - offsetX, 99 - offsetY);
    CGPathCloseSubpath(path);
    
    return path;
    
    CFRelease(path);
}

@end
