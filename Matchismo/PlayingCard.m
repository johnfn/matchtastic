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

- (int)match:(NSArray *)otherCards {
    if (otherCards.count == 0) return 0;
    
    int score = 0;
    PlayingCard *otherCard = [otherCards lastObject];
    
    if ([otherCard.suit isEqualToString:self.suit]) {
        score = SUIT_MATCH;
    } else if (otherCard.rank == self.rank) {
        score = RANK_MATCH;
    }
    
    if (otherCards.count == 1) {
        return score;
    }
    
    /*  We'll call it a match if every card in the array matches
        this card in the same way.
     
        This makes an implicit assumption that different ways to match
        will have different scores. If that's not true, this code will
        need to be modified. */
    
    for (Card *otherCard in otherCards) {
        if ([otherCard match:@[self]] == 0) return 0;
    }
    
    return score;
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
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"J", @"Q", @"K"];
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
