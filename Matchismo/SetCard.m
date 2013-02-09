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
    return @[@"♢", @"●", @"~"];
}

+ (NSArray *)validCounts {
    return @[@1, @2, @3];
}

+ (NSArray *)validShades {
    return @[@0, @1, @2];
}

+ (NSArray *)validColors {
    return @[[UIColor greenColor], [UIColor redColor], [UIColor blueColor]];
}

#define MATCH_SCORE 30

+ (int)match:(NSArray *)cards {
    if (cards.count < 3) return 0;
    
    // We could tighten this up even more by having an NSArray of NSArrays. I opted not to do it
    // because you'd only really want to do that if you planned to later add more attributes to
    // a set card, and I don't see that happening.
    
    bool symbolMatch  = false;
    bool countMatch   = false;
    bool shadingMatch = false;
    bool colorMatch   = false;
    
    // I dug this trick up on StackOverflow:
    // http://stackoverflow.com/questions/2969349/getting-unique-items-from-nsmutablearray
    
    NSArray *uniqueSymbol = [cards valueForKeyPath:@"@distinctUnionOfObjects.symbol"];
    NSArray *uniqueCounts = [cards valueForKeyPath:@"@distinctUnionOfObjects.count"];
    NSArray *uniqueShades = [cards valueForKeyPath:@"@distinctUnionOfObjects.shading"];
    NSArray *uniqueColors = [cards valueForKeyPath:@"@distinctUnionOfObjects.color"];
    
    symbolMatch  = uniqueSymbol.count == 1 || uniqueSymbol.count == 3;
    countMatch   = uniqueCounts.count == 1 || uniqueCounts.count == 3;
    shadingMatch = uniqueShades.count == 1 || uniqueShades.count == 3;
    colorMatch   = uniqueColors.count == 1 || uniqueColors.count == 3;
    
    if (symbolMatch && countMatch && shadingMatch && colorMatch) {
        return MATCH_SCORE;
    }
    
    return 0;
}

- (void)setType:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void)setColor:(UIColor *)color {
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
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
