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

- (void)updateUI {
    for (UIButton *cardButton in self.SetCards) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.SetCards indexOfObject:cardButton]];
        
        NSString *contents = card.description;
        NSRange wholestring = NSMakeRange(0, contents.length);
        
        [cardButton setTitle:contents forState:UIControlStateNormal];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contents];
        [str addAttribute:NSStrokeColorAttributeName value:card.color range:wholestring];
        [str addAttribute:NSStrokeWidthAttributeName value:@-5 range:wholestring];
        
        [str addAttribute:NSForegroundColorAttributeName value:card.shading range:wholestring];
        
        if (card.isUnplayable) {
            [cardButton setHidden:YES];
        } else if (card.isFaceUp) {
            [cardButton setBackgroundColor:[UIColor grayColor]];
        } else {
            [cardButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        [cardButton setAttributedTitle:str forState:UIControlStateNormal];
    }
    
    [super updateUI];
}

- (IBAction)pushCard:(UIButton *)sender {
    ++_flipCount;
    
    [self.game flipCardAtIndex:[self.SetCards indexOfObject:sender] withPairSize:3];
    
    [self updateUI];
}

@end
