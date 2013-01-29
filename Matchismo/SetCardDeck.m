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
        for (NSString *type in [SetCard validTypes]) {
            for (NSUInteger count = 1; count <= [SetCard highestCount]; count++) {
                for (NSString *shading in [SetCard validShadings]) {
                    for (NSNumber *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.count = count;
                        card.type = type;
                        card.shading = shading;
                        card.color = [color integerValue];
                        
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
