//
//  TaskObstacle.h
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TaskObstacle : SKSpriteNode

+(id)taskObstacleWithSymbol:(NSString*)pSymbol andPosition:(CGPoint)pPosition andScale:(CGFloat)pScale;

@end
