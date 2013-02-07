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

@interface SetViewController ()
//TODO - rename
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *SetCards;

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SetViewController

#define CARDS_TO_DEAL 3

- (void)setCardButtons:(NSArray *)setCards {
    _SetCards = setCards;
    [self updateUI];
}

- (CardMatchingGame *)game {
    if (!super.game) {
        super.game = [[CardMatchingGame alloc] initWithCardCount:self.SetCards.count
                                                  usingDeck:[[SetCardDeck alloc] init]];
        [self updateUI];
    }
    
    return super.game;
}

- (IBAction)dealButton:(id)sender {
    super.game = nil; // cause the lazy-loading to be fired again.
    [self updateUI];
}

- (IBAction)threeMoreButton:(id)sender {
    [self.game dealMoreCards:CARDS_TO_DEAL];
    [self updateUI];
}

- (NSMutableAttributedString *)renderText:(SetCard *)card {
    NSString *contents = card.description;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contents];
    NSRange wholestring = NSMakeRange(0, contents.length);
    
    [str addAttribute:NSStrokeColorAttributeName value:card.color range:wholestring];
    [str addAttribute:NSStrokeWidthAttributeName value:@-5 range:wholestring];
    
    [str addAttribute:NSForegroundColorAttributeName value:card.shading range:wholestring];
    
    return str;
}

- (void)updateUI {
    for (int i = 0; i < self.SetCards.count; i++) {
        UIButton *cardButton = [self.SetCards objectAtIndex:i];
        
        if (i < self.game.numCards) {
            SetCard *card = (SetCard *)[self.game cardAtIndex:i];
            
            if (card.isUnplayable) {
                [cardButton setHidden:YES];
            } else {
                [cardButton setHidden:NO];
                
                if (card.isFaceUp) {
                    [cardButton setBackgroundColor:[UIColor grayColor]];
                } else {
                    [cardButton setBackgroundColor:[UIColor whiteColor]];
                }
            }
            
            [cardButton setAttributedTitle:[self renderText:card] forState:UIControlStateNormal];
        } else {
            [cardButton setHidden:YES];
        }
    }
    
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
        
        NSString *endOfStatus;
        
        if (self.game.lastScore > 0) {
            endOfStatus = [NSString stringWithFormat:@" for %d points!", self.game.lastScore];
        } else {
            endOfStatus = [NSString stringWithFormat:@" losing %d points.", self.game.lastScore];
        }
        
        [gameStatus appendAttributedString:[[NSMutableAttributedString alloc] initWithString:endOfStatus]];
    
        self.welcomeLabel.attributedText = gameStatus;
    }
    
    // Properly size the ScrollView.
    UIButton *bottommostButton = (UIButton *)[self.SetCards objectAtIndex:self.SetCards.count - 1];
    int lengthOfScrollview = [bottommostButton frame].origin.y + [bottommostButton frame].size.height;
    [self.scrollView setContentSize:CGSizeMake(320, lengthOfScrollview)];
    
    [super updateUI];
}

- (void)viewDidLoad {
    // The concept of ordering the buttons based on their position was found on StackOverflow:
    // http://stackoverflow.com/questions/6527762/iboutletcollection-set-ordering-in-interface-builder
    
    // Order the labels based on their y position
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

    [self.scrollView setContentSize:CGSizeMake(320, 500)];
    [self updateUI];
    
    [super viewDidLoad];
}

- (IBAction)pushCard:(UIButton *)sender {
    ++_flipCount;
    
    [self.game flipCardAtIndex:[self.SetCards indexOfObject:sender] withPairSize:3];
    
    [super flipCard:sender];
    [self updateUI];
}

@end
