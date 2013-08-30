//
//  GameResultViewController.m
//  Matchismo
//
//  Created by William Ho on 8/25/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "GameResultViewController.h"
#import "MatchGameResult.h"
#import "SetGameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (weak, nonatomic) IBOutlet UITextView *displaySet;

@end

@implementation GameResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateUI
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *displayText = @"";
    int i = 1;
    for(MatchGameResult *result in [[MatchGameResult allMatchGameResults] sortedArrayUsingSelector:@selector(compareScoreToGameResult:)])
    {
        displayText = [displayText stringByAppendingFormat:@"%d     Score: %d (%@, %0g)\n", i, result.score, [formatter stringFromDate:result.end], round(result.duration)];
        i++;
    }
    self.display.text = displayText;
    
    NSString *displaySetText = @"";
    i = 1;
    for(SetGameResult *result in [[SetGameResult allSetGameResults] sortedArrayUsingSelector:@selector(compareScoreToGameResult:)])
    {
        displaySetText = [displaySetText stringByAppendingFormat:@"%d     Score: %d (%@, %0g)\n", i, result.score, [formatter stringFromDate:result.end], round(result.duration)];
        i++;
    }
    self.displaySet.text = displaySetText;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
