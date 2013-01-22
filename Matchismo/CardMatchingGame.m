//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Grant Mathews on 1/21/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (nonatomic) bool isTripleMatchGame;
@property (readwrite, nonatomic) bool hasGameBegun;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            
            if (!card) return nil;
            
            self.cards[i] = card;
        }
    }
    
    return self;
}

- (void)setGameType:(bool)tripleMatch {
    if (self.hasGameBegun) return;
    
    self.isTripleMatchGame = tripleMatch;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (void)calculateScorePair:(Card *)card {
    self.lastFlipResult = [NSString stringWithFormat:@"Flipped %@", card];
    
    for (Card *otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            int matchScore = [card match:@[otherCard]];
            int score = 0;
            
            if (matchScore) {
                otherCard.unplayable = YES;
                card.unplayable = YES;
                score = matchScore * MATCH_BONUS;
                
                self.score += score;
                self.lastFlipResult = [NSString stringWithFormat:@"%@ and %@ match! +%d points.", card, otherCard, score];
            } else {
                otherCard.faceUp = NO;
                
                score = MISMATCH_PENALTY;
                
                self.score -= score;
                self.lastFlipResult = [NSString stringWithFormat:@"%@ and %@ don't match! -%d points.", card, otherCard, score];
            }
            
            break;
        }
    }
    
    self.score -= FLIP_COST;
}

- (NSArray *) faceUpCards {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            [result addObject:card];
        }
    }
    
    return [result copy];
}

- (void)calculateScore:(NSUInteger)pairSize justFlipped:(Card *)card {
    self.lastFlipResult = [NSString stringWithFormat:@"Flipped %@", card];
    card.faceUp = !card.faceUp;
    
    NSLog(@"%@", [self faceUpCards]);
    
    if ([self faceUpCards].count != pairSize) {
        return;
    }

    NSMutableArray *matchingCards = [[NSMutableArray alloc] init];
    [matchingCards addObject:card];
    
    for (Card *otherCard in [self faceUpCards]) {
        if (otherCard == card) continue;
        
        if ([otherCard match:matchingCards]) {
            [matchingCards addObject:otherCard];
        }
    }
    
    // If every card matched, then we have a valid match.
    bool validMatch = [matchingCards count] == pairSize;
    
    NSLog(validMatch ? @"true" : @"false");
    
    for (Card *matchedCard in [self faceUpCards]) {
        matchedCard.faceUp = validMatch;
        matchedCard.unplayable = validMatch;
    }
    
    // TODO: print out matches
    // TODO: scoring
    
    card.faceUp = true;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    self.hasGameBegun = true;
    
    Card *card = [self cardAtIndex:index];
    
    if (card.isUnplayable) return;
    
    [self calculateScore:2 justFlipped:card];
}

@end
