//
//  SettingsScene.m
//  Gravitational
//
//  Created by Lennart Reiher on 31.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "SettingsScene.h"

#import "Background.h"

@implementation SettingsScene {
    
    NSMutableArray* background;
    SKSpriteNode* settingsScreen;
    SKSpriteNode* settingsScreenOptional;
    SKSpriteNode* iapButton;
    SKSpriteNode* restoreButton;
    SKShapeNode* rateButton;
    SKShapeNode* mailButton;
    SKShapeNode* menuButton;
    SKShapeNode* musicSwitch;
    SKShapeNode* soundsSwitch;
}

@synthesize delegate = _delegate;

#pragma mark Initializer

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self setupBackground];
        [self setupScreen];
    }
    return self;
}

#pragma mark Work

-(void)didMoveToView:(SKView *)view {
    [_delegate showAdsAtTop:NO];
    
    [_delegate sendGAIScreen:@"Settings Scene"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    
    if ([touchedNode.name isEqualToString:@"menu"] || [touchedNode.name isEqualToString:@"iap"] || [touchedNode.name isEqualToString:@"restore"] || [touchedNode.name isEqualToString:@"rate"] || [touchedNode.name isEqualToString:@"mail"]) {
        touchedNode.alpha = 0.5;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [settingsScreen childNodeWithName:@"menu"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"iap"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"restore"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"rate"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"mail"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"menu"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"iap"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"restore"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"rate"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"mail"].alpha = 0.0;
    
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    if ([touchedNode.name isEqualToString:@"menu"]) {
        [_delegate presentMenu];
    } else if ([touchedNode.name isEqualToString:@"music"]) {
        [self useSwitch:musicSwitch];
    } else if ([touchedNode.name isEqualToString:@"sounds"]) {
        [self useSwitch:soundsSwitch];
    } else if ([touchedNode.name isEqualToString:@"iap"]) {
        [_delegate removeAdsForever];
    } else if ([touchedNode.name isEqualToString:@"restore"]) {
        [_delegate restorePreviousPurchases];
    } else if ([touchedNode.name isEqualToString:@"rate"]) {
        [_delegate switchToAppStore];
    } else if ([touchedNode.name isEqualToString:@"mail"]) {
        [_delegate sendMail];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    [settingsScreen childNodeWithName:@"menu"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"iap"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"restore"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"rate"].alpha = 0.0;
    [settingsScreen childNodeWithName:@"mail"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"menu"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"iap"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"restore"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"rate"].alpha = 0.0;
    [settingsScreenOptional childNodeWithName:@"mail"].alpha = 0.0;
}

-(void)useSwitch:(SKNode*)pNode {
    SKAction* move = [SKAction moveByX:22 y:0 duration:0.25 / [Global globals].SPEED];
    if ([[Global globals].USERDEFAULTS boolForKey:pNode.name]) {
        [pNode runAction:move.reversedAction];
        if ([pNode.name isEqualToString:@"music"]) {
            if ([Global globals].MUSICPLAYER.url != nil) {
                [[Global globals].MUSICPLAYER stop];
            }
        }
    } else {
        [pNode runAction:move];
        if ([pNode.name isEqualToString:@"music"]) {
            [self setupMusic];
        } else {
            [self runAction:[SKAction playSoundFileNamed:@"soundCorrect.caf" waitForCompletion:NO]];
        }
    }
    [[Global globals].USERDEFAULTS setBool:![[Global globals].USERDEFAULTS boolForKey:pNode.name] forKey:pNode.name];
    [[Global globals].USERDEFAULTS synchronize];
}

-(void)scrollNode:(SKNode*)node {
    SKAction* scroll = [SKAction moveByX:-[Global globals].GAME_AREA.width y:0 duration:20.0 / [Global globals].SPEED];
    SKAction* reset = [SKAction moveByX:[Global globals].GAME_AREA.width y:0 duration:0.0];
    SKAction* animateForever = [SKAction repeatActionForever:[SKAction sequence:@[scroll,reset]]];
    [node runAction:animateForever];
}

-(void)reactToSuccessfulPurchase {
    [self setupScreenOptional];
    SKAction* move = [SKAction moveByX:-[Global globals].GAME_AREA.width y:0.0 duration:1.0 / [Global globals].SPEED];
    [settingsScreen runAction:move];
    [settingsScreenOptional runAction:move];
    [settingsScreen enumerateChildNodesWithName:@"spikes" usingBlock:^(SKNode* node, BOOL* stop){
        [node removeFromParent];
    }];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],
                                         [SKAction runBlock:^{
        [settingsScreen removeFromParent];
        settingsScreen = settingsScreenOptional;
        settingsScreenOptional = nil;
    }]]]];
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
-(void)setupScreen {
    settingsScreen = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"settings"]];
    settingsScreen.anchorPoint = CGPointMake(0.0, 0.0);
    settingsScreen.position = CGPointMake(0.0, 0.0);
    settingsScreen.zPosition = 30.0;
    [self addChild:settingsScreen];
    
    [self setupSpikes:settingsScreen];
    [self setupMenuButton:settingsScreen];
    [self setupRateButton:settingsScreen];
    [self setupMailButton:settingsScreen];
    [self setupMusicButton:settingsScreen];
    [self setupSoundsButton:settingsScreen];
    
    if ([Global globals].ADS) {
        [self setupIAPButton:settingsScreen];
        [self setupRestoreIAPButton:settingsScreen];
    }
}
-(void)setupScreenOptional {
    settingsScreenOptional = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"settings"]];
    settingsScreenOptional.anchorPoint = CGPointMake(0.0, 0.0);
    settingsScreenOptional.position = CGPointMake([Global globals].GAME_AREA.width, 0.0);
    settingsScreenOptional.zPosition = 30.0;
    [self addChild:settingsScreenOptional];
    
    [self setupSpikes:settingsScreenOptional];
    [self setupMenuButton:settingsScreenOptional];
    [self setupRateButton:settingsScreenOptional];
    [self setupMailButton:settingsScreenOptional];
    [self setupMusicButton:settingsScreenOptional];
    [self setupSoundsButton:settingsScreenOptional];
    
    if ([Global globals].ADS) {
        [self setupIAPButton:settingsScreenOptional];
        [self setupRestoreIAPButton:settingsScreenOptional];
    }
}
-(void)setupSpikes:(SKNode*)parent {
    for (int i = 0; i < 3; ++i) {
        SKSpriteNode* spikesTop = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"fl_spi"]];
        SKSpriteNode* spikesBottom = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"fl_spi"]];
        spikesTop.zPosition = 29.0;
        spikesBottom.zPosition = spikesTop.zPosition;
        spikesTop.anchorPoint = CGPointMake(0.5, 0.0);
        spikesBottom.anchorPoint = spikesTop.anchorPoint;
        spikesTop.yScale = -1.0;
        if ([Global globals].ADS) {spikesTop.position = CGPointMake([Global globals].GAME_AREA.width * i, 198);}
        else {spikesTop.position = CGPointMake([Global globals].GAME_AREA.width * i, 248);}
        spikesBottom.position = CGPointMake([Global globals].GAME_AREA.width * i, 87);
        spikesTop.name = @"spikes";
        spikesBottom.name = spikesTop.name;
        [self scrollNode:spikesTop];
        [self scrollNode:spikesBottom];
        [parent addChild:spikesTop];
        [parent addChild:spikesBottom];
    }
}
-(void)setupMenuButton:(SKNode*)parent {
    menuButton = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-35,-35, 70, 70), nil);
    menuButton.path = p;
    CGPathRelease(p);
    menuButton.fillColor = [Global globals].FONT_COLOR;
    menuButton.strokeColor = nil;
    menuButton.alpha = 0.0;
    menuButton.name = @"menu";
    menuButton.zPosition = 35.0;
    menuButton.position = CGPointMake(self.frame.size.width - 44, 44);
    [parent addChild:menuButton];
}
-(void)setupIAPButton:(SKNode*)parent {
    iapButton = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR size:CGSizeMake(80, 50)];
    iapButton.alpha = 0.0;
    iapButton.zPosition = 35.0;
    iapButton.name = @"iap";
    iapButton.position = CGPointMake(50, 45);
    [parent addChild:iapButton];
}
-(void)setupRestoreIAPButton:(SKNode*)parent {
    restoreButton = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR size:CGSizeMake(80, 50)];
    restoreButton.alpha = 0.0;
    restoreButton.zPosition = 35.0;
    restoreButton.name = @"restore";
    restoreButton.position = CGPointMake(135, 45);
    [parent addChild:restoreButton];
}
-(void)setupRateButton:(SKNode*)parent {
    rateButton = [SKShapeNode node];
    CGPathRef p;
    if ([Global globals].ADS) {
        rateButton.position = CGPointMake(208, 60);
        p = CGPathCreateWithEllipseInRect(CGRectMake(-16, -16, 32, 32), nil);
    } else {
        rateButton.position = CGPointMake(208, 44);
        p = CGPathCreateWithEllipseInRect(CGRectMake(-22, -22, 44, 44), nil);
    }
    rateButton.path = p;
    CGPathRelease(p);
    rateButton.fillColor = [Global globals].FONT_COLOR;
    rateButton.strokeColor = nil;
    rateButton.alpha = 0.0;
    rateButton.name = @"rate";
    rateButton.zPosition = 35.0;
    [parent addChild:rateButton];
}
-(void)setupMailButton:(SKNode*)parent {
    mailButton = [SKShapeNode node];
    CGPathRef p;
    if ([Global globals].ADS) {
        mailButton.position = CGPointMake(208, 27);
        p = CGPathCreateWithEllipseInRect(CGRectMake(-16, -16, 32, 32), nil);
    } else {
        mailButton.position = CGPointMake(160, 44);
        p = CGPathCreateWithEllipseInRect(CGRectMake(-22, -22, 44, 44), nil);
    }
    mailButton.path = p;
    CGPathRelease(p);
    mailButton.fillColor = [Global globals].FONT_COLOR;
    mailButton.strokeColor = nil;
    mailButton.alpha = 0.0;
    mailButton.name = @"mail";
    mailButton.zPosition = 35.0;
    [parent addChild:mailButton];
}
-(void)setupMusicButton:(SKNode*)parent {
    musicSwitch = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-12, -12, 25, 25), nil);
    musicSwitch.path = p;
    CGPathRelease(p);
    musicSwitch.fillColor = [Global globals].FONT_COLOR;
    musicSwitch.strokeColor = musicSwitch.fillColor;
    musicSwitch.name = @"music";
    musicSwitch.zPosition = 35.0;
    if ([[Global globals] isWidescreen]) {
        if ([[Global globals].USERDEFAULTS boolForKey:musicSwitch.name]) {
            musicSwitch.position = CGPointMake(217, 410);
        } else {
            musicSwitch.position = CGPointMake(195, 410);
        }
    } else {
        if ([[Global globals].USERDEFAULTS boolForKey:musicSwitch.name]) {
            musicSwitch.position = CGPointMake(217, 355);
        } else {
            musicSwitch.position = CGPointMake(195, 355);
        }
    }
    [parent addChild:musicSwitch];
    
    SKSpriteNode* dummyButton = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:1.0 alpha:0.0] size:CGSizeMake(60, 50)];
    dummyButton.zPosition = 40.0;
    dummyButton.name = @"music";
    if ([[Global globals] isWidescreen]) {
        dummyButton.position = CGPointMake(206, 410);
    } else {
        dummyButton.position = CGPointMake(206, 355);
    }
    [parent addChild:dummyButton];
}
-(void)setupSoundsButton:(SKNode*)parent {
    soundsSwitch = [SKShapeNode node];
    soundsSwitch.path = musicSwitch.path;
    soundsSwitch.fillColor = musicSwitch.fillColor;
    soundsSwitch.strokeColor = soundsSwitch.fillColor;
    soundsSwitch.name = @"sounds";
    soundsSwitch.zPosition = 35.0;
    if ([[Global globals] isWidescreen]) {
        if ([[Global globals].USERDEFAULTS boolForKey:soundsSwitch.name]) {
            soundsSwitch.position = CGPointMake(217, 349);
        } else {
            soundsSwitch.position = CGPointMake(195, 349);
        }
    } else {
        if ([[Global globals].USERDEFAULTS boolForKey:soundsSwitch.name]) {
            soundsSwitch.position = CGPointMake(217, 312);
        } else {
            soundsSwitch.position = CGPointMake(195, 312);
        }
    }
    [parent addChild:soundsSwitch];
    
    SKSpriteNode* dummyButton = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:1.0 alpha:0.0] size:CGSizeMake(60, 50)];
    dummyButton.zPosition = 40.0;
    dummyButton.name = @"sounds";
    if ([[Global globals] isWidescreen]) {
        dummyButton.position = CGPointMake(206, 349);
    } else {
        dummyButton.position = CGPointMake(206, 312);
    }
    [parent addChild:dummyButton];
}
-(void)setupMusic {
    
    [Global globals].MUSICPLAYER = [[Global globals].MUSICPLAYER initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"backgroundMenu"
                                                                                                               withExtension:@"mp3"]
                                                                                 error:nil];
    [Global globals].MUSICPLAYER.numberOfLoops = -1;
    [[Global globals].MUSICPLAYER prepareToPlay];
    [[Global globals].MUSICPLAYER play];
}

@end
