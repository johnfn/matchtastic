//
//  PlayingCard.m
//  Matchismo
//
//  Created by Grant Mathews on 1/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

+ (NSArray *)validSuits {
    return @[@"♥", @"♦", @"♣", @"♣"];
}

#define SUIT_MATCH 1
#define RANK_MATCH 4

+ (int)match:(NSArray *)cards {
    if (cards.count < 2) return 0;
    
    PlayingCard *firstCard = cards[0];
    PlayingCard *lastCard = cards[1];
    
    if ([firstCard.suit isEqualToString:lastCard.suit]) {
        return SUIT_MATCH;
    } else if (firstCard.rank == lastCard.rank) {
        return RANK_MATCH;
    }
    
    return 0;
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
    if ([PlayingCard.validSuits containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank > 0 && rank <= PlayingCard.maxRank) {
        _rank = rank;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

- (NSString *)contents {
    return [NSString stringWithFormat:@"%@ %@", [PlayingCard rankStrings][self.rank], self.suit];
}

- (NSString *)description {
    return self.contents;
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count - 1;
}

@end
