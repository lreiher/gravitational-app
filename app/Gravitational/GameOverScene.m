//
//  GameOverScene.m
//  Gravitational
//
//  Created by Lennart Reiher on 23.06.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "GameOverScene.h"

#import "Background.h"
#import "Ceiling.h"
#import "Floor.h"
#import "GameOverLeftElement.h"
#import "GameOverRightElement.h"
/*-------------------------*/

@implementation GameOverScene {
    
    NSMutableArray* background;
    Floor* fl;
    Ceiling* cl;
    GameOverLeftElement* leftEl;
    GameOverRightElement* rightEl;
}

@synthesize delegate = _delegate;

#pragma mark Initializer

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        if ([Global globals].ADS) {
            [self setupAdPlaceholder];
        }
        
        [self setupBackground];
        [self setupFloor];
        [self setupCeiling];
        [self setupLeftElement];
        [self setupRightElement];
    }
    return self;
}

#pragma mark Work

-(void)didMoveToView:(SKView *)view {
    if ([[Global globals].USERDEFAULTS boolForKey:@"music"]) {
        [Global globals].MUSICPLAYER.volume = 0.05;
    }
    
    if ([Global globals].SCORE < 140) {
        NSInteger u = [[[Global globals] USERDEFAULTS] integerForKey:@"consecutiveGamesBelow140"];
        [[Global globals].USERDEFAULTS setInteger:(u+1) forKey:@"consecutiveGamesBelow140"];
    } else {
        [[Global globals].USERDEFAULTS setInteger:0 forKey:@"consecutiveGamesBelow140"];
    }

    [[Global globals].USERDEFAULTS synchronize];
    
    [_delegate sendGAIScreen:@"GameOver Scene"];
    
    if ([[Global globals].USERDEFAULTS integerForKey:@"consecutiveGamesBelow140"] > 4 && ![[Global globals].USERDEFAULTS boolForKey:@"tutorialPromptDisabled"]) {
        [_delegate showTutorialPrompt];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    
    if ([touchedNode.name isEqualToString:@"gc"] || [touchedNode.name isEqualToString:@"menu"] || [touchedNode.name isEqualToString:@"share"]) {
        touchedNode.alpha = 0.5;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [rightEl childNodeWithName:@"gc"].alpha = 0.0;
    [rightEl childNodeWithName:@"menu"].alpha = 0.0;
    [rightEl childNodeWithName:@"share"].alpha = 0.0;
    
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    if ([touchedNode.name isEqualToString:@"menu"]) {
        [self switchToMenu];
    } else if ([touchedNode.name isEqualToString:@"gc"]) {
        [_delegate showLeaderboard];
    } else if ([touchedNode.name isEqualToString:@"share"]) {
        [_delegate showShareViewController];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    [rightEl childNodeWithName:@"gc"].alpha = 0.0;
    [rightEl childNodeWithName:@"menu"].alpha = 0.0;
    [rightEl childNodeWithName:@"share"].alpha = 0.0;
    
    CGPoint trans = [recognizer translationInView:recognizer.view];
    CGPoint veloc = [recognizer velocityInView:recognizer.view];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [rightEl handlePanLeftWithTranslation:trans andVelocity:veloc];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (veloc.x < -550.0) {
            [rightEl handleQuickSwipeWithTranslation:trans andVelocity:veloc];
        } else if ([rightEl readyToReplay]) {
            [self switchToGame];
        }
    }
}

-(void)switchToGame {
    [_delegate presentGameWithDirection:SKTransitionDirectionLeft];
}

-(void)switchToMenu {
    [[Global globals].MUSICPLAYER stop];
    [_delegate presentMenu];
}

#pragma mark Setup

-(void)setupBackground {
    
    self.backgroundColor = [Global globals].BG_COLOR;
    background = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; ++i) {
        Background* bg = [Background backgroundWithPosition:CGPointMake([Global globals].GAME_AREA.width * i, 0)];
        [background addObject:bg];
        [self addChild:bg];
    }
}
-(void)setupFloor {
    
    fl = [Floor floorWithPosition:CGPointMake(0, 0)];
    [fl runAction:[SKAction sequence:@[
                                       [SKAction moveByX:0
                                                       y:-fl.frame.size.height duration:0.4 / [Global globals].SPEED],
                                       [SKAction removeFromParent]]]];
    [self addChild:fl];
}
-(void)setupCeiling {
    
    cl = [Ceiling ceilingWithPosition:CGPointMake(0, [Global globals].GAME_AREA.height)];
    [cl runAction:[SKAction sequence:@[
                                       [SKAction moveByX:0 y:cl.frame.size.height duration:0.4 / [Global globals].SPEED],
                                       [SKAction removeFromParent]]]];
    [self addChild:cl];
}
-(void)setupLeftElement {
    leftEl = [GameOverLeftElement gameOverLeftElementWithPosition:CGPointMake(0.0, 0.0)];
    [self addChild:leftEl];
}
-(void)setupRightElement {
    rightEl = [GameOverRightElement gameOverRightElementWithPosition:CGPointMake([Global globals].GAME_AREA.width, 0.0)];
    [self addChild:rightEl];
}
-(void)setupAdPlaceholder {
    SKSpriteNode* adPlaceholder = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR
                                                               size:[Global globals].BANNER_AREA];
    adPlaceholder.anchorPoint = CGPointMake(0, 0);
    adPlaceholder.position = CGPointMake(0, [Global globals].GAME_AREA.height);
    adPlaceholder.zPosition = 20.0;
    [self addChild:adPlaceholder];
}

@end
