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
@property (weak, nonatomic) IBOutlet UISlider *flipHistroySlider;
@property (strong, nonatomic) NSMutableArray *flipHistroy;

@end

@implementation CardgameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray*)flipHistroy
{
    if(!_flipHistroy)_flipHistroy = [[NSMutableArray alloc] init];
    return _flipHistroy;
}


- (IBAction)restartGame:(id)sender {
    self.game = nil;
    self.flipHistroy = nil;
    self.flipCount = 0;
    self.lastFlipLable.text = @"";
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

-(void)setLevelSelectSegment:(UISegmentedControl *)levelSelectSegment
{
    [levelSelectSegment setFrame:CGRectMake(29, 346, 268, 20)];
    
    _levelSelectSegment = levelSelectSegment;
    [self updateUI];
}
- (IBAction)browserFlipHistory:(id)sender
{
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
    
    //disable the segment when the game is already started.
    if(self.flipCount == 0)
        self.levelSelectSegment.enabled = YES;
    else
        self.levelSelectSegment.enabled = NO;
    
    //add last flip description into history
    if(self.flipCount > 0)
        self.lastFlipLable.text = self.flipHistroy[[self historyIndex]];
    
}

-(int) historyIndex
{
    return (int)roundf(self.flipHistroySlider.value);
}


-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    //depending on the segment selection, it calls the method in either two-card mode or three-card mode.
    if([self.levelSelectSegment selectedSegmentIndex] == 0)
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] isTwoCardsMode:YES];
    else
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] isTwoCardsMode:NO];
    self.flipCount++;
    
    if(self.game.lastFlipResultString)
    {
        [self.flipHistroy addObject:self.game.lastFlipResultString];
        self.flipHistroySlider.maximumValue = self.flipCount - 1;
    }
    self.flipHistroySlider.value = self.flipHistroy.count - 1;
    [self updateUI];
}

@end
