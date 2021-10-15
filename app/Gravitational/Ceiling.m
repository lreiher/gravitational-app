//
//  Ceiling.m
//  Gravitational
//
//  Created by Lennart Reiher on 23.06.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "Ceiling.h"
/*-------------------------*/

@implementation Ceiling {
    SKNode* scoreLabelGroup;
    NSInteger hiddenPartHeight;
}

#pragma mark Initializer

+(id)ceilingWithPosition:(CGPoint)pPosition {
    return [[Ceiling alloc] initWithPosition:pPosition];
}

-(id)initWithPosition:(CGPoint)pPosition {
    if (self = [super initWithTexture:[[Global globals] textureNamed:@"cl"]]) {
        self.anchorPoint = CGPointMake(0.0, 1.0);
        self.zPosition = 30.0;
        self.name = @"ceiling";

        hiddenPartHeight = self.frame.size.height - 25;
        self.position = CGPointMake(pPosition.x, [Global globals].GAME_AREA.height + hiddenPartHeight);
        
        [self setupPhysicsBody];
        [self setupSpikes];
        [self setupScoreLabel];
        [self setupPauseButton];
    }
    
    return self;
}

#pragma mark Work

-(void)animatePause:(BOOL)enabled duration:(CGFloat)duration{
    SKAction* move;
    if (enabled) {
        move = [SKAction moveToY:[Global globals].GAME_AREA.height duration:duration / [Global globals].SPEED];
    } else {
        move = [SKAction moveToY:[Global globals].GAME_AREA.height + hiddenPartHeight duration:duration / [Global globals].SPEED];
    }
    [self runAction:move];
    [[scoreLabelGroup childNodeWithName:@"hideScoreOverlay"] runAction:[SKAction fadeAlphaTo:(NSInteger)enabled duration:duration / [Global globals].SPEED]];
}
-(void)scrollNode:(SKNode*)node {
    SKAction* scroll = [SKAction moveByX:-[Global globals].GAME_AREA.width y:0 duration:20.0 / [Global globals].SPEED];
    SKAction* reset = [SKAction moveByX:[Global globals].GAME_AREA.width y:0 duration:0.0];
    SKAction* animateForever = [SKAction repeatActionForever:[SKAction sequence:@[scroll,reset]]];
    [node runAction:animateForever];
}
-(void)updateScore {
    NSString* score = [self stringWithZeroesFromScore:[Global globals].SCORE];
    ((SKLabelNode*)[scoreLabelGroup childNodeWithName:@"scoreLabel1"]).text = [NSString stringWithFormat:@"%c",[score characterAtIndex:0]];
    ((SKLabelNode*)[scoreLabelGroup childNodeWithName:@"scoreLabel2"]).text = [NSString stringWithFormat:@"%c",[score characterAtIndex:1]];
    ((SKLabelNode*)[scoreLabelGroup childNodeWithName:@"scoreLabel3"]).text = [NSString stringWithFormat:@"%c",[score characterAtIndex:2]];
    ((SKLabelNode*)[scoreLabelGroup childNodeWithName:@"scoreLabel4"]).text = [NSString stringWithFormat:@"%c",[score characterAtIndex:3]];
    ((SKLabelNode*)[scoreLabelGroup childNodeWithName:@"scoreLabel5"]).text = [NSString stringWithFormat:@"%c",[score characterAtIndex:4]];
    ((SKLabelNode*)[scoreLabelGroup childNodeWithName:@"scoreLabel6"]).text = [NSString stringWithFormat:@"%c",[score characterAtIndex:5]];
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
    dummy.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, -self.frame.size.height) toPoint:CGPointMake(self.frame.size.width, -self.frame.size.height)];
    dummyColl.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, -self.frame.size.height) toPoint:CGPointMake(self.frame.size.width, -self.frame.size.height)];
    dummyColl.physicsBody.categoryBitMask = [Global globals].OBSTACLE_CAT;
    [self addChild:dummy];
    [self addChild:dummyColl];
}
-(void)setupSpikes {
    for (int i = 0; i < 3; ++i) {
        SKSpriteNode* spikes = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"fl_spi"]];
        spikes.zPosition = 29.0;
        spikes.anchorPoint = CGPointMake(0.5, 0.0);
        [spikes setYScale:-1.0];
        spikes.position = CGPointMake([Global globals].GAME_AREA.width * i, -self.frame.size.height);
        [self scrollNode:spikes];
        [self addChild:spikes];
    }
}
-(void)setupScoreLabel {
    scoreLabelGroup = [SKNode node];
    scoreLabelGroup.position = CGPointMake(self.frame.size.width / 2 - 20, -self.frame.size.height + 6.5);
    scoreLabelGroup.name = @"scoreLabelGroup";
    [self addChild:scoreLabelGroup];
    
    SKLabelNode* scoreLabel1 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    SKLabelNode* scoreLabel2 = [SKLabelNode labelNodeWithFontNamed:scoreLabel1.fontName];
    SKLabelNode* scoreLabel3 = [SKLabelNode labelNodeWithFontNamed:scoreLabel1.fontName];
    SKLabelNode* scoreLabel4 = [SKLabelNode labelNodeWithFontNamed:scoreLabel1.fontName];
    SKLabelNode* scoreLabel5 = [SKLabelNode labelNodeWithFontNamed:scoreLabel1.fontName];
    SKLabelNode* scoreLabel6 = [SKLabelNode labelNodeWithFontNamed:scoreLabel1.fontName];
    scoreLabel1.fontSize = 15;
    scoreLabel2.fontSize = scoreLabel1.fontSize;
    scoreLabel3.fontSize = scoreLabel1.fontSize;
    scoreLabel4.fontSize = scoreLabel1.fontSize;
    scoreLabel5.fontSize = scoreLabel1.fontSize;
    scoreLabel6.fontSize = scoreLabel1.fontSize;
    scoreLabel1.fontColor = [Global globals].FONT_COLOR;
    scoreLabel2.fontColor = [Global globals].FONT_COLOR;
    scoreLabel3.fontColor = [Global globals].FONT_COLOR;
    scoreLabel4.fontColor = [Global globals].FONT_COLOR;
    scoreLabel5.fontColor = [Global globals].FONT_COLOR;
    scoreLabel6.fontColor = [Global globals].FONT_COLOR;
    scoreLabel1.position = CGPointMake(0, 0);
    scoreLabel2.position = CGPointMake(8, 0);
    scoreLabel3.position = CGPointMake(16, 0);
    scoreLabel4.position = CGPointMake(24, 0);
    scoreLabel5.position = CGPointMake(32, 0);
    scoreLabel6.position = CGPointMake(40, 0);
    scoreLabel1.name = @"scoreLabel1";
    scoreLabel2.name = @"scoreLabel2";
    scoreLabel3.name = @"scoreLabel3";
    scoreLabel4.name = @"scoreLabel4";
    scoreLabel5.name = @"scoreLabel5";
    scoreLabel6.name = @"scoreLabel6";
    [scoreLabelGroup addChild:scoreLabel1];
    [scoreLabelGroup addChild:scoreLabel2];
    [scoreLabelGroup addChild:scoreLabel3];
    [scoreLabelGroup addChild:scoreLabel4];
    [scoreLabelGroup addChild:scoreLabel5];
    [scoreLabelGroup addChild:scoreLabel6];
    
    SKSpriteNode* hideScoreOverlay = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR size:CGSizeMake(70, 20)];
    hideScoreOverlay.position = CGPointMake(20, 5);
    hideScoreOverlay.alpha = 0.0;
    hideScoreOverlay.name = @"hideScoreOverlay";
    [scoreLabelGroup addChild:hideScoreOverlay];
    
    [self updateScore];
}
-(void)setupPauseButton {
    SKShapeNode* pause = [SKShapeNode node];
    CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-25, -25, 50, 50), nil);
    pause.path = p;
    CGPathRelease(p);
    pause.fillColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    pause.strokeColor = pause.fillColor;
    pause.name = @"pause";
    pause.position = CGPointMake(self.frame.size.width - 15, -self.frame.size.height + 10);
    pause.zPosition = 200.0;
    [self addChild:pause];
}

@end
