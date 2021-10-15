//
//  Global.m
//  Gravitational
//
//  Created by Lennart Reiher on 29.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "Global.h"
#import "MKStoreManager.h"


@interface Global ()

@property (nonatomic,readwrite) NSString* LEADERBOARDID;

@property (nonatomic,readwrite) CGFloat SPEED;
@property (nonatomic,readwrite) CGFloat GRAVITY;

@property (nonatomic,readwrite) uint32_t ARROW_CAT;
@property (nonatomic,readwrite) uint32_t OBSTACLE_CAT;
@property (nonatomic,readwrite) uint32_t RESULT_CAT;
@property (nonatomic,readwrite) uint32_t DUMMY_CAT;

@property (nonatomic,readwrite) UIColor* BG_COLOR;
@property (nonatomic,readwrite) UIColor* FONT_COLOR;

@property (nonatomic,readwrite) NSString* FONT_NAME;

@end




@implementation Global


static Global* sharedGlobalHelper = nil;

+(Global*)globals {
    // dispatch_once will ensure that the method is only called once (thread-safe)
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        sharedGlobalHelper = [[Global alloc] init];
    });
    return sharedGlobalHelper;
}

-(id)init {
    
    _ADS = ![MKStoreManager isFeaturePurchased:REMOVEADSID];

    //_MUSICPLAYER = [[AVAudioPlayer alloc] init];
    
    _LEADERBOARDID = @"lr1.Gravitational.lb1";
    
    _SPEED = 1.0;
    _GRAVITY = -2.5;
    
    _ARROW_CAT = 0x1 << 0;
    _OBSTACLE_CAT = 0x1 << 1;
    _RESULT_CAT = 0x1 << 2;
    _DUMMY_CAT = 0x1 << 3;
    
    _BG_COLOR = [UIColor colorWithRed:255.0/255.0f green:214.0/255.0f blue:0.0f alpha:1.0f];
    _FONT_COLOR = [UIColor colorWithRed:189.0/255.0f green:26.0/255.0f blue:3.0/255.0f alpha:1.0];
    _TUT_COLOR = [UIColor colorWithRed:130.0/255.0f green:4.0/255.0f blue:2.0/255.0f alpha:1.0];
    
    _FONT_NAME = @"Bauhaus 93";
    
    return [super init];
}



#pragma mark Work

-(SKTexture*)textureNamed:(NSString*)fileName {
    if ([self isPhone]) {
        if ([self isWidescreen]) {
            fileName = [NSString stringWithFormat:@"%@_5",fileName];
        } else {
            fileName = [NSString stringWithFormat:@"%@_4",fileName];
        }
    } else {
        // TO BE EDITED
    }
    if (!([fileName hasPrefix:@"bg_overlay"] || [fileName hasPrefix:@"menu"] || [fileName hasPrefix:@"tut"])) {
        if (_ADS) {
            fileName = [NSString stringWithFormat:@"%@_ads",fileName];
        }
    }
    SKTexture* tex = [SKTexture textureWithImageNamed:fileName];
    return tex;
}

-(BOOL)isPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

-(BOOL)isWidescreen {
    return (IS_IPHONE5);
}

@end
