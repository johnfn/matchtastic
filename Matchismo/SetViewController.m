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

@interface SetViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

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
        //TODO - 20 hardcode
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

- (NSInteger)collectionView:(UICollectionView *)asker
     numberOfItemsInSection:(NSInteger)section {
    return self.game.numCards;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    CGPoint loc = [sender locationOfTouch:0 inView:self.cardCollectionView];
    
    NSIndexPath *ip = [self.cardCollectionView indexPathForItemAtPoint:loc];
    if (ip == nil) return;
    
    NSUInteger index = [ip indexAtPosition:1];
    [self.game flipCardAtIndex:index withPairSize:3];
    
    //TODO
    //[super flipCard:sender];
    [self updateUI];
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
    super.game = nil; // cause the lazy-loading to be fired again.
    [self updateUI];
}

- (IBAction)threeMoreButton:(id)sender {
    if (![self.game dealMoreCards:CARDS_TO_DEAL]) {
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
    
    [str addAttribute:NSStrokeColorAttributeName value:card.color range:wholestring];
    [str addAttribute:NSStrokeWidthAttributeName value:@-5 range:wholestring];
    
    //TODO
    //[str addAttribute:NSForegroundColorAttributeName value:card.shading range:wholestring];
    
    return str;
}

- (void)updateUI {
    // Show the cards we last played
    if (self.game.lastPlayedCards.count) {
        NSMutableAttributedString *gameStatus = [[NSMutableAttributedString alloc] initWithString:@"You played the cards below"];
        
        /*
        int i = 0;
        
        for (SetCard *card in self.game.lastPlayedCards) {
            SetCardView *v = (SetCardView *)[self.displayCards objectAtIndex:i];
            v.count   = card.count;
            v.color   = card.color;
            v.shading = card.shading;
            v.symbol  = card.symbol;
            v.hidden  = NO;
            
            // Give them a thick border color - otherwise they look weird.
            v.layer.borderColor = [UIColor blackColor].CGColor;
            v.layer.borderWidth = 2.0f;
            
            ++i;
        }
        
        for (; i < 3; i++) {
            SetCardView *v = (SetCardView *)[self.displayCards objectAtIndex:i];
            v.hidden = YES;
        }
        */
        
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
    }
    
    [self.cardCollectionView reloadData];
    
    [super updateUI];
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
 */


- (void)viewDidLoad {
    // The concept of ordering the buttons based on their position was found on StackOverflow:
    // http://stackoverflow.com/questions/6527762/iboutletcollection-set-ordering-in-interface-builder
    
    // Order the labels based on their y position
    /*
    self.SetCards = [self.SetCards sortedArrayUsingComparator:^NSComparisonResult(id button1, id button2) {
        if ([button1 frame].origin.y < [button2 frame].origin.y) {
            return NSOrderedAscending;
        } else if ([button1 frame].origin.y > [button2 frame].origin.y) {
            return NSOrderedDescending;
        } else {
            if ([button1 frame].origin.x < [button2 frame].origin.x) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }
    }];
     */
    [self updateUI];
    
    [super viewDidLoad];
}

@end
