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

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic) PlayingCardDeck *deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation CardGameViewController

- (PlayingCardDeck *)deck {
    if (_deck == nil) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    
    for (UIButton *cardButton in cardButtons) {
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
    }
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    ++self.flipCount;
}

@end
