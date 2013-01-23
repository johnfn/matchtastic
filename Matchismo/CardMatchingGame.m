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

- (NSArray *) faceUpCards {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            [result addObject:card];
        }
    }
    
    return [result copy];
}

#define FLIP_COST -1
#define MISMATCH_PENALTY -2
#define MATCH_BONUS 4

- (void)calculateScore:(NSUInteger)pairSize justFlipped:(Card *)card {
    self.lastFlipResult = [NSString stringWithFormat:@"Flipped %@", card];
    card.faceUp = !card.faceUp;
    
    int score = FLIP_COST;
    
    if ([self faceUpCards].count != pairSize) {
        if (!card.faceUp) {
            self.lastFlipResult = [NSString stringWithFormat:@"Unflipped %@ for a score of %d", card, score];
            self.score += score;
        }
        
        return;
    }

    int scoreMultiplier = 0;
    NSMutableArray *matchingCards = [[NSMutableArray alloc] init];
    [matchingCards addObject:card];
    
    for (Card *otherCard in [self faceUpCards]) {
        if (otherCard == card) continue;
        
        scoreMultiplier = [otherCard match:matchingCards];
        
        if (scoreMultiplier) {
            [matchingCards addObject:otherCard];
        }
    }
    
    // If every card matched, then we have a valid match.
    bool validMatch = [matchingCards count] == pairSize;
    
    NSLog(validMatch ? @"true" : @"false");
    
    // calculate score
    
    if (!validMatch) {
        score += MISMATCH_PENALTY;
    } else {
        score += ([matchingCards count] - 1) * MATCH_BONUS * scoreMultiplier;
    }
    
    self.score += score;
    
    self.lastFlipResult = [NSString stringWithFormat:@"Flipped %@ for a score of %d", card, score];
    
    for (Card *matchedCard in [self faceUpCards]) {
        matchedCard.faceUp = validMatch;
        matchedCard.unplayable = validMatch;
    }
    card.faceUp = true;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    self.hasGameBegun = true;
    
    Card *card = [self cardAtIndex:index];
    
    if (card.isUnplayable) return;
    
    [self calculateScore: (self.isTripleMatchGame ? 3 : 2) justFlipped:card];
}

@end
