//
//  Floor.m
//  Gravitational
//
//  Created by Lennart Reiher on 19.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "Floor.h"

#import "GameScene.h"
/*-------------------------*/

@implementation Floor {
    SKLabelNode* scoreLabel;
    SKLabelNode* bestScoreLabel;
    SKSpriteNode* slideDownTextCover;
    SKSpriteNode* bottom;
    CGFloat hiddenPartHeight;
    CGFloat pausePosY;
}

#pragma mark Initializer

+(id)floorWithPosition:(CGPoint)pPosition {
    return [[Floor alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[[Global globals] textureNamed:@"fl"]]) {
        self.anchorPoint = CGPointMake(0.0, 0.0);
        self.zPosition = 30.0;
        self.name = @"floor";
        pausePosY = 51.0;
        
        hiddenPartHeight = self.frame.size.height - 25;
        self.position = CGPointMake(pPosition.x, pPosition.y - hiddenPartHeight);
        
        [self setupPhysicsBody];
        [self setupSpikes];
        [self setupScoreLabels];
        [self setupMenuButton];
        [self setupSlideDownTextCover];
        [self setupBottomPart];
    }
    
    return self;
}

#pragma mark Work

-(void)animatePause:(BOOL)enabled duration:(CGFloat)duration {
    SKAction* move;
    if (enabled) {
        move = [SKAction moveToY:pausePosY duration:duration / [Global globals].SPEED];
        [self updateScore];
    } else {
        move = [SKAction moveToY:-hiddenPartHeight duration:duration / [Global globals].SPEED];
    }
    [self runAction:move];
}
-(void)handlePanDownWithTranslation:(CGPoint)translation andVelocity:(CGPoint)velocity {
    CGPoint newPosition = CGPointMake(0, self.position.y - translation.y);
    if (newPosition.y >= (pausePosY - 36.0) && newPosition.y <= pausePosY) {
        self.position = newPosition;
        bottom.position = CGPointMake(bottom.position.x, bottom.position.y + translation.y);
        slideDownTextCover.alpha = (pausePosY - self.position.y) / 35.0;
    }
}
-(void)handleQuickSwipeWithTranslation:(CGPoint)pTranlation andVelocity:(CGPoint)pVelocity {
    CGFloat diff = self.position.y - (pausePosY - 35.0);
    SKAction* move = [SKAction moveByX:0.0 y:-diff duration:(diff * 200.0) / (35.0 * pVelocity.y * [Global globals].SPEED)];
    SKAction* fadeCover = [SKAction fadeAlphaTo:1.0 duration:(diff * 200.0) / (35.0 * pVelocity.y * [Global globals].SPEED)];
    SKAction* unpause = [SKAction runBlock:^{
        [(GameScene*)self.parent unpauseGame];
    }];
    [self runAction:[SKAction sequence:@[move,unpause]]];
    [bottom runAction:move.reversedAction];
    [slideDownTextCover runAction:fadeCover];
    [bottom runAction:[SKAction sequence:@[
                                           [SKAction waitForDuration:1.25 / [Global globals].SPEED],
                                           [SKAction moveToY:-pausePosY duration:0.0]]]];
    [slideDownTextCover runAction:[SKAction sequence:@[
                                                       [SKAction waitForDuration:1.25 / [Global globals].SPEED],
                                                       [SKAction fadeAlphaTo:0.0 duration:0.0]]]];
}
-(BOOL)needsToBeUnpaused {
    if (self.position.y <= (pausePosY - 35.0)) {
        [bottom runAction:[SKAction sequence:@[
                                               [SKAction waitForDuration:0.25 / [Global globals].SPEED],
                                               [SKAction moveToY:-pausePosY duration:0.0]]]];
        [slideDownTextCover runAction:[SKAction sequence:@[
                                                           [SKAction waitForDuration:0.25 / [Global globals].SPEED],
                                                           [SKAction fadeAlphaTo:0.0 duration:0.0]]]];
        return true;
    } else {
        CGFloat diff = pausePosY - self.position.y;
        SKAction* reset = [SKAction moveByX:0.0 y:diff duration:5 / (diff * [Global globals].SPEED)];
        SKAction* resetBottom = [SKAction moveByX:0.0 y:-diff duration:5 / (diff * [Global globals].SPEED)];
        [self runAction:reset];
        [bottom runAction:resetBottom];
        SKAction* resetOpacityLevelOnSlideDownText = [SKAction fadeAlphaTo:0.0 duration:5 / (diff * [Global globals].SPEED)];
        [slideDownTextCover runAction:resetOpacityLevelOnSlideDownText];
        return false;
    }
}

