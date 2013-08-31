//
//  SettingViewController.m
//  Matchismo
//
//  Created by William Ho on 8/29/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

#define SET_RESULTS_KEY @"Set_GameResult_All"
#define MATCH_RESULTS_KEY @"Match_GameResult_All"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)resetRanking:(id)sender
{
    //reset both ranking
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SET_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MATCH_RESULTS_KEY];
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
