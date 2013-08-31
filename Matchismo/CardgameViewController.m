//
//  CardgameViewController.m
//  Matchismo
//
//  Created by William Ho on 8/22/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardgameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "MatchGameResult.h"

@interface CardgameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;
@property (strong, nonatomic) NSMutableArray *flipHistory;
@property (strong, nonatomic) MatchGameResult *gameResult;

@end

@implementation CardgameViewController

#define ALPHA_UNPLAYABLE 0.4
#define ALPHA_PLAYABLE 1.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Init

-(MatchGameResult*)gameResult
{
    if(!_gameResult)_gameResult = [[MatchGameResult alloc] init];
    return _gameResult;
}

-(NSMutableArray*)flipHistory
{
    if(!_flipHistory)_flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

-(CardMatchingGame *)game
{
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                        usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

#pragma mark - Setters

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
    self.gameResult.score = self.game.score;
    [self.gameResult synchronize];
}

#pragma mark - Helper

//Use this to get the value in the slider in int, that is rounded off.
-(int) historyIndex
{
    return (int)roundf(self.flipHistorySlider.value);
}

#pragma mark - main functions

-(void) updateUI
{
    //setting for all the card buttons
    for(UIButton *carButton in self.cardButtons)
    {
        Card * card = [self.game cardAtIndex:[self.cardButtons indexOfObject:carButton]];
        [carButton setTitle:card.contents forState:UIControlStateSelected];
        [carButton setTitle:card.contents forState:UIControlStateDisabled | UIControlStateSelected];
        [carButton setBackgroundImage:[UIImage imageNamed:@"cardSelected.png"] forState:UIControlStateSelected | UIControlStateDisabled];
        [carButton setBackgroundImage:[UIImage imageNamed:@"cardSelected.png"] forState:UIControlStateSelected];
        [carButton setBackgroundImage:[UIImage imageNamed:@"card.png"] forState:UIControlStateNormal];
        carButton.alpha = (card.unplayable)? ALPHA_UNPLAYABLE : ALPHA_PLAYABLE;
        carButton.selected = card.isFaceUp;
        carButton.enabled = !card.isUnplayable;
    }
    
    //display the game score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    //display the flip history indicated by the slider
    if(self.flipCount > 0)
        self.lastFlipLabel.text = [NSString stringWithFormat:@"%d: %@", [self historyIndex] + 1,self.flipHistory[[self historyIndex]]];
    
}

- (IBAction)flipCard:(UIButton *)sender
{
    //flip a card
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    //change text on flip count label
    self.flipCount++;
    
    //add the new flip into the flip history
    if(self.game.lastFlipResultString)
    {
        [self.flipHistory addObject:self.game.lastFlipResultString];
        self.flipHistorySlider.maximumValue = self.flipCount - 1;
    }
    
    //put the slider to reflect the most recent flip in the flip history
    self.flipHistorySlider.value = self.flipHistory.count - 1;
    [self updateUI];
}

- (IBAction)restartGame:(id)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipHistory = nil;
    self.flipCount = 0;
    self.lastFlipLabel.text = @"";
    self.flipHistorySlider.value = 0;
    self.flipHistorySlider.maximumValue = 0;
    [self updateUI];
}


- (IBAction)browseHistory:(id)sender
{
    [self updateUI];
}

@end
