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
@property (strong, nonatomic) NSString *type;
@property (nonatomic) NSUInteger count;

+ (NSArray *)validTypes;
+ (NSUInteger)highestCount;

@end
