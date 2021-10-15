//
//  MyGADBannerView.m
//  Gravitational
//
//  Created by Lennart Reiher on 20.08.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "MyGADBannerView.h"

@implementation MyGADBannerView {
    CGPoint orig;
}

-(id)initWithAdSize:(GADAdSize)adSize origin:(CGPoint)origin {
    if (self = [super initWithAdSize:adSize origin:origin]) {
        orig = origin;
        self.adUnitID = @"ca-app-pub-4147360734415554/8202619825";
        self.isLoaded = false;
    }
    
    return self;
}

-(void)moveToDestination {
    
    if (orig.y < 0.0) {
        self.frame = CGRectMake(orig.x, 0.0, self.frame.size.width, self.frame.size.height);
    } else {
        self.frame = CGRectMake(0, orig.y, self.frame.size.width, self.frame.size.height);
    }
    self.alpha = 1.0;
}

-(void)moveToOrigin {
    
    self.frame = CGRectMake(orig.x, orig.y, self.frame.size.width, self.frame.size.height);
    self.alpha = 0.0;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

