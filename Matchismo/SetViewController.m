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
    NSLog(@"hello.......");
    for (UIButton *cardButton in self.SetCards) {
        Card *card = [self.game cardAtIndex:[self.SetCards indexOfObject:cardButton]];
        
        [cardButton setTitle:card.description forState:UIControlStateNormal];
        
        NSLog(@"derp");
        NSLog(@"%@", card);
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
