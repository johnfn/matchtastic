//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Grant Mathews on 1/30/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"

@interface MatchismoViewController() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIStepper *cardStepper;
@property (nonatomic) int cardsToDeal;
@end

@implementation MatchismoViewController

- (int)cardsToDeal {
    return [self.cardStepper value];
}

- (CardMatchingGame *)game {
    if (!super.game) {
        super.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardStepper value] usingDeck:[[PlayingCardDeck alloc] init]];
        [self updateUI];
    }
    
    return super.game;
}

- (IBAction)stepperValueChange:(UIStepper *)sender {
    [self.dealButton setTitle:[NSString stringWithFormat:@"Deal %d!", (int)[sender value]] forState:UIControlStateNormal];
}

- (NSInteger)collectionView:(UICollectionView *)asker
     numberOfItemsInSection:(NSInteger)section {
    return self.game.numCards;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.cardCollectionView
                                  dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        int idx = [indexPath indexAtPosition:1];
        
        [self.game cardAtIndex:idx];
        
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:idx];
        
        PlayingCardCollectionViewCell *pccvc = (PlayingCardCollectionViewCell *)cell;
        
        PlayingCardView *pcv = pccvc.playingCardView;
        pcv.suit = card.suit;
        pcv.rank = card.rank;
        pcv.faceUp = card.isFaceUp;
        pcv.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    return cell;
}

- (IBAction)tapGesture:(id)sender {
    [self.game flipCardAtIndex:[super getTouchIndex:sender] withPairSize:2];
    [self updateUI];
}

- (void)updateUI {
    if (self.game.lastScore) {
        NSMutableString *statusString = [[NSMutableString alloc] init];
        
        [statusString appendString:@"You played "];
        
        int i = 0;
        
        for (Card *card in self.game.lastPlayedCards) {
            [statusString appendString:card.description];
            if (i != self.game.lastPlayedCards.count - 1) {
                [statusString appendString:@","];
            }
            i++;
        }
        
        if (self.game.lastScore > 0) {
            [statusString appendString:[NSString stringWithFormat:@"gaining %d points!", self.game.lastScore]];
        } else {
            [statusString appendString:[NSString stringWithFormat:@"losing %d points.", self.game.lastScore]];
        }
        
        [self.statusLabel setText:statusString];
    }
    [super updateUI];
}

- (IBAction)dealButton:(id)sender {
    [super deal];
}

@end
