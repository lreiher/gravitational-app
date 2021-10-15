//
//  MenuScene.m
//  Gravitational
//
//  Created by Lennart Reiher on 16.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "MenuScene.h"

#import "GameScene.h"

#import "Background.h"
#import "MenuLeftElement.h"
#import "MenuRightElement.h"
#import "Arrow.h"
/*-------------------------*/

@implementation MenuScene {
    NSMutableArray* background;
    MenuLeftElement* leftEl;
    MenuRightElement* rightEl;
    Arrow* arrow;
    GameScene* game;
}

@synthesize delegate = _delegate;

#pragma mark Initalizer

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self setupBackground];
        [self setupLeftElement];
        [self setupRightElement];
        [self setupArrow];
    }
    return self;
}

#pragma mark Work

//animating the arrow
-(void)update:(NSTimeInterval)currentTime {
    arrow.physicsBody.velocity = CGVectorMake(0.0, arrow.physicsBody.velocity.dy);
    arrow.zRotation = 2 * (arrow.position.y - self.frame.size.height / 2) / (self.frame.size.height - 100) * atan(0.5);
    //automatically changes gravity
    if ((arrow.position.y >= (self.frame.size.height / 2) && self.physicsWorld.gravity.dy > 0) || (arrow.position.y <= (self.frame.size.height / 2) && self.physicsWorld.gravity.dy < 0)) {
        self.physicsWorld.gravity = CGVectorMake(0, -self.physicsWorld.gravity.dy);
    }
}
-(void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    [leftEl childNodeWithName:@"gc"].alpha = 0.0;
    [leftEl childNodeWithName:@"settings"].alpha = 0.0;
    [rightEl childNodeWithName:@"info"].alpha = 0.0;
    [rightEl childNodeWithName:@"help"].alpha = 0.0;
    
    CGPoint trans = [recognizer translationInView:recognizer.view];
    CGPoint veloc = [recognizer velocityInView:recognizer.view];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [leftEl handlePanRightWithTranslation:trans andVelocity:veloc];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (veloc.x > 550.0) {
            [leftEl handleQuickSwipeWithTranslation:trans andVelocity:veloc];
        } else if ([leftEl readyToStart]) {
            [self switchToGame];
        }
    }
}
-(void)didMoveToView:(SKView *)view {
    [_delegate hideAds];
    if ([[Global globals].USERDEFAULTS boolForKey:@"music"]) {
        [self setupMusic];
    }
    
    [_delegate sendGAIScreen:@"Menu Scene"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    
    if ([touchedNode.name isEqualToString:@"gc"] || [touchedNode.name isEqualToString:@"settings"] || [touchedNode.name isEqualToString:@"info"] || [touchedNode.name isEqualToString:@"help"]) {
        touchedNode.alpha = 0.5;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [leftEl childNodeWithName:@"gc"].alpha = 0.0;
    [leftEl childNodeWithName:@"settings"].alpha = 0.0;
    [rightEl childNodeWithName:@"info"].alpha = 0.0;
    [rightEl childNodeWithName:@"help"].alpha = 0.0;
    
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    
    if ([touchedNode.name isEqualToString:@"gc"]) {
        [_delegate showLeaderboard];
    } else if ([touchedNode.name isEqualToString:@"settings"]) {
        [_delegate presentSettings];
    } else if ([touchedNode.name isEqualToString:@"info"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About"
                                                        message:@"\u00A9 2014 Lennart Reiher\n\nDesign:\nJonas Reiher\nLennart Reiher\n\nwww.gravitational-app.com"
                                                       delegate:nil
                                              cancelButtonTitle:@"Return to game"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([touchedNode.name isEqualToString:@"help"]) {
        [_delegate presentTutorial];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)switchToGame {
    if (![[Global globals].USERDEFAULTS boolForKey:@"notFirstGame"]) {
        [_delegate presentTutorial];
        [[Global globals].USERDEFAULTS setBool:true forKey:@"notFirstGame"];
        [[Global globals].USERDEFAULTS synchronize];
    } else {
        [[Global globals].MUSICPLAYER stop];
        [_delegate presentGameWithDirection:SKTransitionDirectionRight];
    }
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
-(void)setupLeftElement {
    leftEl = [MenuLeftElement menuLeftElementWithPosition:CGPointMake(0, 0)];
    [self addChild:leftEl];
}
-(void)setupRightElement {
    rightEl = [MenuRightElement menuRightElementWithPosition:CGPointMake([Global globals].GAME_AREA.width, 0)];
    [self addChild:rightEl];
}
-(void)setupArrow {
    self.physicsWorld.gravity = CGVectorMake(0, 1.0);
    arrow = [Arrow arrowWithPosition:CGPointMake(160, self.frame.size.height / 2 - 65) andPhysicsBody:YES];
    arrow.zRotation = 2 * (arrow.position.y - self.frame.size.height / 2) / (self.frame.size.height - 100) * atan(0.5);
    arrow.physicsBody.restitution = 0.0;
    arrow.physicsBody.linearDamping = 0.1;
    [leftEl addChild:arrow];
}
-(void)setupMusic {
    
    if (![[Global globals].MUSICPLAYER.url.resourceSpecifier hasSuffix:@"backgroundMenu.mp3"]) {
        [Global globals].MUSICPLAYER = [[Global globals].MUSICPLAYER initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"backgroundMenu"
                                                                                                                   withExtension:@"mp3"]
                                                                                     error:nil];
        [Global globals].MUSICPLAYER.numberOfLoops = -1;
        [[Global globals].MUSICPLAYER prepareToPlay];
        [[Global globals].MUSICPLAYER play];
    }
}

@end
