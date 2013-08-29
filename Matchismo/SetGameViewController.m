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
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;
@property (strong,nonatomic) NSMutableArray *flipHistory;

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


-(NSMutableArray*)flipHistory
{
    if(!_flipHistory)_flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.lastFlipLabel.text = @"";
}

- (IBAction)restartGame:(id)sender
{
    self.flipCount = 0;
    self.game = nil;
    self.lastFlipLabel.text = @"";
    self.flipHistorySlider.value = 0;
    self.flipHistorySlider.maximumValue = 0;
    self.flipHistory = nil;
    [self updateUI];
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
- (IBAction)browserHistory:(id)sender
{
    [self updateUI];
}

-(void) updateUI
{
    //setting for all the card buttons
    for(UIButton *cardButton in self.cardButtons)
    {
        SetCard * card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];

        NSAttributedString *cardAttributedString = [self contentToAttributedString:card];
        [cardButton setAttributedTitle: cardAttributedString forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isUnplayable;
        cardButton.selected = card.isSelected;
        cardButton.alpha = (card.isUnplayable)? 0.1 : 1.0;
        if(card.isSelected)
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

//Use this to get the value in the slider in int, that is rounded off.
-(int) historyIndex
{
    return (int)roundf(self.flipHistorySlider.value);
}

-(CardSetGame *)game
{
    if(!_game)_game = [[CardSetGame alloc] initWithCardCount:[self.cardButtons count]
                                                   usingDeck:[[SetCardDeck alloc] init]];
    return _game;
}

-(NSAttributedString*)contentToAttributedString:(SetCard*)card
{
    NSDictionary *colorDictionary = @{@"redColor":[UIColor redColor], @"greenColor": [UIColor greenColor], @"blueColor": [UIColor blueColor]};
    
    NSDictionary *attributes = @{NSStrokeColorAttributeName: colorDictionary[card.color], NSForegroundColorAttributeName: [colorDictionary[card.color] colorWithAlphaComponent:[card.shading floatValue]], NSStrokeWidthAttributeName: @-5};
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
    return attributedString;
}

-(NSMutableAttributedString*) replaceWordInString:(NSMutableAttributedString*) attributedString withWord: (NSAttributedString*) word
{
    NSRange range = [[attributedString string] rangeOfString: [word string]];
    [attributedString replaceCharactersInRange:range withAttributedString:word];
    return attributedString;
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
        
        NSArray *stringArray = [self.game.lastFlipResultDictionary[@"string"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for(NSString* word in stringArray)
        {
            for(int i = 0; i <= [wordsNeedToReplace count]; i++)
            {
                if(i == [wordsNeedToReplace count])
                    [historyAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[word stringByAppendingString:@" "]]];
                else if([wordsNeedToReplace[i] isEqualToString:word])
                {
                    [historyAttributedString appendAttributedString:replacingWords[i]];
                    [historyAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                    wordsNeedToReplace[i] = @"";
                    break;
                }
            }
        }
        
        
        [self.flipHistory addObject:historyAttributedString];
        self.flipHistorySlider.maximumValue = self.flipCount - 1;
    }
    
    //put the slider to reflect the most recent flip in the flip history
    self.flipHistorySlider.value = self.flipHistory.count - 1;
    
    [self updateUI];
}

@end
