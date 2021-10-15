//
//  MenuLeftElement.m
//  Gravitational
//
//  Created by Lennart Reiher on 12.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "MenuLeftElement.h"
#import "MenuScene.h"
/*-------------------------*/

@implementation MenuLeftElement {
    CGPoint initialPosition;
    SKSpriteNode* slideRightTextCover;
    SKShapeNode* gcButton;
    SKShapeNode* settingsButton;
}

#pragma mark Initializer

+(id)menuLeftElementWithPosition:(CGPoint)pPosition {
    return [[MenuLeftElement alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[[Global globals] textureNamed:@"menu_left"]]) {
        self.anchorPoint = CGPointMake(0.0, 0.0);
        self.position = CGPointMake(pPosition.x - 35.0, pPosition.y);
        initialPosition = self.position;
        self.zPosition = 25.0;
        self.name = @"menuLeftElement";
        
        [self setupSlideRightTextCover];
        [self setupGameCenterButton];
        [self setupSettingsButton];
    }
    
    return self;
}

#pragma mark Work

-(void)handlePanRightWithTranslation:(CGPoint)pTranslation andVelocity:(CGPoint)pVelocity {
    CGPoint newPosition = CGPointMake(self.position.x + pTranslation.x, self.position.y);
    if (newPosition.x >= -35.0 && newPosition.x <= 0.0) {
        self.position = newPosition;
        slideRightTextCover.alpha = (35.0 + self.position.x) / 35.0;
    }
}
-(void)handleQuickSwipeWithTranslation:(CGPoint)pTranlation andVelocity:(CGPoint)pVelocity {
    CGFloat diff = -self.position.x;
    SKAction* move = [SKAction moveByX:diff y:0.0 duration:(diff * 200.0) / (35.0 * pVelocity.x * [Global globals].SPEED)];
    SKAction* fadeCover = [SKAction fadeAlphaTo:1.0 duration:(diff * 200.0) / (35.0 * pVelocity.x * [Global globals].SPEED)];
    SKAction* present = [SKAction runBlock:^{
        [(MenuScene*)self.parent switchToGame];
    }];
    [self runAction:[SKAction sequence:@[move,present]]];
    [slideRightTextCover runAction:fadeCover];
}
-(BOOL)readyToStart {
    if (self.position.x == 0.0) {
        return true;
    } else {
        CGFloat diff = initialPosition.x - self.position.x;
        SKAction* reset = [SKAction moveByX:diff y:0.0 duration:-5/(diff * [Global globals].SPEED)];
        [self runAction:reset];
        SKAction* resetOpacityLevel = [SKAction fadeAlphaTo:0.0 duration:-5/(diff * [Global globals].SPEED)];
        [slideRightTextCover runAction:resetOpacityLevel];
        return false;
    }
}

#pragma mark Setup

-(void)setupSlideRightTextCover {
    slideRightTextCover = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR size:CGSizeMake(70, 45)];
    slideRightTextCover.alpha = 0.0;
    slideRightTextCover.anchorPoint = CGPointMake(0.0, 0.5);
    slideRightTextCover.position = CGPointMake(236, self.frame.size.height / 2);
    slideRightTextCover.name = @"slideRightTextCover";
    [self addChild:slideRightTextCover];
}

-(void)setupGameCenterButton {
    gcButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-35,-35, 70, 70), nil);
    gcButton.path = p;
    CGPathRelease(p);
    gcButton.fillColor = [Global globals].FONT_COLOR;
    gcButton.strokeColor = nil;
    gcButton.alpha = 0.0;
    gcButton.name = @"gc";
    [self addChild:gcButton];
    
    if ([[Global globals] isPhone]) {
        if ([[Global globals] isWidescreen]) {
            gcButton.position = CGPointMake(226, 118);
        } else {
            gcButton.position = CGPointMake(238, 118);
        }
    } else {
        //iPad
    }
}

-(void)setupSettingsButton {
    settingsButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-35,-35, 70, 70), nil);
    settingsButton.path = p;
    CGPathRelease(p);
    settingsButton.fillColor = [Global globals].FONT_COLOR;
    settingsButton.strokeColor = nil;
    settingsButton.alpha = 0.0;
    settingsButton.name = @"settings";
    [self addChild:settingsButton];
    
    if ([[Global globals] isPhone]) {
        if ([[Global globals] isWidescreen]) {
            settingsButton.position = CGPointMake(207, 43);
        } else {
            settingsButton.position = CGPointMake(219, 43);
        }
    } else {
        //iPad
    }
}

@end
