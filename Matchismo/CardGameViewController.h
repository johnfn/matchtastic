//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Grant Mathews on 1/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;

- (void)updateUI;
- (void)deal;
- (int)getTouchIndex:(UITapGestureRecognizer *)sender;
@end
