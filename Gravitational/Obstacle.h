//
//  Obstacle.h
//  Gravitational
//
//  Created by Lennart Reiher on 19.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Obstacle : SKNode

+(id)obstacleWithYPosition:(CGFloat)yPos andString:(NSString*)pString;

@end
