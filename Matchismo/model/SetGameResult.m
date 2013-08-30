//
//  SetGameResult.m
//  Matchismo
//
//  Created by William Ho on 8/29/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetGameResult.h"
#import "MatchGameResult.h"

@implementation SetGameResult

#define SET_RESULTS_KEY @"Set_GameResult_All"

+(NSArray*) allSetGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    for(id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SET_RESULTS_KEY] allValues])
    {
        MatchGameResult *result = [[MatchGameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    return allGameResults;
}

-(void)synchronize
{
    NSMutableDictionary *mutableMatchGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SET_RESULTS_KEY] mutableCopy];
    if(!mutableMatchGameResultsFromUserDefaults)
        mutableMatchGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableMatchGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableMatchGameResultsFromUserDefaults forKey:SET_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
