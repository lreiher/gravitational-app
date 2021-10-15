//
//  MenuRightElement.m
//  Gravitational
//
//  Created by Lennart Reiher on 12.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "MenuRightElement.h"
/*-------------------------*/

@implementation MenuRightElement {
    SKShapeNode* infoButton;
    SKShapeNode* helpButton;
}

#pragma mark Initializer

+(id)menuRightElementWithPosition:(CGPoint)pPosition {
    return [[MenuRightElement alloc] initWithPosition:pPosition ];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[[Global globals] textureNamed:@"menu_right"]]) {
        self.anchorPoint = CGPointMake(1.0, 0.0);
        self.position = pPosition;
        self.zPosition = 25.0;
        self.name = @"menuRightElement";
        
        [self setupInfoButton];
        [self setupHelpButton];
    }
    
    return self;
}

-(void)setupInfoButton {
    infoButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-20,-20, 40, 40), nil);
    infoButton.path = p;
    CGPathRelease(p);
    infoButton.fillColor = [Global globals].FONT_COLOR;
    infoButton.strokeColor = nil;
    infoButton.alpha = 0.0;
    infoButton.name = @"info";
    infoButton.position = CGPointMake(-25, 25);
    [self addChild:infoButton];
}

-(void)setupHelpButton {
    helpButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-20,-20, 40, 40), nil);
    helpButton.path = p;
    CGPathRelease(p);
    helpButton.fillColor = [Global globals].FONT_COLOR;
    helpButton.strokeColor = nil;
    helpButton.alpha = 0.0;
    helpButton.name = @"help";
    helpButton.position = CGPointMake(-25, 60);
    [self addChild:helpButton];
}

@end
