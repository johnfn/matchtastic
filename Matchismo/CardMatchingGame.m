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

- (void)flipCardAtIndex:(NSUInteger)index {
    self.hasGameBegun = true;
    
    Card *card = [self cardAtIndex:index];
    
    if (card.isUnplayable) return;
    
    if (!card.isFaceUp) {
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
    
    card.faceUp = !card.faceUp;
    
}

@end
