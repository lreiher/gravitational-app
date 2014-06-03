//
//  Background.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "Background.h"

@implementation Background

+(id)backgroundWithPosition:(CGPoint)pPosition {
    return [[Background alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    //iPhone 4 or iPhone 5
    if ([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568.0f) {
        if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"background-568"]]) {
            self.position = pPosition;
            self.zPosition = 10.0;
        }
    } else {
        if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"background"]]) {
            self.position = pPosition;
            self.zPosition = 10.0;
        }
    }
    
    return self;
}

@end
