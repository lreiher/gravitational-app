//
//  MenuScene.m
//  Gravitational
//
//  Created by Lennart Reiher on 16.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

@implementation MenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKColor* backgroundColor = [SKColor whiteColor];
        [self setBackgroundColor:backgroundColor];
        
        SKLabelNode *labelName = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        labelName.text = @"Gravitational";
        labelName.fontSize = 40;
        labelName.fontColor = [SKColor blackColor];
        labelName.position = CGPointMake(self.size.width / 2, 7 * self.size.height / 8);
        [self addChild:labelName];

        SKLabelNode *playGameButton = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        playGameButton.text = @"Play Game";
        playGameButton.fontSize = 25;
        playGameButton.fontColor = [SKColor blackColor];
        playGameButton.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        playGameButton.name = @"play";
        [self addChild:playGameButton];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"play"]) {
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
        GameScene* scene = [GameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
}

@end
