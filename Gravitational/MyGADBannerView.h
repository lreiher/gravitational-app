//
//  MyGADBannerView.h
//  Gravitational
//
//  Created by Lennart Reiher on 20.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface MyGADBannerView : GADBannerView

@property BOOL isLoaded;

-(void)moveToDestination;
-(void)moveToOrigin;

@end
