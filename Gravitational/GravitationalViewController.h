//
//  GravitationalViewController.h
//  Gravitational
//

//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

@import UIKit;
@import SpriteKit;
@import iAd;
@import GameKit;
#import "GADBannerViewDelegate.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "GameOverScene.h"
#import "SettingsScene.h"
#import "TutorialScene.h"

@interface GravitationalViewController : UIViewController <UIActionSheetDelegate, UIGestureRecognizerDelegate, ADBannerViewDelegate, GADBannerViewDelegate, MFMailComposeViewControllerDelegate, MenuSceneDelegate, GameSceneDelegate, GameOverSceneDelegate, SettingsSceneDelegate, TutorialSceneDelegate> {
    
}

@end