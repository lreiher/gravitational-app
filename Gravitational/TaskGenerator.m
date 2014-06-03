//
//  TaskGenerator.m
//  Gravitational
//
//  Created by Lennart Reiher on 18.05.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "TaskGenerator.h"

@implementation TaskGenerator

+ (NSString*)generate2DigitTask {
    NSString* task;
    
    int digit1 = arc4random() % 10 + 1;
    int digit2 = arc4random() % 10 + 1;
    
    int operator = arc4random() % 2;
    
    int result;
    
    if (operator > 0) {
        result = digit1 + digit2;
        task = [NSString stringWithFormat:@"%d%@%d%@%d",digit1,@" + ",digit2,@" = ",result];
    }
    else {
        result = digit1 - digit2;
        task = [NSString stringWithFormat:@"%d%@%d%@%d",digit1,@" - ",digit2,@" = ",result];
    }
    
    return task;
}

@end
