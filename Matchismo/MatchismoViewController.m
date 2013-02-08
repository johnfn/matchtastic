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
@end

#define NUM_CARDS 20

@implementation MatchismoViewController

- (CardMatchingGame *)game {
    if (!super.game) {
        super.game = [[CardMatchingGame alloc] initWithCardCount:20 usingDeck:[[PlayingCardDeck alloc] init]];
        [self updateUI];
    }
    
    return super.game;
}

- (NSInteger)collectionView:(UICollectionView *)asker
     numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%d", self.game.numCards);
    return self.game.numCards;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.cardCollectionView
                                  dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        int idx = [indexPath indexAtPosition:1];
        
        NSLog(@"%d", idx);
        
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

- (void)updateUI {
    /*
    for (UIButton *cardButton in self.cardCollection) {
        Card *card = [self.game cardAtIndex:[self.cardCollection indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        [cardButton setImage:cardBackImage forState:UIControlStateSelected|UIControlStateDisabled];
    }
     */
    
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
    super.game = [[CardMatchingGame alloc] initWithCardCount:NUM_CARDS usingDeck:[[PlayingCardDeck alloc] init]];
    
    [self updateUI];
}

/*
- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardCollection indexOfObject:sender] withPairSize:2];
    
    [super flipCard:sender];
    [self updateUI];
}
*/

@end
