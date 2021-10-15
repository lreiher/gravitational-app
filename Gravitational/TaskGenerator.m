//
//  TaskGenerator.m
//  Gravitational
//
//  Created by Lennart Reiher on 18.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

/*-------------------------*/
#import "TaskGenerator.h"
/*-------------------------*/

@implementation TaskGenerator {
    NSArray* tasks10PlusMinus;
    NSArray* tasks100PlusMinus;
    NSArray* tasks10Mult;
    NSArray* tasks100Mult;
}

#pragma mark Initializer

+(id)initTaskGenerator {
    return [[TaskGenerator alloc] init];
}

-(id)init {
    if (self = [super init]) {
        [self loadResources];
    }
    
    return self;
}

#pragma mark Work

-(NSString*)newTask {
    
    NSInteger c = [Global globals].CORRECTANSWERSCOUNT;
    NSString* task;

    if (c < 2) {
        task = [self new10PlusMinus];
    } else if (c < 5) {
        task = [self new10Mult];
    } else if (c < 12) {
        task = [self new100PlusMinus];
    } else if (c < 13) {
        task = [self new100Mult];
    } else {
        NSInteger z = arc4random_uniform(5);
        if (z == 0) {
            task = [self new100Mult];
        } else {
            task = [self new100PlusMinus];
        }
    }
    
    return task;
}

-(NSString*)new10PlusMinus {
    NSInteger lineOfNewTask = (NSInteger)arc4random_uniform((int)tasks10PlusMinus.count);
    NSLog(@"%@",tasks10PlusMinus[lineOfNewTask]);
    return tasks10PlusMinus[lineOfNewTask];
}
-(NSString*)new100PlusMinus {
    NSInteger lineOfNewTask = (NSInteger)arc4random_uniform((int)tasks100PlusMinus.count);
    NSLog(@"%@",tasks100PlusMinus[lineOfNewTask]);
    return tasks100PlusMinus[lineOfNewTask];
}
-(NSString*)new10Mult {
    NSInteger lineOfNewTask = (NSInteger)arc4random_uniform((int)tasks10Mult.count);
    NSLog(@"%@",tasks10Mult[lineOfNewTask]);
    return tasks10Mult[lineOfNewTask];
}
-(NSString*)new100Mult {
    NSInteger lineOfNewTask = (NSInteger)arc4random_uniform((int)tasks100Mult.count);
    NSLog(@"%@",tasks100Mult[lineOfNewTask]);
    return tasks100Mult[lineOfNewTask];
}

#pragma mark Setup

-(void)loadResources {
    [self load10PlusMinus];
    [self load100PlusMinus];
    [self load10Mult];
    [self load100Mult];
}

-(void)load10PlusMinus {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tasks10PlusMinus" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    tasks10PlusMinus = [content componentsSeparatedByString:@"\n"];
}

-(void)load100PlusMinus {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tasks100PlusMinus" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    tasks100PlusMinus = [content componentsSeparatedByString:@"\n"];
}

-(void)load10Mult {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tasks10Mult" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    tasks10Mult = [content componentsSeparatedByString:@"\n"];
}

-(void)load100Mult {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tasks100Mult" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    tasks100Mult = [content componentsSeparatedByString:@"\n"];
}

@end
