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
#import "SetGameResult.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (strong, nonatomic) CardSetGame *game;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;
@property (strong,nonatomic) NSMutableArray *flipHistory;
@property (strong, nonatomic) SetGameResult *gameResult;

@end

@implementation SetGameViewController

#define ALPHA_UNPLAYABLE 0.1
#define ALPHA_PLAYABLE 1.0
#define REDKEY @"redColor"
#define GREENKEY @"greenColor"
#define BLUEKEY @"blueColor"
#define STROKEWIDTH @-5

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.lastFlipLabel.text = @"";
}

-(GameResult*)gameResult
{
    if(!_gameResult)_gameResult = [[SetGameResult alloc] init];
    return _gameResult;
}

-(NSMutableArray*)flipHistory
{
    if(!_flipHistory)_flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

-(CardSetGame *)game
{
    if(!_game)_game = [[CardSetGame alloc] initWithCardCount:[self.cardButtons count]
                                                   usingDeck:[[SetCardDeck alloc] init]];
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

#pragma mark - Helpers

//Use this to get the value in the slider in int, that is rounded off.
-(int) historyIndex
{
    return (int)roundf(self.flipHistorySlider.value);
}

//convert a Card contents into attributed string
-(NSAttributedString*)contentToAttributedString:(SetCard*)card
{
    NSDictionary *colorDictionary = @{REDKEY:[UIColor redColor], GREENKEY: [UIColor greenColor], BLUEKEY: [UIColor blueColor]};
    
    NSDictionary *attributes = @{NSStrokeColorAttributeName: colorDictionary[card.color], NSForegroundColorAttributeName: [colorDictionary[card.color] colorWithAlphaComponent:[card.shading floatValue]], NSStrokeWidthAttributeName: STROKEWIDTH};
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
    return attributedString;
}

//replace a word in an attributed string with another word
//can be use to replace an attributed word with the same word with another attributes.
-(NSMutableAttributedString*) replaceWordInString:(NSMutableAttributedString*) attributedString withWord: (NSAttributedString*) word
{
    NSRange range = [[attributedString string] rangeOfString: [word string]];
    [attributedString replaceCharactersInRange:range withAttributedString:word];
    return attributedString;
}

#pragma mark - Main functions

-(void) updateUI
{
    //setting for all the card buttons
    for(UIButton *cardButton in self.cardButtons)
    {
        SetCard * card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];

        NSAttributedString *cardAttributedString = [self contentToAttributedString:card];
        [cardButton setAttributedTitle: cardAttributedString forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isUnplayable;
        cardButton.selected = card.isFaceUp;
        cardButton.alpha = (card.isUnplayable)? ALPHA_UNPLAYABLE : ALPHA_PLAYABLE;
        if(card.isFaceUp)
            cardButton.backgroundColor = [UIColor yellowColor];
        else
            cardButton.backgroundColor = [UIColor whiteColor];
    }
    
    //update the score
    self.scoreLabel.text = [NSString stringWithFormat: @"Score: %d", self.game.score];
    
    //display the flip history indicated by the slider
    if(self.flipCount > 0)
    {
        NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d: ", [self historyIndex] + 1]];
        [temp appendAttributedString:self.flipHistory[[self historyIndex]]];
        self.lastFlipLabel.attributedText = temp;
    }
}

- (IBAction)selectCard:(id)sender
{
    //select a card
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    //change text on flip count label
    self.flipCount++;
    
    //add the new flip into the flip history
    if(self.game.lastFlipResultDictionary)
    {
        NSMutableAttributedString *historyAttributedString = [[NSMutableAttributedString alloc] init];
        
        SetCard *firstCard = self.game.lastFlipResultDictionary[@"firstCard"];
        NSMutableArray *replacingWords = [[NSMutableArray alloc] initWithObjects:[self contentToAttributedString:firstCard], nil];
        NSMutableArray *wordsNeedToReplace = [[NSMutableArray alloc] initWithObjects:firstCard.contents, nil];
        if(self.game.lastFlipResultDictionary.count == 4)
        {
            SetCard *secondCard = self.game.lastFlipResultDictionary[@"secondCard"];
            SetCard *thirdCard = self.game.lastFlipResultDictionary[@"thirdCard"];
            [wordsNeedToReplace addObjectsFromArray:@[secondCard.contents, thirdCard.contents]];
            [replacingWords addObjectsFromArray:@[[self contentToAttributedString:secondCard], [self contentToAttributedString:thirdCard]]];
        }
        
        //putting the history string into an array
        NSArray *stringArray = [self.game.lastFlipResultDictionary[@"string"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for(NSString* word in stringArray)
        {
            //matching each words that need to replace with the word in history string
            for(int i = 0; i <= [wordsNeedToReplace count]; i++)
            {
                //none matched
                if(i == [wordsNeedToReplace count])
                    [historyAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[word stringByAppendingString:@" "]]];
                //a word matched
                else if([wordsNeedToReplace[i] isEqualToString:word])
                {
                    [historyAttributedString appendAttributedString:replacingWords[i]];
                    [historyAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                    //remove the word from the list
                    wordsNeedToReplace[i] = @"";
                    break;
                }
            }
        }
        
        //add to the array and set the max value of the slider
        [self.flipHistory addObject:historyAttributedString];
        self.flipHistorySlider.maximumValue = self.flipCount - 1;
    }
    
    //put the slider to reflect the most recent flip in the flip history
    self.flipHistorySlider.value = self.flipHistory.count - 1;
    
    [self updateUI];
}

- (IBAction)restartGame:(id)sender
{
    self.flipCount = 0;
    self.gameResult= nil;
    self.game = nil;
    self.lastFlipLabel.text = @"";
    self.flipHistorySlider.value = 0;
    self.flipHistorySlider.maximumValue = 0;
    self.flipHistory = nil;
    [self updateUI];
}

- (IBAction)browseHistory:(id)sender
{
    [self updateUI];
}

@end
