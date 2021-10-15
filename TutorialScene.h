//
//  TutorialScene.h
//  Gravitational
//
//  Created by Lennart Reiher on 11.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MyScene.h"

@protocol TutorialSceneDelegate <NSObject>
-(void)hideAds;
-(void)presentGameWithDirection:(int)dir;
-(void)sendGAIScreen:(NSString*)name;
@end

@interface TutorialScene : MyScene

@property (weak) id <TutorialSceneDelegate> delegate;

@end
