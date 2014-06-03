//
//  Arrow.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "Arrow.h"

@implementation Arrow

+(id)arrowWithPosition:(CGPoint)pPosition {
    return [[Arrow alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"arrow"]]) {
        self.position = pPosition;
        self.zPosition = 20.0;
        
        //physics object
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 47- offsetX, 24 - offsetY);
        CGPathAddLineToPoint(path, NULL, 47 - offsetX, 25 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 49 - offsetY);
        CGPathCloseSubpath(path);
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.affectedByGravity = YES;
        self.physicsBody.dynamic = YES;
        self.physicsBody.restitution = 0.3;
        CFRelease(path);
    }
    
    return self;
}

@end