-(void)scrollNode:(SKNode*)node {
    SKAction* scroll = [SKAction moveByX:-[Global globals].GAME_AREA.width y:0 duration:20.0 / [Global globals].SPEED];
    SKAction* reset = [SKAction moveByX:[Global globals].GAME_AREA.width y:0 duration:0.0];
    SKAction* animateForever = [SKAction repeatActionForever:[SKAction sequence:@[scroll,reset]]];
    [node runAction:animateForever];
}
-(void)updateScore {
    scoreLabel.text = [self stringWithZeroesFromScore:[Global globals].SCORE];
    bestScoreLabel.text = [self stringWithZeroesFromScore:[[Global globals].USERDEFAULTS integerForKey:@"bestScore"]];
}
-(NSString*)stringWithZeroesFromScore:(NSInteger)pScore {
    NSString* score = [NSString stringWithFormat:@"%ld",(long)pScore];
    for (int i = 0; i < (6 - score.length + i); ++i) {
        score = [NSString stringWithFormat:@"%@%@",@"0",score];
    }
    return score;
}

#pragma mark Setup

-(void)setupPhysicsBody {
    //dummy-physics-body (one for collision-detection, one as obstacle)
    SKNode* dummy = [SKNode node];
    SKNode* dummyColl = [SKNode node];
    dummy.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, self.frame.size.height) toPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    dummyColl.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, self.frame.size.height) toPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    dummyColl.physicsBody.categoryBitMask = [Global globals].OBSTACLE_CAT;
    [self addChild:dummy];
    [self addChild:dummyColl];
}
-(void)setupSpikes {
    for (int i = 0; i < 3; ++i) {
        SKSpriteNode* spikes = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"fl_spi"]];
        spikes.zPosition = 29.0;
        spikes.anchorPoint = CGPointMake(0.5, 0.0);
        spikes.position = CGPointMake([Global globals].GAME_AREA.width * i, self.frame.size.height);
        [self scrollNode:spikes];
        [self addChild:spikes];
    }
}
-(void)setupScoreLabels {
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    scoreLabel.fontSize = 40;
    scoreLabel.fontColor = [Global globals].FONT_COLOR;
    scoreLabel.name = @"scoreLabel";
    scoreLabel.text = [self stringWithZeroesFromScore:[Global globals].SCORE];
    [self addChild:scoreLabel];
    
    bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    bestScoreLabel.fontSize = 26;
    bestScoreLabel.fontColor = [Global globals].FONT_COLOR;
    bestScoreLabel.text = [self stringWithZeroesFromScore:[[Global globals].USERDEFAULTS integerForKey:@"bestScore"]];
    [self addChild:bestScoreLabel];
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                scoreLabel.position = CGPointMake(227, 268);
                bestScoreLabel.position = CGPointMake(202, 224);
            } else {
                scoreLabel.position = CGPointMake(227, 197);
                bestScoreLabel.position = CGPointMake(202, 153);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                scoreLabel.position = CGPointMake(227, 314);
                bestScoreLabel.position = CGPointMake(202, 270);
            } else {
                scoreLabel.position = CGPointMake(227, 232);
                bestScoreLabel.position = CGPointMake(202, 188);
            }
        } else {
            //iPad
        }
    }
}
-(void)setupMenuButton {
    SKShapeNode* menuButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-35,-35, 70, 70), nil);
    menuButton.path = p;
    CGPathRelease(p);
    menuButton.fillColor = [Global globals].FONT_COLOR;
    menuButton.strokeColor = nil;
    menuButton.alpha = 0.0;
    menuButton.name = @"menu";
    [self addChild:menuButton];
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                menuButton.position = CGPointMake(self.frame.size.width / 2, 128);
            } else {
                menuButton.position = CGPointMake(self.frame.size.width / 2, 94);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                menuButton.position = CGPointMake(self.frame.size.width / 2, 152);
            } else {
                menuButton.position = CGPointMake(self.frame.size.width / 2, 112);
            }
        } else {
            //iPad
        }
    }
}
-(void)setupSlideDownTextCover {
    slideDownTextCover = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR size:CGSizeMake(80, 40)];
    slideDownTextCover.alpha = 0.0;
    slideDownTextCover.position = CGPointMake(self.frame.size.width / 2, 30);
    slideDownTextCover.name = @"slideDownTextCover";
    [self addChild:slideDownTextCover];
}
-(void)setupBottomPart {
    bottom = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"fl_b"]];
    bottom.anchorPoint = CGPointMake(0.0, 0.0);
    bottom.position = CGPointMake(0, -pausePosY);
    bottom.name = @"bottom";
    [self addChild:bottom];
}

@end
