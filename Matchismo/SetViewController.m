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

@end

@implementation SetViewController

- (void)setCardButtons:(NSArray *)setCards {
    _SetCards = setCards;
    [self updateUI];
}

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.SetCards.count
                                                  usingDeck:[[SetCardDeck alloc] init]];
        [self updateUI];
    }
    
    return _game;
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
        
        if ([card.shading isEqualToString:@"Normal"]) {
            [str addAttribute:NSForegroundColorAttributeName value:card.color range:wholestring];
        } else if ([card.shading isEqualToString:@"Grayed"]) {
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:wholestring];
        } else {
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:wholestring];
        }
        
        [cardButton setAttributedTitle:str forState:UIControlStateNormal];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)pushCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.SetCards indexOfObject:sender]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
