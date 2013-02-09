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

- (void)flipCardAtIndex:(NSInteger)index withPairSize:(NSInteger)size;

- (Card *)cardAtIndex:(NSUInteger)index;

- (bool)dealMoreCards:(NSUInteger)numCards matchSize:(NSUInteger)matchSize;

- (bool)doMatchesExist:(NSUInteger)pairSize;

@property (nonatomic, readonly) int score;

@property (readonly, nonatomic) bool hasGameBegun;
@property (readonly, nonatomic) int numCards;

@property (readonly, strong, nonatomic) NSMutableArray *lastPlayedCards;
@property (readonly, nonatomic) int lastScore;
@property (nonatomic) bool matchFoundPenalty;
@end
