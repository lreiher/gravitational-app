//  GameScene.m
//  Gravitational
//
//  Created by Lennart Reiher on 20.02.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "GameScene.h"

#import "MenuScene.h"
#import "GameOverScene.h"

#import "GCHelper.h"

#import "Arrow.h"
#import "Background.h"
#import "Ceiling.h"
#import "Floor.h"
#import "TaskGenerator.h"
#import "Wall.h"
#import "Obstacle.h"
/*-------------------------*/

@implementation GameScene {
    
    BOOL alive;
    BOOL paused;
    BOOL pausable;
    
    BOOL musicOn;
    BOOL soundOn;
    
    CGFloat gravity;
    
    SKNode* nodeForPausableActions;
    
    NSMutableArray* background;
    Floor* fl;
    Ceiling* cl;
    Arrow* arr;
    SKLabelNode* countdown;
    
    TaskGenerator* taskGenerator;
}

@synthesize delegate = _delegate;

#pragma mark Initializer

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        if ([Global globals].ADS) {
            [Global globals].GAME_AREA = CGSizeMake(size.width, size.height - [Global globals].BANNER_AREA.height);
        } else {
            [Global globals].GAME_AREA = size;
        }
        
        [self setupInitialValues];
        [self setupPhysicsWorld];
        [self setupNodeForPausableActions];
        [self setupBackground];
        [self setupFloor];
        [self setupCeiling];
        [self setupArrow];
        [self setupTaskGenerator];
        if ([Global globals].ADS) {[self setupAdPlaceholder];}
    }
    return self;
}



#pragma mark Delegate Methods

-(void)didMoveToView:(SKView *)view {
    
    arr.physicsBody.velocity = CGVectorMake(0, 0);
    [_delegate showAdsAtTop:YES];
    if (musicOn) {
        [Global globals].MUSICPLAYER.volume = 1.0;
        [self setupMusic];
    }
    
    [_delegate sendGAIScreen:@"Game Scene"];
}

-(void)update:(CFTimeInterval)currentTime {
    
    self.physicsWorld.gravity = CGVectorMake(0.0, gravity);
    
    if (alive) arr.position = CGPointMake([Global globals].GAME_AREA.width / 4, arr.position.y);  //stationary x-Position
    
    arr.physicsBody.velocity = CGVectorMake(0.0, arr.physicsBody.velocity.dy);    //no dx
    arr.physicsBody.angularVelocity = 0.0;
    
    arr.zRotation = 2 * (arr.position.y - [Global globals].GAME_AREA.height / 2) / ([Global globals].GAME_AREA.height - 100) * atan(0.5);
    
    [cl updateScore];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    
    if ([touchedNode.name isEqualToString:@"menu"]) {
        touchedNode.alpha = 0.5;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    [fl childNodeWithName:@"menu"].alpha = 0.0;
    
    CGPoint touchPos = [[touches anyObject] locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPos];
    
    if ([touchedNode.name isEqualToString:@"pause"]) {
        if (!paused && pausable && alive) {
            [self pauseGame];
        } else if (paused) {
            [self unpauseGame];
        }
    }
    else if ([touchedNode.name isEqualToString:@"menu"]) {
        [self switchToMenu];
    }
    else if (!paused) {
        gravity = -gravity;
        if (soundOn) {
            [self runAction:[SKAction playSoundFileNamed:@"soundGravity.caf" waitForCompletion:NO]];
        }
    }
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    [fl childNodeWithName:@"menu"].alpha = 0.0;
    
    CGPoint trans = [recognizer translationInView:recognizer.view];
    CGPoint veloc = [recognizer velocityInView:recognizer.view];
    
    if (paused && recognizer.state == UIGestureRecognizerStateChanged) {
        [fl handlePanDownWithTranslation:trans andVelocity:veloc];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    } else if (paused && recognizer.state == UIGestureRecognizerStateEnded) {
        if (veloc.y > 550.0) {
            [fl handleQuickSwipeWithTranslation:trans andVelocity:veloc];
        } else if ([fl needsToBeUnpaused]) {
            [self unpauseGame];
        }
    } 
}

-(void)didBeginContact:(SKPhysicsContact*)contact {
    
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask == [Global globals].ARROW_CAT) && (secondBody.categoryBitMask == [Global globals].OBSTACLE_CAT)) {
        [self computeCollisionWithObstacle:(Obstacle*)secondBody.node];
    } else if ((firstBody.categoryBitMask == [Global globals].ARROW_CAT) && (secondBody.categoryBitMask == [Global globals].RESULT_CAT)) {
        [self computeCollisionWithResult:secondBody.node];
    }
}

