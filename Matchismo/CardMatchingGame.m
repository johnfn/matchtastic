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

@property (readwrite, strong, nonatomic) NSMutableArray *lastPlayedCards;
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

- (bool)dealMoreCards:(NSUInteger)numCards matchSize:(NSUInteger)matchSize{
    if ([self doMatchesExist:matchSize]) {
        self.score -= 100;
        self.lastScore = -100;
        self.matchFoundPenalty = true;
    }

    for (int i = 0; i < numCards; i++) {
        Card *card = [self.deck drawRandomCard];
        
        if (card == nil) {
            return false;
        } else {
            [self.cards addObject:card];
        }
    }
    
    return true;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (NSMutableArray *) faceUpCards {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            [result addObject:card];
        }
    }
    
    return result;
}

#define FLIP_COST -1
#define MISMATCH_PENALTY -2
#define MATCH_BONUS 4

- (void)calculateScore:(NSUInteger)pairSize justFlipped:(Card *)card removeCards:(bool)shouldRemoveCards {
    card.faceUp = !card.faceUp;
    
    int score = FLIP_COST;
    
    self.lastScore = 0;
    
    if ([self faceUpCards].count != pairSize) {
        if (!card.faceUp) {
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
        
        if (!shouldRemoveCards) {
            card.faceUp = true;
        }
    }
}

- (bool)doMatchesExist:(NSUInteger)pairSize {
    if (pairSize == 2) {
        return false;
    }

    for (Card *card1 in self.cards) {
        for (Card *card2 in self.cards) {
            if (card2 == card1) continue;
            for (Card *card3 in self.cards) {
                if (card3 == card2 || card3 == card1) continue;
                
                if ([[card1 class] match:@[card1, card2, card3]]) {
                    return true;
                }
            }
        }
    }
    
    return false;
}

- (void)flipCardAtIndex:(NSInteger)index withPairSize:(NSInteger)size {
    self.matchFoundPenalty = false;
    if (index < 0) return;
    
    self.hasGameBegun = true;
    
    Card *card = [self cardAtIndex:index];
    
    if (card.isUnplayable) return;
    
    if (self.lastPlayedCards == nil || self.lastPlayedCards.count == size) {
        self.lastPlayedCards = [[NSMutableArray alloc] init];
    }
    
    if (!card.isFaceUp) {
        [self.lastPlayedCards addObject:card];
    } else {
        [self.lastPlayedCards removeObject:card];
    }
    
    [self calculateScore:size justFlipped:card removeCards:(size == 3)];
}

@end
