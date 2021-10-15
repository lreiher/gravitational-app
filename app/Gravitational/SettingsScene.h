//
//  SettingsScene.h
//  Gravitational
//
//  Created by Lennart Reiher on 31.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MyScene.h"

@protocol SettingsSceneDelegate <NSObject>
-(void)showAdsAtTop:(BOOL)top;
-(void)hideAds;
-(void)presentMenu;
-(void)removeAdsForever;
-(void)restorePreviousPurchases;
-(void)resetAllPurchases;
-(void)switchToAppStore;
-(void)sendMail;
-(void)sendGAIScreen:(NSString*)name;
@end

@interface SettingsScene : MyScene

@property (weak) id <SettingsSceneDelegate> delegate;

-(void)reactToSuccessfulPurchase;

@end
