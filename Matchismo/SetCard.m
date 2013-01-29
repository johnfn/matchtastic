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

+ (NSArray *)validCounts {
    return @[@1, @2, @3];
}

+ (NSArray *)validShadings {
    return @[@"Normal", @"Grayed", @"None"];
}

+ (NSArray *)validColors {
    return @[[UIColor greenColor], [UIColor redColor], [UIColor blueColor]];
}

+ (int)match:(NSArray *)cards {
    if (cards.count < 3) return 0;
    
    bool symbolMatch  = false;
    bool countMatch   = false;
    bool shadingMatch = false;
    bool colorMatch   = false;
    
    
}

- (void)setType:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void)setCount:(NSNumber *)count {
    if ([[SetCard validCounts] containsObject:count]) {
        _count = count;
    }
}

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [_count integerValue]; i++) {
        [result appendString:_symbol];
    }
    
    return result;
}

@end
