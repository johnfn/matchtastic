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
    if ([[SetCard validTypes] containsObject:type]) {
        _type = type;
    }
}

- (void)setCount:(NSUInteger)count {
    if (count != 0 && count <= [SetCard highestCount]) {
        _count = count;
    }
}

- (NSString *)description {
    NSMutableString *result;
    for (int i = 0; i < _count; i++) {
        [result appendString:_type];
    }
    
    return result;
}

@end
