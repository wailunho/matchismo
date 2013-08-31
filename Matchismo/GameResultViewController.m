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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - Main functions

-(void)updateUI
{
    //Setting up the date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *displayText = @"";
    
    //display match game ranking
    int i = 1;
    for(MatchGameResult *result in [[MatchGameResult allMatchGameResults] sortedArrayUsingSelector:@selector(compareScoreToGameResult:)])
    {
        displayText = [displayText stringByAppendingFormat:@"%d     Score: %d (%@, %0g)\n", i, result.score, [formatter stringFromDate:result.end], round(result.duration)];
        i++;
    }
    self.display.text = displayText;
    
    //display set game ranking
    NSString *displaySetText = @"";
    i = 1;
    for(SetGameResult *result in [[SetGameResult allSetGameResults] sortedArrayUsingSelector:@selector(compareScoreToGameResult:)])
    {
        displaySetText = [displaySetText stringByAppendingFormat:@"%d     Score: %d (%@, %0g)\n", i, result.score, [formatter stringFromDate:result.end], round(result.duration)];
        i++;
    }
    self.displaySet.text = displaySetText;
}

@end
