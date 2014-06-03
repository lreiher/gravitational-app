//
//  Floor.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "Floor.h"

@implementation Floor

+(id)floorWithPosition:(CGPoint)pPosition andScale:(CGFloat)pScale {
    return [[Floor alloc] initWithPosition:pPosition andScale:pScale];
}

-(id)initWithPosition:(CGPoint)pPosition andScale:(CGFloat)pScale {
    if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"floor"]]) {
        self.position = pPosition;
        self.scale = pScale;
        self.zPosition = 30.0;
        
        //physics body
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height - 2)];
        self.physicsBody.dynamic = NO;
    }
    
    return self;
}

@end
