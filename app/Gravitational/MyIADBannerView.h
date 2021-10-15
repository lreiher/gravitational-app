//
//  MyIADBannerView.h
//  Gravitational
//
//  Created by Lennart Reiher on 20.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <iAd/iAd.h>

@interface MyIADBannerView : ADBannerView 

-(id)initWithAdType:(ADAdType)type origin:(CGPoint)origin;

-(void)moveToDestination;
-(void)moveToOrigin;

@end
