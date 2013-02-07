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
@property (readwrite, nonatomic) bool hasGameBegun;
@property (strong, nonatomic) Deck *deck;

@property (readwrite, strong, nonatomic) NSArray *lastPlayedCards;
@property (readwrite, nonatomic) int lastScore;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (int)numCards {
    return self.cards.count;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            
            if (!card) return nil;
            
            self.cards[i] = card;
        }
        
        self.deck = deck;
    }
    
    return self;
}

- (bool)dealMoreCards:(NSUInteger)numCards {
    for (int i = 0; i < numCards; i++) {
        Card *card = [self.deck drawRandomCard];
        
        if (card == nil) {
            return false;
        } else {
            [self.cards addObject:card];
        }
        
        NSLog(@"%d", self.cards.count);
    }
    
    return true;
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

- (void)calculateScore:(NSUInteger)pairSize justFlipped:(Card *)card removeCards:(bool)shouldRemoveCards {
    card.faceUp = !card.faceUp;
    
    int score = FLIP_COST;
    
    if ([self faceUpCards].count != pairSize) {
        if (!card.faceUp) {
            self.lastPlayedCards = @[card];
            self.lastScore = score;
            self.score += score;
        }
        
        return;
    }

    int scoreMultiplier = [[card class] match:[self faceUpCards]];
    
    // calculate score
    
    if (!scoreMultiplier) {
        score += MISMATCH_PENALTY;
    } else {
        score += MATCH_BONUS * scoreMultiplier;
    }
    
    self.score += score;
    
    self.lastPlayedCards = [self faceUpCards];
    self.lastScore = score;
    
    if (scoreMultiplier > 0) {
        for (Card *matchedCard in [self faceUpCards]) {
            if (shouldRemoveCards) {
                [self.cards removeObject:matchedCard];
            }
            
            matchedCard.unplayable = true;
        }
    
    } else {
        for (Card *matchedCard in [self faceUpCards]) {
            matchedCard.faceUp = false;
        }
        
        card.faceUp = true;
    }
}

- (void)flipCardAtIndex:(NSUInteger)index withPairSize:(NSUInteger)size {
    self.hasGameBegun = true;
    
    Card *card = [self cardAtIndex:index];
    
    if (card.isUnplayable) return;
    
    [self calculateScore:size justFlipped:card removeCards:(size == 3)];
}

@end
