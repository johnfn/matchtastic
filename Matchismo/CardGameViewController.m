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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (weak, nonatomic) IBOutlet UISwitch *gameTypeSwitch;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                              usingDeck:[[PlayingCardDeck alloc] init]];
        [self updateUI];
    }
    
    return _game;
}

- (IBAction)dealButton:(id)sender {
    _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                              usingDeck:[[PlayingCardDeck alloc] init]];
    
    [self updateUI];
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        [cardButton setImage:cardBackImage forState:UIControlStateSelected|UIControlStateDisabled];
    }

    self.gameTypeSwitch.enabled = !self.game.hasGameBegun;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipDescription.text = self.game.lastFlipResult;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] withPairSize:2];
    ++self.flipCount;
    
    [self updateUI];
}

@end