#pragma mark Work

-(void)reactToInterruption {
    if (!paused && alive) {
        [self pauseGame];
        if (countdown.parent != nil) {
            [countdown removeFromParent];
        }
    }
    if ([[Global globals].USERDEFAULTS integerForKey:@"bestScore"] < [Global globals].SCORE) {
        [[Global globals].USERDEFAULTS setInteger:[Global globals].SCORE forKey:@"bestScore"];
        [[Global globals].USERDEFAULTS synchronize];
    }
}

-(void)pauseGame {
    
    paused = true;
    pausable = true;
    
    [self removeActionForKey:@"waitThenUnpause"];
    
    self.physicsWorld.speed = 0.0;
    
    [self enumerateChildNodesWithName:@"obstaclePausable"
                           usingBlock:^(SKNode* node, BOOL* stop) {
        node.paused = true;
        node.speed = 0.0;
        node.alpha = 0.0;
    }];
    
    [arr animatePause:false
             duration:0.5];
    [arr animatePause:true duration:0.5];
    [fl animatePause:true
            duration:0.5];
    [cl animatePause:true
            duration:0.5];
}

-(void)unpauseGame {
    
    paused = false;
    pausable = false;
    
    [arr animatePause:false
             duration:0.5];
    [fl animatePause:false
            duration:0.5];
    [cl animatePause:false
            duration:0.5];
    
    [self setupCountdown];
    
    SKAction* wait = [SKAction waitForDuration:3.5 / [Global globals].SPEED];
    
    void (^unpauseBlock)(void) = ^{
        //might have been paused again by going to background
        if (!paused) {
            NSLog(@"unpauseBlock");
            [self enumerateChildNodesWithName:@"obstaclePausable" usingBlock:^(SKNode* node, BOOL* stop) {
                node.paused = false;
                node.speed = 1.0;
                [node runAction:[SKAction fadeAlphaTo:1.0 duration:0.5 / [Global globals].SPEED]];
            }];
            
            arr.physicsBody.categoryBitMask = [Global globals].ARROW_CAT;
            arr.physicsBody.velocity = CGVectorMake(0.0, 0.0);
            self.physicsWorld.speed = [Global globals].SPEED;
            
            paused = false;
            pausable = true;
        } else {
            NSLog(@"did not run unpause block");
        }
    };
    
    SKAction* unpause = [SKAction runBlock:unpauseBlock];
    
    SKAction* waitThenUnpause = [SKAction sequence:@[wait,unpause]];
    
    [self runAction:waitThenUnpause withKey:@"waitThenUnpause"];
}

-(void)startCountdownWithInitialFontSize:(NSInteger)fs {
    
    [countdown runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:0.5 / [Global globals].SPEED],
                                              [SKAction runBlock:^{
        countdown.alpha = 1.0;
        for (int i = 1; i < countdown.fontSize * 3; i++) {
            [countdown runAction:[SKAction sequence:@[
                                                      [SKAction waitForDuration:i/(countdown.fontSize * [Global globals].SPEED)],
                                                      [SKAction runBlock:^{
                countdown.fontSize = countdown.fontSize - 1;
                if(i == fs - 1) {
                    countdown.text = @"2";
                    countdown.fontSize = fs;
                } else if (i == 2 * (fs - 1)) {
                    countdown.text = @"1";
                    countdown.fontSize = fs;
                }}
                                                       ]]]];
        }}],
                                              [SKAction waitForDuration:3.0 / [Global globals].SPEED],
                                              [SKAction removeFromParent]]]];
}










-(void)computeCollisionWithObstacle:(Obstacle*)pObstacle {
    
    alive = false;
    NSLog(@"YOU LOST: HIT OBSTACLE");
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"ArrowBurst" ofType:@"sks"];
    SKEmitterNode *burstNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    burstNode.position = arr.position;
    burstNode.zPosition = 100.0;
    [self addChild:burstNode];
    [arr removeFromParent];
    if (soundOn) {
        SKAction* sound = [SKAction playSoundFileNamed:@"soundCrash.caf" waitForCompletion:NO];
        [self runAction:sound];
    }
    nodeForPausableActions.paused = true;
    nodeForPausableActions.speed = 0.0;
    [self handleGameOverDueToSpikes:YES];
}

