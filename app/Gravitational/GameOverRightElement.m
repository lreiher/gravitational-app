//
//  GameOverRightElement.m
//  Gravitational
//
//  Created by Lennart Reiher on 18.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "GameOverRightElement.h"

#import "GameOverScene.h"
/*-------------------------*/

@implementation GameOverRightElement {
    CGPoint initialPosition;
    SKLabelNode* scoreLabel;
    SKLabelNode* bestScoreLabel;
    SKSpriteNode* slideLeftTextCover;
    SKShapeNode* menuButton;
    SKShapeNode* gcButton;
    SKShapeNode* shareButton;
}

#pragma mark Initializer

+(id)gameOverRightElementWithPosition:(CGPoint)pPosition {
    return [[GameOverRightElement alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[[Global globals] textureNamed:@"gameover_right"]]) {
        self.anchorPoint = CGPointMake(1.0, 0.0);
        self.position = CGPointMake(pPosition.x + 35.0 + self.frame.size.width, pPosition.y);
        initialPosition = CGPointMake(self.position.x - self.frame.size.width, self.position.y);
        self.zPosition = 25.0;
        self.name = @"gameOverRightElement";
    }
    
    [self setupScoreLabels];
    [self setupMenuButton];
    [self setupGameCenterButton];
    [self setupShareButton];
    [self setupSlideLeftTextCover];
    
    [self moveIn];
    
    return self;
}

#pragma mark Work

-(void)moveIn {
    [self runAction:[SKAction moveToX:self.position.x - self.frame.size.width duration:0.4 / [Global globals].SPEED]];
}

-(void)handlePanLeftWithTranslation:(CGPoint)pTranslation andVelocity:(CGPoint)pVelocity {
    CGPoint newPosition = CGPointMake(self.position.x + pTranslation.x, self.position.y);
    if (newPosition.x >= [Global globals].GAME_AREA.width && newPosition.x <= [Global globals].GAME_AREA.width + 35) {
        self.position = newPosition;
        slideLeftTextCover.alpha = - (self.position.x - [Global globals].GAME_AREA.width - 35.0) / 35.0;
    }
}
-(void)handleQuickSwipeWithTranslation:(CGPoint)pTranlation andVelocity:(CGPoint)pVelocity {
    CGFloat diff = self.position.x - [Global globals].GAME_AREA.width;
    SKAction* move = [SKAction moveByX:-diff y:0.0 duration:(diff * 200.0) / (35.0 * -pVelocity.x * [Global globals].SPEED)];
    SKAction* fadeCover = [SKAction fadeAlphaTo:1.0 duration:(diff * 200.0) / (35.0 * -pVelocity.x * [Global globals].SPEED)];
    SKAction* present = [SKAction runBlock:^{
        [(GameOverScene*)self.parent switchToGame];
    }];
    [self runAction:[SKAction sequence:@[move,present]]];
    [slideLeftTextCover runAction:fadeCover];
}
-(BOOL)readyToReplay {
    if (self.position.x == [Global globals].GAME_AREA.width) {
        return true;
    } else {
        CGFloat diff = initialPosition.x - self.position.x;
        SKAction* reset = [SKAction moveByX:diff y:0.0 duration:5/(diff * [Global globals].SPEED)];
        [self runAction:reset];
        SKAction* resetOpacityLevel = [SKAction fadeAlphaTo:0.0 duration:5/(diff * [Global globals].SPEED)];
        [slideLeftTextCover runAction:resetOpacityLevel];
        return false;
    }
}

-(NSString*)stringWithZeroesFromScore:(NSInteger)pScore {
    NSString* score = [NSString stringWithFormat:@"%ld",(long)pScore];
    for (int i = 0; i < (6 - score.length + i); ++i) {
        score = [NSString stringWithFormat:@"%@%@",@"0",score];
    }
    return score;
}

#pragma mark Setup

-(void)setupSlideLeftTextCover {
    slideLeftTextCover = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR size:CGSizeMake(140, 30)];
    slideLeftTextCover.alpha = 0.0;
    slideLeftTextCover.anchorPoint = CGPointMake(0.0, 0.5);
    slideLeftTextCover.position = CGPointMake(-195, 115);
    slideLeftTextCover.name = @"slideLeftTextCover";
    [self addChild:slideLeftTextCover];
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
                scoreLabel.position = CGPointMake(-122, 265);
                bestScoreLabel.position = CGPointMake(-147, 219);
            } else {
                scoreLabel.position = CGPointMake(-122, 221);
                bestScoreLabel.position = CGPointMake(-147, 175);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                scoreLabel.position = CGPointMake(-122, 290);
                bestScoreLabel.position = CGPointMake(-147, 244);
            } else {
                scoreLabel.position = CGPointMake(-122, 248);
                bestScoreLabel.position = CGPointMake(-147, 202);
            }
        } else {
            //iPad
        }
    }
}
-(void)setupMenuButton {
    menuButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-35,-35, 70, 70), nil);
    menuButton.path = p;
    CGPathRelease(p);
    menuButton.fillColor = [Global globals].FONT_COLOR;
    menuButton.strokeColor = nil;
    menuButton.alpha = 0.0;
    menuButton.name = @"menu";
    menuButton.position = CGPointMake(-91, 44);
    [self addChild:menuButton];
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
    gcButton.position = CGPointMake(-179, 44);
    [self addChild:gcButton];
}
-(void)setupShareButton {
    shareButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-25, -25, 50, 50), nil);
    shareButton.path = p;
    CGPathRelease(p);
    shareButton.fillColor = [Global globals].FONT_COLOR;
    shareButton.strokeColor = nil;
    shareButton.alpha = 0.0;
    shareButton.name = @"share";
    [self addChild:shareButton];
    
    if ([Global globals].ADS) {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                shareButton.position = CGPointMake(-65, 229);
            } else {
                shareButton.position = CGPointMake(-65, 185);
            }
        } else {
            //iPad
        }
    } else {
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                shareButton.position = CGPointMake(-65, 254);
            } else {
                shareButton.position = CGPointMake(-65, 212);
            }
        } else {
            //iPad
        }
    }
}

@end