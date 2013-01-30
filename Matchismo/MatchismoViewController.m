//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Grant Mathews on 1/30/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"

@interface MatchismoViewController()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardCollection;

@end

@implementation MatchismoViewController
- (CardMatchingGame *)game {
    if (!super.game) {
        super.game = [[CardMatchingGame alloc] initWithCardCount:self.cardCollection.count usingDeck:[[PlayingCardDeck alloc] init]];
        [self updateUI];
    }
    
    return super.game;
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

    /*
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipDescription.text = self.game.lastFlipResult;
    */ 
     
    //[super updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardCollection indexOfObject:sender] withPairSize:2];
    
    [super flipCard:sender];
}
@end
