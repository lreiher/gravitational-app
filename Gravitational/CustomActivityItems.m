//
//  CustomActivityItems.m
//  Gravitational
//
//  Created by Lennart Reiher on 02.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "CustomActivityItems.h"

@implementation CustomActivityItems

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    int score = (int)[Global globals].SCORE;
    int bestScore = (int)[[Global globals].USERDEFAULTS integerForKey:@"bestScore"];
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] ) {
        NSString* messageTW = [NSString stringWithFormat:@"Can you beat my personal best of %d points? I just scored %d points on Gravitational! @graviational_a",bestScore,score];
        return messageTW;
    }
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] ) {
        NSString* messageFB = [NSString stringWithFormat:@"Can you beat my personal best of %d points? I just scored %d points on Gravitational! Check out facebook.com/gravitationalapp",bestScore,score];
        return messageFB;
    }
    if ( [activityType isEqualToString:UIActivityTypeMessage] ) {
        NSString* messageSMS = [NSString stringWithFormat:@"Can you beat my personal best of %d points? I just scored %d points on Gravitational! Check out gravitational-app.com",bestScore,score];
        return messageSMS;
    }
    if ( [activityType isEqualToString:UIActivityTypeMail] ) {
        NSString* messageM = [NSString stringWithFormat:@"Can you beat my personal best of %d points? I just scored %d points on Gravitational! Check out gravitational-app.com",bestScore,score];
        return messageM;
    }
    return nil;
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end