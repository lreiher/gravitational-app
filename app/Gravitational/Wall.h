//
//  Wall.h
//  Gravitational
//
//  Created by Lennart Reiher on 24.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Wall : SKNode 

+(id)wallWithResults:(NSMutableArray*)pResults;

-(void)letWallDisappear:(SKNode*)touchedNode;

@end
