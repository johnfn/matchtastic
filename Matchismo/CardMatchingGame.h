//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Grant Mathews on 1/21/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index withPairSize:(NSUInteger)size;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (readonly, nonatomic) bool hasGameBegun;

@property (readonly, strong, nonatomic) NSArray *lastPlayedCards;
@property (readonly, nonatomic) int lastScore;
@end
