//
//  SetCard.m
//  Matchismo
//
//  Created by Grant Mathews on 1/28/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SetCard.h"
#import "Card.h"

@implementation SetCard : Card

+ (NSArray *)validTypes {
    return @[@"▲", @"●", @"■"];
}

+ (NSUInteger)highestCount {
    return 3;
}

- (void)setType:(NSString *)type {
    if ([[self validTypes] containsObject:type]) {
        _type = type;
    }
}

- (void)setCount:(NSUInteger)count {
    if (count != 0 && count <= [self highestCount]) {
        _count = count;
    }
}

@end
