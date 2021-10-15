//
//  TutorialScene.m
//  Gravitational
//
//  Created by Lennart Reiher on 11.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "TutorialScene.h"
/*-------------------------*/

@implementation TutorialScene {
    NSInteger currentPage;
    CGFloat xDiff;
    BOOL busyMoving;
    CGFloat gravity;
    BOOL soundOn;
    
    SKSpriteNode* bg;
    SKSpriteNode* buttonNext;
    SKSpriteNode* buttonPrev;
    SKSpriteNode* phyArr;
    SKLabelNode* gravLabel;
}

@synthesize delegate = _delegate;

#pragma mark Initalizer

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        currentPage = 0;
        xDiff = self.frame.size.width;
        busyMoving = false;
        gravity = 0.0;
        soundOn = [[Global globals].USERDEFAULTS boolForKey:@"sounds"];
        
        [self setupBackground];
        [self setupButtons];
        [self setupPhyBarriers];
        [self setupPage0WithDirection:'r'];
    }
    return self;
}

#pragma mark Work

-(void)update:(NSTimeInterval)currentTime {
    
    self.physicsWorld.gravity = CGVectorMake(0.0, gravity);
    if (currentPage == 1 && !busyMoving) {
        phyArr.position = CGPointMake(self.frame.size.width / 2, phyArr.position.y);
        phyArr.physicsBody.velocity = CGVectorMake(0.0, phyArr.physicsBody.velocity.dy);
        phyArr.physicsBody.angularVelocity = 0.0;
        phyArr.zRotation = 2 * (phyArr.position.y - self.frame.size.height / 2) / (self.frame.size.height) * atan(0.5);
    }
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer {

}

-(void)didMoveToView:(SKView *)view {
    [_delegate hideAds];
    if ([[Global globals].USERDEFAULTS boolForKey:@"music"]) {
        [self setupMusic];
    }
    
    [_delegate sendGAIScreen:@"Tutorial Scene"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    
    if ([touchedNode.name isEqualToString:@"next"]) {
        if (!busyMoving) {
            [self nextPage];
            if (soundOn && currentPage == 5) {
                [self runAction:[SKAction playSoundFileNamed:@"soundCorrect.caf" waitForCompletion:NO]];
            } else if (soundOn) {
                [self runAction:[SKAction playSoundFileNamed:@"soundGravity.caf" waitForCompletion:NO]];
            }
        }
    } else if ([touchedNode.name isEqualToString:@"prev"]) {
        if (!busyMoving) {
            [self prevPage];
            if (soundOn) {
                [self runAction:[SKAction playSoundFileNamed:@"soundGravity.caf" waitForCompletion:NO]];
            }
        }
    } else {
        if (currentPage == 1 && !busyMoving) {
            if (gravity == 0.0) {
                gravity = [Global globals].GRAVITY;
                [buttonNext runAction:[SKAction fadeAlphaTo:1.0 duration:1.0 / [Global globals].SPEED]];
                buttonNext.name = @"next";
            } else {
                gravity = -gravity;
                gravLabel.yScale = -gravity/fabsf(gravity);
                if (soundOn) {
                    [self runAction:[SKAction playSoundFileNamed:@"soundGravity.caf" waitForCompletion:NO]];
                }
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)switchToGame {
    [[Global globals].MUSICPLAYER stop];
    [_delegate presentGameWithDirection:SKTransitionDirectionLeft];
}

-(void)nextPage {
    char dir = 'r';
    [self removeCurrentPage:currentPage withDirection:dir];
    currentPage = currentPage + 1;
    if (currentPage == 1) {
        [self setupPage1WithDirection:dir];
        [buttonPrev runAction:[SKAction fadeAlphaTo:1.0 duration:1.0 / [Global globals].SPEED]];
        buttonPrev.name = @"prev";
        [buttonNext runAction:[SKAction fadeAlphaTo:0.0 duration:1.0 / [Global globals].SPEED]];
        buttonNext.name = @"nextHidden";
    } else if (currentPage == 2) {
        [self setupPage2WithDirection:dir];
    } else if (currentPage == 3) {
        [self setupPage3WithDirection:dir];
    } else if (currentPage == 4) {
        [self setupPage4WithDirection:dir];
    } else if (currentPage == 5) {
        [self switchToGame];
    }
}

-(void)prevPage {
    if (currentPage > 0) {
        char dir = 'l';
        [self removeCurrentPage:currentPage withDirection:dir];
        currentPage = currentPage - 1;
        if (currentPage == 0) {
            [self setupPage0WithDirection:dir];
            [buttonPrev runAction:[SKAction fadeAlphaTo:0.0 duration:1.0 / [Global globals].SPEED]];
            buttonPrev.name = @"prevHidden";
            [buttonNext runAction:[SKAction fadeAlphaTo:1.0 duration:1.0 / [Global globals].SPEED]];
            buttonNext.name = @"next";
        } else if (currentPage == 1) {
            [self setupPage1WithDirection:dir];
            [buttonNext runAction:[SKAction fadeAlphaTo:0.0 duration:1.0 / [Global globals].SPEED]];
            buttonNext.name = @"nextHidden";
        } else if (currentPage == 2) {
            [self setupPage2WithDirection:dir];
        } else if (currentPage == 3) {
            [self setupPage3WithDirection:dir];
        }
    }
}

-(void)removeCurrentPage:(NSInteger)p withDirection:(char)dir {
    CGFloat diff;
    if (dir == 'l') {
        diff = xDiff;
    } else {
        diff = -xDiff;
    }
    
    if (p == 1) {
        gravity = 0.0;
    }
    
    [self enumerateChildNodesWithName:[NSString stringWithFormat:@"p%ld",(long)p] usingBlock:^(SKNode* node, BOOL* stop){
        [self removeObject:node byX:diff];
    }];
}

-(void)moveObject:(SKNode*)node byX:(CGFloat)diff {
    busyMoving = true;
    SKAction* move = [SKAction moveByX:diff y:0 duration:1.0 / [Global globals].SPEED];
    SKAction* setBusyMovingFalse = [SKAction runBlock:^{busyMoving = false;}];
    [node runAction:[SKAction sequence:@[move,setBusyMovingFalse]]];
}

-(void)removeObject:(SKNode*)node byX:(CGFloat)diff {
    SKAction* move = [SKAction moveByX:diff y:0 duration:1.0 / [Global globals].SPEED];
    SKAction* remove = [SKAction removeFromParent];
    [node runAction:[SKAction sequence:@[move,remove]]];
}

-(void)wiggleObject:(SKNode*)node byAngle:(CGFloat)a{
    SKAction* wiggle = [SKAction rotateToAngle:a/180.0 * M_PI duration:0.3 / [Global globals].SPEED shortestUnitArc:true];
    SKAction* wiggleBack = [SKAction rotateToAngle:-a/180.0 * M_PI duration:0.3 / [Global globals].SPEED shortestUnitArc:true];
    SKAction* seq = [SKAction sequence:@[wiggle,wiggleBack]];
    SKAction* down = [SKAction moveByX:0.0 y:-3.0 duration:0.6 / [Global globals].SPEED];
    SKAction* up = down.reversedAction;
    SKAction* seq2 = [SKAction sequence:@[down,up]];
    [node runAction:[SKAction repeatActionForever:seq]];
    [node runAction:[SKAction repeatActionForever:seq2]];
}

-(void)pulseObject:(SKNode*)node {
    SKAction* pulse = [SKAction scaleTo:1.3 duration:0.3 / [Global globals].SPEED];
    SKAction* pulseBack = [SKAction scaleTo:1.0 duration:0.3 / [Global globals].SPEED];
    SKAction* wait = [SKAction waitForDuration:1.0 / [Global globals].SPEED];
    SKAction* seq = [SKAction sequence:@[pulse,pulseBack,wait]];
    [node runAction:[SKAction repeatActionForever:seq]];
}

#pragma mark Setup

-(void)setupPage0WithDirection:(char)dir {
    CGFloat diff;
    if (dir == 'l') {
        diff = -xDiff;
    } else {
        diff = xDiff;
    }
    
    SKSpriteNode* arr = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_arrow"]];
    arr.name = @"p0";
    arr.zPosition = 10.0;
    arr.position = CGPointMake(self.frame.size.width / 2 + diff, self.frame.size.height / 2);
    [self addChild:arr];
    
    SKLabelNode* text = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    text.text = @"This is you.";
    text.fontColor = [Global globals].TUT_COLOR;
    text.fontSize = 40.0;
    text.name = @"p0";
    text.zPosition = 5.0;
    text.position = CGPointMake(self.frame.size.width / 2 + diff, self.frame.size.height / 2 + 50);
    [self addChild:text];
    
    [self wiggleObject:arr byAngle:3.0];
    [self enumerateChildNodesWithName:@"p0" usingBlock:^(SKNode* node, BOOL* stop){
        [self moveObject:node byX:-diff];
    }];
    
}

-(void)setupPage1WithDirection:(char)dir {
    CGFloat diff;
    if (dir == 'l') {
        diff = -xDiff;
    } else {
        diff = xDiff;
    }
    
    phyArr = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_arrow"]];
    phyArr.name = @"p1";
    phyArr.zPosition = 10.0;
    phyArr.position = CGPointMake(self.frame.size.width / 2 + diff, self.frame.size.height / 2);
    [self setupPhyArrBody];
    [self addChild:phyArr];
    
    SKNode* textLines = [SKNode node];
    textLines.zPosition = 5.0;
    textLines.position = CGPointMake(self.frame.size.width / 4 - 10 + diff, self.frame.size.height / 2);
    textLines.name = @"p1";
    [self addChild:textLines];
    
    SKLabelNode* line1_1 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line1_1.text = @"Tap";
    line1_1.fontColor = [Global globals].TUT_COLOR;
    line1_1.fontSize = 25.0;
    [textLines addChild:line1_1];
    
    SKLabelNode* line1_2 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line1_2.text = @"to";
    line1_2.fontColor = line1_1.fontColor;
    line1_2.fontSize = line1_1.fontSize;
    [textLines addChild:line1_2];
    
    line1_1.position = CGPointMake(line1_1.frame.size.width / 2 - (line1_1.frame.size.width + line1_2.frame.size.width) / 2, 0);
    line1_2.position = CGPointMake(line1_1.frame.size.width - (line1_1.frame.size.width + line1_2.frame.size.width) / 2 + line1_2.frame.size.width / 2 + 2, 0);
    
    SKLabelNode* line2 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line2.text = @"change";
    line2.fontColor = line1_1.fontColor;
    line2.fontSize = line1_1.fontSize;
    line2.position = CGPointMake(0, -line1_1.frame.size.height);
    [textLines addChild:line2];
    
    gravLabel = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    gravLabel.text = @"gravity.";
    gravLabel.fontColor = line1_1.fontColor;
    gravLabel.fontSize = line1_1.fontSize;
    gravLabel.zPosition = textLines.zPosition;
    gravLabel.name = @"p1";
    gravLabel.position = CGPointMake(3 * self.frame.size.width / 4 + diff, self.frame.size.height / 2 - gravLabel.frame.size.height / 2);
    [self addChild:gravLabel];
    
    [self pulseObject:line1_1];
    [self enumerateChildNodesWithName:@"p1" usingBlock:^(SKNode* node, BOOL* stop){
        [self moveObject:node byX:-diff];
    }];
}

-(void)setupPhyArrBody {
    CGFloat offsetX = phyArr.frame.size.width * phyArr.anchorPoint.x;
    CGFloat offsetY = phyArr.frame.size.height * phyArr.anchorPoint.y;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 25 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 50 - offsetY);
    CGPathCloseSubpath(path);
    phyArr.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    phyArr.physicsBody.affectedByGravity = YES;
    phyArr.physicsBody.dynamic = YES;
    phyArr.physicsBody.restitution = 0.3;
    phyArr.physicsBody.linearDamping = 0.0;
    phyArr.physicsBody.friction = 0.0;
    CGPathRelease(path);
}

-(void)setupPhyBarriers {
    SKNode* bottom = [SKNode node];
    SKNode* top = [SKNode node];
    bottom.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(self.frame.size.width, 0)];
    top.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, self.frame.size.height) toPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [self addChild:bottom];
    [self addChild:top];
}

-(void)setupPage2WithDirection:(char)dir {
    CGFloat diff;
    if (dir == 'l') {
        diff = -xDiff;
    } else {
        diff = xDiff;
    }
    
    SKSpriteNode* bottom = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_spikes_bottom"]];
    bottom.name = @"p2";
    bottom.zPosition = 8.0;
    bottom.anchorPoint = CGPointMake(0.5, 0.0);
    bottom.position = CGPointMake(self.frame.size.width / 2 + diff, 0.0);
    [self addChild:bottom];
    
    SKSpriteNode* top = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_spikes_top"]];
    top.name = bottom.name;
    top.zPosition = bottom.zPosition;
    top.anchorPoint = CGPointMake(0.5, 1.0);
    top.position = CGPointMake(self.frame.size.width / 2 + diff, self.frame.size.height);
    [self addChild:top];
    
    SKNode* textLines = [SKNode node];
    textLines.zPosition = 5.0;
    textLines.position = CGPointMake(self.frame.size.width / 2 + diff, self.frame.size.height / 2);
    textLines.name = @"p2";
    [self addChild:textLines];
    
    SKLabelNode* line1 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line1.text = @"Do not touch";
    line1.fontColor = [Global globals].TUT_COLOR;
    line1.fontSize = 25.0;
    line1.position = CGPointMake(0.0, line1.frame.size.height / 2 + 5);
    [textLines addChild:line1];
    
    SKLabelNode* line2 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line2.text = @"the spikes on the";
    line2.fontColor = line1.fontColor;
    line2.fontSize = line1.fontSize;
    line2.position = CGPointMake(0, -line2.frame.size.height / 2);
    [textLines addChild:line2];
    
    SKLabelNode* line3 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line3.text = @"top and bottom.";
    line3.fontColor = line1.fontColor;
    line3.fontSize = line1.fontSize;
    line3.position = CGPointMake(0, -3 * line3.frame.size.height / 2 - 5);
    [textLines addChild:line3];
    
    [self wiggleObject:bottom byAngle:0.5];
    [self wiggleObject:top byAngle:0.5];
    [self enumerateChildNodesWithName:@"p2" usingBlock:^(SKNode* node, BOOL* stop){
        [self moveObject:node byX:-diff];
    }];
}

-(void)setupPage3WithDirection:(char)dir {
    CGFloat diff;
    if (dir == 'l') {
        diff = -xDiff;
    } else {
        diff = xDiff;
    }
    
    SKSpriteNode* obst1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_task1"]];
    obst1.name = @"p3";
    obst1.zPosition = 8.0;
    obst1.position = CGPointMake(self.frame.size.width / 2 - 30 + diff, self.frame.size.height / 2 + 80);
    [self addChild:obst1];
    
    SKSpriteNode* obst2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_task2"]];
    obst2.name = obst1.name;
    obst2.zPosition = obst1.zPosition;
    obst2.position = CGPointMake(self.frame.size.width / 2 - 60 + diff, self.frame.size.height / 2 - 30);
    [self addChild:obst2];
    
    SKSpriteNode* obst3 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_task3"]];
    obst3.name = obst1.name;
    obst3.zPosition = obst1.zPosition;
    obst3.position = CGPointMake(self.frame.size.width / 2 + 70 + diff, self.frame.size.height / 2 - 30);
    [self addChild:obst3];
    
    SKNode* textLines1 = [SKNode node];
    textLines1.zPosition = 5.0;
    textLines1.position = CGPointMake(self.frame.size.width / 2 + diff, self.frame.size.height / 4 - 30);
    textLines1.name = @"p3";
    [self addChild:textLines1];
    
    SKNode* textLines2 = [SKNode node];
    textLines2.zPosition = textLines1.zPosition;
    textLines2.position = CGPointMake(self.frame.size.width / 2 + diff, 3 * self.frame.size.height / 4 + 60);
    textLines2.name = textLines1.name;
    [self addChild:textLines2];
    
    SKLabelNode* line1 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line1.text = @"At the same time";
    line1.fontColor = [Global globals].TUT_COLOR;
    line1.fontSize = 25.0;
    line1.position = CGPointMake(0.0, line1.frame.size.height / 2 + 5);
    [textLines1 addChild:line1];
    
    SKLabelNode* line2 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line2.text = @"concentrate and";
    line2.fontColor = line1.fontColor;
    line2.fontSize = line1.fontSize;
    line2.position = CGPointMake(0, -line2.frame.size.height / 2);
    [textLines1 addChild:line2];
    
    SKLabelNode* line3 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line3.text = @"solve the task.";
    line3.fontColor = line1.fontColor;
    line3.fontSize = line1.fontSize;
    line3.position = CGPointMake(0, -3 * line3.frame.size.height / 2 - 5);
    [textLines1 addChild:line3];
    
    SKLabelNode* line2_1 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line2_1.text = @"Try to avoid";
    line2_1.fontColor = [Global globals].TUT_COLOR;
    line2_1.fontSize = 25.0;
    line2_1.position = CGPointMake(0.0, 0.0);
    [textLines2 addChild:line2_1];
    
    SKLabelNode* line2_2 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line2_2.text = @"the obstacles.";
    line2_2.fontColor = line1.fontColor;
    line2_2.fontSize = line1.fontSize;
    line2_2.position = CGPointMake(0.0, -line2_1.frame.size.height);
    [textLines2 addChild:line2_2];
    
    [self wiggleObject:obst1 byAngle:1.5];
    [self wiggleObject:obst2 byAngle:1.5];
    [self wiggleObject:obst3 byAngle:1.5];
    [self enumerateChildNodesWithName:@"p3" usingBlock:^(SKNode* node, BOOL* stop){
        [self moveObject:node byX:-diff];
    }];
}

-(void)setupPage4WithDirection:(char)dir {
    CGFloat diff;
    if (dir == 'l') {
        diff = -xDiff;
    } else {
        diff = xDiff;
    }
    
    SKSpriteNode* arr = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_arrow"]];
    arr.name = @"p4";
    arr.zPosition = 10.0;
    arr.position = CGPointMake(self.frame.size.width / 4 + diff, self.frame.size.height / 2 + 70);
    arr.zRotation = 15.0/180.0 * M_PI;
    [self addChild:arr];
    
    SKSpriteNode* wall = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_wall"]];
    wall.name = @"p4";
    wall.zPosition = 8.0;
    wall.anchorPoint = CGPointMake(1.0, 0.5);
    wall.position = CGPointMake(self.frame.size.width + diff, self.frame.size.height / 2);
    [self addChild:wall];
    
    SKNode* textLines = [SKNode node];
    textLines.zPosition = 5.0;
    textLines.position = CGPointMake(self.frame.size.width / 2 + diff, self.frame.size.height - 30);
    textLines.name = @"p4";
    [self addChild:textLines];
    
    SKLabelNode* line1 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line1.text = @"Then find the correct";
    line1.fontColor = [Global globals].TUT_COLOR;
    line1.fontSize = 25.0;
    line1.position = CGPointMake(0.0, 0.0);
    [textLines addChild:line1];
    
    SKLabelNode* line2 = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    line2.text = @"answer to open the gate.";
    line2.fontColor = line1.fontColor;
    line2.fontSize = line1.fontSize;
    line2.position = CGPointMake(0, -line2.frame.size.height);
    [textLines addChild:line2];
    
    SKLabelNode* playNow = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    playNow.text = @"Play now";
    playNow.fontColor = [Global globals].TUT_COLOR;
    playNow.fontSize = 25.0;
    playNow.position = CGPointMake(self.frame.size.width - 110 + diff, 25);
    playNow.name = @"p4";
    [self addChild:playNow];
    
    [self wiggleObject:wall byAngle:0.5];
    SKAction* moveArr = [SKAction moveBy:CGVectorMake(100, 35) duration:2.0 / [Global globals].SPEED];
    SKAction* moveArrBack = [SKAction moveBy:CGVectorMake(-100, -35) duration:1.0 / [Global globals].SPEED];
    SKAction* fadeArr0 = [SKAction fadeAlphaTo:0.0 duration:2.0 / [Global globals].SPEED];
    SKAction* fadeArr1 = [SKAction fadeAlphaTo:1.0 duration:0.5];
    SKAction* seq1 = [SKAction sequence:@[[SKAction waitForDuration:0.5 / [Global globals].SPEED],moveArr,moveArrBack]];
    SKAction* seq2 = [SKAction sequence:@[fadeArr1,fadeArr0,[SKAction waitForDuration:1.0 / [Global globals].SPEED]]];
    [arr runAction:[SKAction repeatActionForever:seq1]];
    [arr runAction:[SKAction repeatActionForever:seq2]];
    [self enumerateChildNodesWithName:@"p4" usingBlock:^(SKNode* node, BOOL* stop){
        [self moveObject:node byX:-diff];
    }];
}

-(void)setupButtons {
    buttonNext = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_next"]];
    buttonNext.zPosition = 2.0;
    buttonNext.anchorPoint = CGPointMake(1.0, 0.0);
    buttonNext.position = CGPointMake(self.frame.size.width - 10, 10);
    buttonNext.name = @"next";
    [self addChild:buttonNext];
    
    buttonPrev = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tut_next"]];
    buttonPrev.zPosition = buttonNext.zPosition;
    buttonPrev.anchorPoint = buttonNext.anchorPoint;
    buttonPrev.position = CGPointMake(10, 10);
    buttonPrev.xScale = -1.0;
    buttonPrev.alpha = 0.0;
    buttonPrev.name = @"prevHidden";
    [self addChild:buttonPrev];
}

-(void)setupBackground {
    bg = [SKSpriteNode spriteNodeWithTexture:[[Global globals] textureNamed:@"tut_bg"]];
    bg.zPosition = 0.0;
    bg.anchorPoint = CGPointMake(0, 0);
    bg.position = CGPointMake(0, 0);
    [self addChild:bg];
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