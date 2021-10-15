//
//  GameOverScene.h
//  Gravitational
//
//  Created by Lennart Reiher on 23.06.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MyScene.h"

@protocol GameOverSceneDelegate <NSObject>
-(void)presentGameWithDirection:(int)dir;
-(void)presentMenu;
-(void)presentTutorial;
-(void)showLeaderboard;
-(void)showShareViewController;
-(void)sendGAIScreen:(NSString*)name;
-(void)showTutorialPrompt;
@end

@interface GameOverScene : MyScene
    
@property (weak) id <GameOverSceneDelegate> delegate;

-(void)switchToGame;

@end