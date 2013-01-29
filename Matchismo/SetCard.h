//
//  SetCard.h
//  Matchismo
//
//  Created by Grant Mathews on 1/28/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card
@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) NSUInteger count;
@property (nonatomic) NSString *shading;
@property (nonatomic) NSUInteger color;

+ (NSArray *)validSymbols;
+ (NSUInteger)highestCount;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

- (NSString *)description;

@end
