//  GameScene.m
//  Gravitational
//
//  Created by Lennart Reiher on 20.02.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "GameScene.h"
#import "TaskGenerator.h"
#import "Arrow.h"
#import "Floor.h"
#import "Background.h"
#import "PauseButton.h"
#import "TaskObstacle.h"


@implementation GameScene

//instance variables

CGSize gameArea;

SKLabelNode* taskLabel;

SKSpriteNode* arrow;
SKSpriteNode* floorsOverlay;

CGFloat gravity = -2.5;

//for collision detection
static const uint32_t arrowCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        [self setupSceneWithSize:size];
        
    }
    return self;
}



-(void)setupSceneWithSize:(CGSize)pSize {
    NSInteger bannerHeight = 50;
    
    gameArea = CGSizeMake(pSize.width, pSize.height - bannerHeight);
    
    self.physicsWorld.gravity = CGVectorMake(0, gravity);
    
    self.physicsWorld.contactDelegate = self;
    
    self.backgroundColor = [SKColor whiteColor];
    [self animateBackground];
    [self animateFloors];
    
    SKSpriteNode* pauseButton = [PauseButton pauseButtonWithPosition:CGPointMake(gameArea.width - [SKTexture textureWithImageNamed:@"pause"].size.width / 2 - 5, gameArea.height - [SKTexture textureWithImageNamed:@"pause"].size.height / 2 - 4)];
    [self addChild:pauseButton];
    
    arrow = [Arrow arrowWithPosition:CGPointMake(gameArea.width / 2, gameArea.height / 2)];
    arrow.physicsBody.categoryBitMask = arrowCategory;
    arrow.physicsBody.contactTestBitMask = obstacleCategory;
    arrow.physicsBody.collisionBitMask = 1;
    [self addChild:arrow];
    

    
    NSString* task = [TaskGenerator generate2DigitTask];
    NSLog(@"%@", task);
    [self generateAllTaskObstaclesWithTask:task];

    
}



-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    
    self.physicsWorld.gravity = CGVectorMake(0, gravity);   //react to a change in gravity
    
    arrow.position = CGPointMake(gameArea.width / 4, arrow.position.y);  //stationary x-Position
    arrow.physicsBody.velocity = CGVectorMake(0, arrow.physicsBody.velocity.dy);    //no dx
    arrow.physicsBody.angularVelocity = 0.0;
    arrow.zRotation = 2 * (arrow.position.y - gameArea.height / 2) / (gameArea.height - 2 * floorsOverlay.size.height) * atan(0.5);
    
    //overlay for inactive floor
    if (gravity > 0) {
        floorsOverlay.position = CGPointMake(gameArea.width / 2, floorsOverlay.size.height / 2);
    } else {
        floorsOverlay.position = CGPointMake(gameArea.width / 2, gameArea.height - floorsOverlay.size.height / 2);
    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Called when a touch begins
    
    //checks for pause-button
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKNode* pauseNode = [self nodeAtPoint:touchLocation];
    if ([pauseNode.name isEqualToString:@"pauseGame"]) {
        self.view.paused = !self.view.paused;
    }
    else if (!self.view.paused) {
        gravity = -gravity;
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
    
    if ((firstBody.categoryBitMask == arrowCategory) && (secondBody.categoryBitMask == obstacleCategory)) {
        [self computeCollisionBetweenArrow:(SKSpriteNode*)firstBody.node andObstacle:(SKSpriteNode*)secondBody.node];
    }
}




-(void)computeCollisionBetweenArrow:(SKSpriteNode*)pArrow andObstacle:(SKSpriteNode*)pObstacle {
    NSLog(@"Hit");
    
    //burst effect
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"ArrowBurst" ofType:@"sks"];
    SKEmitterNode *burstNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    burstNode.position = arrow.position;
    burstNode.zPosition = 100.0;
    //[pArrow removeFromParent];
    [self addChild:burstNode];
}



-(void)generateAllTaskObstaclesWithTask:(NSString*)pTask {
    //put single characters of task into array
    NSString* taskWithoutResult = [[pTask componentsSeparatedByString:@"="] objectAtIndex:0];
    NSMutableArray* characters = [[NSMutableArray alloc] initWithCapacity:[taskWithoutResult length]];
    for (int i = 0; i < [taskWithoutResult length]; ++i) {
        if ([taskWithoutResult characterAtIndex:i] != ' ') {
            if ([taskWithoutResult characterAtIndex:i+1] == ' ') {
                [characters addObject:[NSString stringWithFormat:@"%c",[taskWithoutResult characterAtIndex:i]]];
            } else {
                [characters addObject:[NSString stringWithFormat:@"%c%c",[taskWithoutResult characterAtIndex:i],[taskWithoutResult characterAtIndex:i+1]]];
                i += 1;
            }
        }
    }
    
    //generate obstacles
    for (int i = 0; i < [characters count]; ++i) {
        [self performSelector:@selector(generateSingleObstacleWithSymbol:) withObject:[characters objectAtIndex:i] afterDelay: 5 * i];
    }
}

-(void)generateSingleObstacleWithSymbol:(NSString*)pSymbol {
    CGFloat xPos = gameArea.width;
    CGFloat yPos = (arc4random() % 601 + 200) / 1000.0 * gameArea.height;
    SKSpriteNode* obstacle = [TaskObstacle taskObstacleWithSymbol:pSymbol andPosition:CGPointMake(xPos, yPos) andScale:1];
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    obstacle.physicsBody.contactTestBitMask = arrowCategory;
    obstacle.physicsBody.collisionBitMask = 0;
    [self addChild:obstacle];
}



-(void)animateBackground {
    SKAction* moveBackground = [SKAction moveByX:-gameArea.width / 2 y:0 duration:30.0];
    SKAction* resetBackground = [SKAction moveByX:gameArea.width / 2 y:0 duration:0.0];
    SKAction* animateBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBackground,resetBackground]]];
    
    for (int i = 0; i < 3; ++i) {
        SKSpriteNode* background = [Background backgroundWithPosition:CGPointMake(gameArea.width * i, self.frame.size.height / 2)];
        
        [background runAction:animateBackgroundForever];
        
        [self addChild:background];
    }
}



-(void)animateFloors {
    SKAction* moveFloors = [SKAction moveByX:-gameArea.width y:0 duration:20.0];
    SKAction* resetFloors = [SKAction moveByX:gameArea.width y:0 duration:0.0];
    SKAction* animateFloorsForever = [SKAction repeatActionForever:[SKAction sequence:@[moveFloors,resetFloors]]];
    
    for (int i = 0; i < 3; ++i) {
        SKSpriteNode* floor = [Floor floorWithPosition:CGPointMake(gameArea.width * i, [SKTexture textureWithImageNamed:@"floor"].size.height / 2) andScale:1.0];
        SKSpriteNode* ceiling = [Floor floorWithPosition:CGPointMake(gameArea.width * i, gameArea.height - floor.size.height / 2) andScale:-1.0];
        
        [floor runAction:animateFloorsForever];
        [ceiling runAction:animateFloorsForever];
        
        [self addChild:floor];
        [self addChild:ceiling];
        
        //overlay for inactive floor
        if (i == 0) {
            floorsOverlay = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithWhite:1 alpha:0.75] size:CGSizeMake(floor.size.width, floor.size.height - 2.5)];
            floorsOverlay.zPosition = 35.0;
            [self addChild:floorsOverlay];
        }
    }
}

@end