-(void)computeCollisionWithResult:(SKNode*)pResultNode {
    if ([pResultNode.name hasPrefix:@"correct"]) {
        if (soundOn) {
            SKAction* sound = [SKAction playSoundFileNamed:@"soundCorrect.caf" waitForCompletion:NO];
            [self runAction:sound];
        }
        [(Wall*)pResultNode.parent letWallDisappear:pResultNode];
        [Global globals].CORRECTANSWERSCOUNT = [Global globals].CORRECTANSWERSCOUNT + 1;
        pResultNode.name = @"alreadTouchedCorrect";
    } else if ([pResultNode.name isEqualToString:@"wrong"]) {
        alive = false;
        NSLog(@"YOU LOST: WRONG RESULT");
        if (soundOn) {
            SKAction* sound = [SKAction playSoundFileNamed:@"soundWrong.caf" waitForCompletion:NO];
            [self runAction:[SKAction sequence:@[sound,[SKAction waitForDuration:0.3],sound]]];
        }
        [pResultNode runAction:[SKAction fadeAlphaTo:0.0 duration:0.75 / [Global globals].SPEED]];
        [self handleGameOverDueToSpikes:NO];
        pResultNode.name = @"alreadyTouchedWrong";
    }
}

-(void)handleGameOverDueToSpikes:(BOOL)boolSpikes {
    
    if (boolSpikes) {
        [self switchToGameOverAfterDelay:1.0];
    } else {
        [self switchToGameOverAfterDelay:3.0];
    }
    
    if ([[Global globals].USERDEFAULTS integerForKey:@"bestScore"] < [Global globals].SCORE) {
        [[Global globals].USERDEFAULTS setInteger:[Global globals].SCORE forKey:@"bestScore"];
        [[Global globals].USERDEFAULTS synchronize];
    }
    
    [[GCHelper defaultHelper] reportScore:[[Global globals].USERDEFAULTS integerForKey:@"bestScore"] forLeaderboardID:[Global globals].LEADERBOARDID];
}

-(void)switchToGameOverAfterDelay:(double)pDelay {
    if (musicOn) {
        [Global globals].MUSICPLAYER.volume = 0.05;
    }
    [self runAction:
                    [SKAction sequence:
                                        @[[SKAction waitForDuration:pDelay / [Global globals].SPEED],
                                          [SKAction runBlock:^{
                                                                [_delegate presentGameOver];
                    }]]]];
    
}

-(void)switchToMenu {
    [[Global globals].MUSICPLAYER stop];
    [_delegate presentMenu];
}







-(NSMutableArray*)operasFromTask:(NSString*)pTask {
    
    NSString* taskNoResult = [[pTask componentsSeparatedByString:@"="] objectAtIndex:0];
    NSLog(@"%@",taskNoResult);
    NSMutableArray* operas = [[NSMutableArray alloc] init];
    NSInteger lastSpaceAt = -1;
    for (int i = 0; i < taskNoResult.length; i++) {
        if ([taskNoResult characterAtIndex:i] == ' ') {
            [operas addObject:[[taskNoResult substringFromIndex:lastSpaceAt + 1] substringToIndex:i - (lastSpaceAt + 1)]];
            lastSpaceAt = i;
        }
    }
    return operas;
}

-(NSMutableArray*)resultsFromTask:(NSString*)pTask {
    
    NSString* resultOnly = [[pTask componentsSeparatedByString:@"="] objectAtIndex:1];
    NSString* noSpaces = [resultOnly stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (int i = 0; i < [noSpaces componentsSeparatedByString:@","].count; i++) {
        [results addObject:[[noSpaces componentsSeparatedByString:@","] objectAtIndex:i]];
    }
    return results;
}

-(void)newObstaclesWithOperas:(NSMutableArray*)pOperas {
    
    for (int i = 0; i < pOperas.count; i++) {
        SKAction* wait = [SKAction waitForDuration:3.0 * i / [Global globals].SPEED];
        SKAction* create = [SKAction runBlock:^{
            CGFloat yPos = (arc4random_uniform(601) + 200) / 1000.0 * [Global globals].GAME_AREA.height;     //yPos 20%-80%
            Obstacle* obst = [Obstacle obstacleWithYPosition:yPos andString:[pOperas objectAtIndex:i]];
            [self addChild:obst];
            SKAction* waitBeforeRemoval = [SKAction waitForDuration:6.0 / [Global globals].SPEED];
            SKAction* remove = [SKAction removeFromParent];
            [obst runAction:[SKAction sequence:@[waitBeforeRemoval,remove]]];
        }];
        [nodeForPausableActions runAction:[SKAction sequence:@[wait,create]]];
    }
}
         
-(void)newWallWithResults:(NSMutableArray*)pResults afterOperas:(NSInteger)pOps {
    
    SKAction* wait = [SKAction waitForDuration:(3.0 * pOps + 1.0)/ [Global globals].SPEED];
    SKAction* create = [SKAction runBlock:^{
        Wall* w = [Wall wallWithResults:pResults];
        [self addChild:w];
    }];
    [nodeForPausableActions runAction:[SKAction sequence:@[wait,create]]];
}

-(void)newTask {
    
    if (alive) {
        NSString* task = [taskGenerator newTask];
        
        NSMutableArray* operas = [self operasFromTask:task];
        
        [self newObstaclesWithOperas:operas];
        
        NSMutableArray* results = [self resultsFromTask:task];
        
        [self newWallWithResults:results afterOperas:operas.count];
    }
}
















#pragma mark Setup

-(void)setupInitialValues {
    
    alive = true;
    paused = false;
    pausable = true;
    musicOn = [[Global globals].USERDEFAULTS boolForKey:@"music"];
    soundOn = [[Global globals].USERDEFAULTS boolForKey:@"sounds"];
    [Global globals].SCORE = 0;
    [Global globals].CORRECTANSWERSCOUNT = 0;
}

-(void)setupPhysicsWorld {
    
    gravity = [Global globals].GRAVITY;
    self.physicsWorld.gravity = CGVectorMake(0, gravity);
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.speed = [Global globals].SPEED;
}

-(void)setupNodeForPausableActions {
    
    nodeForPausableActions = [SKNode node];
    nodeForPausableActions.name = @"obstaclePausable";
    [self addChild:nodeForPausableActions];
}

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
    [self addChild:fl];
}

