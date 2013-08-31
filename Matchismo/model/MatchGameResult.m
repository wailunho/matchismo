//
//  GameResult.m
//  Matchismo
//
//  Created by William Ho on 8/25/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "MatchGameResult.h"

@implementation MatchGameResult

#define MATCH_RESULTS_KEY @"Match_GameResult_All"

+(NSArray*) allMatchGameResults
{
    return [self allGameResultsWithKey:MATCH_RESULTS_KEY];
}

-(void)synchronize
{
    [self synchronizeWithKey:MATCH_RESULTS_KEY];
}

@end