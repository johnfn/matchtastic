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

+ (NSArray *)validSymbols {
    return @[@"▲", @"●", @"■"];
}

+ (NSUInteger)highestCount {
    return 3;
}

+ (NSArray *)validShadings {
    return @[@"Normal", @"Grayed", @"None"];
}

+ (NSArray *)validColors {
    return @[[UIColor greenColor], [UIColor redColor], [UIColor blueColor]];
}

- (void)setType:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void)setCount:(NSUInteger)count {
    if (count != 0 && count <= [SetCard highestCount]) {
        _count = count;
    }
}

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < _count; i++) {
        [result appendString:_symbol];
    }
    
    return result;
}

@end
