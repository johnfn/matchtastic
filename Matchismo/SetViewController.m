//
//  SetViewController.m
//  Matchismo
//
//  Created by Grant Mathews on 1/28/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SetViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"
#import "SetCardCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface SetViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *threeMoreButton;

@end

@implementation SetViewController

#define CARDS_TO_DEAL 3
#define START_CARD_NUM 12
- (CardMatchingGame *)game {
    if (!super.game) {
        super.game = [[CardMatchingGame alloc] initWithCardCount:START_CARD_NUM usingDeck:[[SetCardDeck alloc] init]];
        [self updateUI];
    }
    
    return super.game;
}

- (void)setCardCollectionView:(UICollectionView *)cardCollectionView
{
    _cardCollectionView = cardCollectionView;
    _cardCollectionView.dataSource = self; // must implement UICollectionViewDataSource!
    _cardCollectionView.delegate = self; // must implement UICollectionViewDelegate!
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.game flipCardAtIndex:[super getTouchIndex:sender] withPairSize:3];
    [self updateUI];
}

- (NSInteger)collectionView:(UICollectionView *)asker
     numberOfItemsInSection:(NSInteger)section {
    return self.game.numCards;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.cardCollectionView
                                  dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        int idx = [indexPath indexAtPosition:1];
        
        SetCard *card = (SetCard *)[self.game cardAtIndex:idx];
        
        SetCardCollectionViewCell *sccvc = (SetCardCollectionViewCell *)cell;
        
        SetCardView *scv = sccvc.setCardView;
        scv.count   = card.count;
        scv.color   = card.color;
        scv.shading = card.shading;
        scv.symbol  = card.symbol;
    }
    
    return cell;
}

- (IBAction)dealButton:(id)sender {
    [super deal];
}

- (IBAction)threeMoreButton:(id)sender {
    if (![self.game dealMoreCards:CARDS_TO_DEAL matchSize:3]) {
        [self.threeMoreButton setTitle:@"0 more!" forState:UIControlStateNormal];
    }
    
    // Allow CollectionView to update
    [self updateUI];
    
    // Now scroll to the bottom.
    // These two lines with help from StackOverflow:
    // http://stackoverflow.com/questions/952412/uiscrollview-scroll-to-bottom-programmatically
    CGPoint bottomOffset = CGPointMake(0, self.cardCollectionView.contentSize.height - self.cardCollectionView.bounds.size.height);
    [self.cardCollectionView setContentOffset:bottomOffset animated:YES];
}

- (NSMutableAttributedString *)renderText:(SetCard *)card {
    NSString *contents = card.description;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contents];
    NSRange wholestring = NSMakeRange(0, contents.length);
    
    UIColor *interpretedCardColor = card.color;
    if (interpretedCardColor == [UIColor blueColor]) {
        interpretedCardColor = [UIColor colorWithRed:0 green:255 blue:255 alpha:0];
    }
    
    [str addAttribute:NSStrokeColorAttributeName value:card.color range:wholestring];
    [str addAttribute:NSStrokeWidthAttributeName value:@-5 range:wholestring];
    
    UIColor *shadingColor;
    if (card.shading == [SetCard validShades][0]) {
        shadingColor = [UIColor whiteColor];
    } else if (card.shading == [SetCard validShades][1]) {
        shadingColor = [UIColor grayColor];
    } else {
        shadingColor = [UIColor blackColor];
    }
    
    [str addAttribute:NSBackgroundColorAttributeName value:shadingColor range:wholestring];
    
    return str;
}

- (void)updateUI {
    // Show the cards we last played
    if (self.game.lastPlayedCards.count) {
        NSMutableAttributedString *gameStatus = [[NSMutableAttributedString alloc] initWithString:@"You played: "];
        int i = 0;
        
        for (SetCard *card in self.game.lastPlayedCards) {
            [gameStatus appendAttributedString:[self renderText:card]];
            
            // Append commas unless it's the last one
            if (i != self.game.lastPlayedCards.count - 1) {
                [gameStatus appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
            }
            
            ++i;
        }
        
        // If they completed a play, show the score also.
        if (self.game.lastPlayedCards.count == 3) {
            NSString *endOfStatus;
            
            if (self.game.lastScore > 0) {
                endOfStatus = [NSString stringWithFormat:@" for %d points!", self.game.lastScore];
            } else {
                endOfStatus = [NSString stringWithFormat:@" losing %d points.", self.game.lastScore];
            }
            
            [gameStatus appendAttributedString:[[NSMutableAttributedString alloc] initWithString:endOfStatus]];
        }
    
        self.welcomeLabel.attributedText = gameStatus;
    } else {
        self.welcomeLabel.attributedText = [[NSAttributedString alloc] initWithString:@"No cards played."];
    }
    
    // This overrides the other ones (but it will quickly disappear).
    if (self.game.matchFoundPenalty) {
        self.welcomeLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"There was a match! -%d penalty!", self.game.lastScore]];
    }
    
    [self.cardCollectionView reloadData];
    
    [super updateUI];
}

- (void)viewDidLoad {
    [self updateUI];
    
    [super viewDidLoad];
}

@end