-(void)setupCeiling {
    
    cl = [Ceiling ceilingWithPosition:CGPointMake(0, [Global globals].GAME_AREA.height)];
    [self addChild:cl];
}

-(void)setupArrow {
    
    arr = [Arrow arrowWithPosition:CGPointMake([Global globals].GAME_AREA.width / 4, [Global globals].GAME_AREA.height / 2) andPhysicsBody:YES];
    [self addChild:arr];
}

-(void)setupTaskGenerator {
    
    taskGenerator = [TaskGenerator initTaskGenerator];
    SKAction* generateNewTaskPeriodically = [SKAction repeatActionForever:
                                             [SKAction sequence:@[
                                                                  [SKAction waitForDuration:1.0 / [Global globals].SPEED],
                                                                  [SKAction performSelector:@selector(newTask)
                                                                                   onTarget:self],
                                                                  [SKAction waitForDuration:12.5 / [Global globals].SPEED]]]];
    
    SKAction* increaseScore = [SKAction repeatActionForever:
                               [SKAction sequence:@[
                                                    [SKAction waitForDuration:0.1 / [Global globals].SPEED],
                                                    [SKAction runBlock:
                                                     ^{ if(alive) [Global globals].SCORE = [Global globals].SCORE + 1; }]]]];
    
    [nodeForPausableActions runAction:generateNewTaskPeriodically];
    [nodeForPausableActions runAction:increaseScore];
}

-(void)setupAdPlaceholder {
    SKSpriteNode* adPlaceholder = [SKSpriteNode spriteNodeWithColor:[Global globals].FONT_COLOR
                                                               size:[Global globals].BANNER_AREA];
    adPlaceholder.anchorPoint = CGPointMake(0, 0);
    adPlaceholder.position = CGPointMake(0, [Global globals].GAME_AREA.height);
    adPlaceholder.zPosition = 20.0;
    [self addChild:adPlaceholder];
}

-(void)setupCountdown {
    countdown = [SKLabelNode labelNodeWithFontNamed:[Global globals].FONT_NAME];
    NSInteger fs = 70;
    countdown.fontSize = fs;
    countdown.fontColor = [Global globals].FONT_COLOR;
    countdown.position = CGPointMake([Global globals].GAME_AREA.width / 2, [Global globals].GAME_AREA.height / 2);
    countdown.text = @"3";
    countdown.alpha = 0.0;
    [self addChild:countdown];
    
    [self startCountdownWithInitialFontSize:fs];
}

-(void)setupMusic {
    
    if (![[Global globals].MUSICPLAYER.url.resourceSpecifier hasSuffix:@"backgroundInGame.mp3"]) {
        [Global globals].MUSICPLAYER = [[Global globals].MUSICPLAYER initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"backgroundInGame"
                                                                                                                   withExtension:@"mp3"]
                                                                                     error:nil];
        [Global globals].MUSICPLAYER.numberOfLoops = -1;
        [[Global globals].MUSICPLAYER prepareToPlay];
        [[Global globals].MUSICPLAYER play];
    }
}

@end
