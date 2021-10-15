//
//  Global.h
//  Gravitational
//
//  Created by Lennart Reiher on 29.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

@import Foundation;
@import AVFoundation;
@import SpriteKit;

#define IS_IPHONE5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

@interface Global : NSObject

// Global variables

@property (nonatomic) BOOL ADS;

@property (nonatomic) NSUserDefaults* USERDEFAULTS;

@property (nonatomic) CGSize GAME_AREA;
@property (nonatomic) CGSize BANNER_AREA;

@property (nonatomic) NSInteger SCORE;
@property (nonatomic) NSInteger CORRECTANSWERSCOUNT;

@property (nonatomic) AVAudioPlayer* MUSICPLAYER;

// Constants

@property (nonatomic,readonly) NSString* LEADERBOARDID;

@property (nonatomic,readonly) CGFloat SPEED;
@property (nonatomic,readonly) CGFloat GRAVITY;

@property (nonatomic,readonly) uint32_t ARROW_CAT;
@property (nonatomic,readonly) uint32_t OBSTACLE_CAT;
@property (nonatomic,readonly) uint32_t RESULT_CAT;
@property (nonatomic,readonly) uint32_t DUMMY_CAT;

@property (nonatomic,readonly) UIColor* BG_COLOR;
@property (nonatomic,readonly) UIColor* FONT_COLOR;
@property (nonatomic,readonly) UIColor* TUT_COLOR;

@property (nonatomic,readonly) NSString* FONT_NAME;



// Methods

+(Global*)globals;

-(SKTexture*)textureNamed:(NSString*)fileName;
-(BOOL)isPhone;
-(BOOL)isWidescreen;

@end
