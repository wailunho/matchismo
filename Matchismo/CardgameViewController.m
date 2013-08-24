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

@interface CardgameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *levelSelectSegment;

@end

@implementation CardgameViewController

- (IBAction)restartGame:(id)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc]init]];
    self.flipCount = 0;
    [self updateUI];
}

-(CardMatchingGame *)game
{
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                        usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void) updateUI
{
    for(UIButton *carButton in self.cardButtons)
    {
        Card * card = [self.game cardAtIndex:[self.cardButtons indexOfObject:carButton]];
        [carButton setTitle:card.contents forState:UIControlStateSelected];
        [carButton setTitle:card.contents forState:UIControlStateDisabled | UIControlStateSelected];
        [carButton setBackgroundImage:[UIImage imageNamed:@"cardSelected.png"] forState:UIControlStateSelected | UIControlStateDisabled];
        [carButton setBackgroundImage:[UIImage imageNamed:@"cardSelected.png"] forState:UIControlStateSelected];
        [carButton setBackgroundImage:[UIImage imageNamed:@"card.png"] forState:UIControlStateNormal];
        carButton.alpha = (card.unplayable)? 0.4 : 1.0;
        carButton.selected = card.isFaceUp;
        carButton.enabled = !card.isUnplayable;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLable.text = self.game.lastFlipResultString;
    if(self.flipCount == 0)
        self.levelSelectSegment.enabled = YES;
    else
        self.levelSelectSegment.enabled = NO;
    
}


-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    if([self.levelSelectSegment selectedSegmentIndex] == 0)
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    else
        [self.game flipCardInThreeCardsModeAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

@end
