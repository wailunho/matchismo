//
//  SetGameViewController.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardSetGame.h"
#import "SetCardDeck.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (strong, nonatomic) CardSetGame *game;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation SetGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
}

-(void) updateUI
{
    //setting for all the card buttons
    for(UIButton *cardButton in self.cardButtons)
    {
        SetCard * card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setAttributedTitle: card.attributedContents forState:UIControlStateNormal];
        cardButton.enabled = !card.isUnplayable;
        cardButton.selected = card.isSelected;
        cardButton.alpha = (card.isUnplayable)? 0.4 : 1.0;
        if(card.isSelected)
            cardButton.backgroundColor = [UIColor yellowColor];
        else
            cardButton.backgroundColor = [UIColor whiteColor];
        
        //update the score
        self.scoreLabel.text = [NSString stringWithFormat: @"Score: %d", self.game.score];
        
    }
}

-(CardSetGame *)game
{
    if(!_game)_game = [[CardSetGame alloc] initWithCardCount:[self.cardButtons count]
                                                   usingDeck:[[SetCardDeck alloc] init]];
    return _game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (IBAction)selectCard:(id)sender
{
    //select a card
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    //change text on flip count label
    self.flipCount++;
    
    //if(self.flipCount > 0)
     //   self.lastFlipLabel.attributedText = self.game.lastFlipResultString;
    
    [self updateUI];
}

@end
