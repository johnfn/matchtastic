//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Grant Mathews on 1/28/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init {
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSNumber *count in [SetCard validCounts]) {
                for (UIColor *shading in [SetCard validShades]) {
                    for (UIColor *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.count = count;
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                        
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
