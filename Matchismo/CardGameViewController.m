//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Grant Mathews on 1/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (weak, nonatomic) UICollectionView *cardCollectionView;

@end

@implementation CardGameViewController

@synthesize game = _game;

- (CardMatchingGame *)game {
    return _game;
}

- (void)setGame:(CardMatchingGame *)game {
    _game = game;
}

- (void)updateUI {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];

    [self.cardCollectionView reloadData];
}

- (void)deal {
    self.game = nil; // cause the (custom-implemented) lazy-loading to fire again.
    [self updateUI];
}

- (int)getTouchIndex:(UITapGestureRecognizer *)sender {
    CGPoint loc = [sender locationOfTouch:0 inView:self.cardCollectionView];
    
    NSIndexPath *ip = [self.cardCollectionView indexPathForItemAtPoint:loc];
    if (ip == nil) return -1;
    
    return [ip indexAtPosition:1];
}

@end
