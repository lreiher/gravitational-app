//
//  GameScene.h
//  Gravitational
//

//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MyScene.h"

@protocol GameSceneDelegate <NSObject>
-(void)showAdsAtTop:(BOOL)top;
-(void)presentGameOver;
-(void)presentMenu;
-(void)sendGAIScreen:(NSString*)name;
@end

@interface GameScene : MyScene <SKPhysicsContactDelegate>

@property (weak) id <GameSceneDelegate> delegate;

-(void)reactToInterruption;
-(void)unpauseGame;
-(void)switchToMenu;

@end


