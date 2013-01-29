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

+ (NSArray *)validShadings {
    return @[@"Someshading"];
}

+ (NSArray *)validColors {
    return @[@0xff0000, @0x00ff00, @0x0000ff];
}

- (void)setType:(NSString *)symbol {
    if ([[SetCard validTypes] containsObject:symbol]) {
        _symbol = symbol;
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
        [result appendString:_symbol];
    }
    
    return result;
}

@end
