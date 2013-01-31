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

@end

@implementation SetViewController

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
    for (UIButton *cardButton in self.SetCards) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.SetCards indexOfObject:cardButton]];
        
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
    
    [super updateUI];
}

- (void)viewDidLoad {
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
