//
//  MenuScene.h
//  Gravitational
//
//  Created by Lennart Reiher on 16.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MyScene.h"

@protocol MenuSceneDelegate <NSObject>
-(void)hideAds;
-(void)presentGameWithDirection:(int)dir;
-(void)presentSettings;
-(void)presentTutorial;
-(void)showLeaderboard;
-(void)sendGAIScreen:(NSString*)name;
@end

@interface MenuScene : MyScene
    
@property (weak) id <MenuSceneDelegate> delegate;

-(void)switchToGame;

@end
