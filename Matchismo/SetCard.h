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
@property (strong, nonatomic) NSString* symbol;
@property (nonatomic) NSNumber* count;
@property (nonatomic) NSString* shading;
@property (nonatomic) UIColor* color;

+ (NSArray *)validSymbols;
+ (NSArray *)validCounts;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

- (NSString *)description;

@end
