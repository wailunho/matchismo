//
//  SetGameResult.m
//  Matchismo
//
//  Created by William Ho on 8/29/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetGameResult.h"

@implementation SetGameResult

#define SET_RESULTS_KEY @"Set_GameResult_All"

+(NSArray*) allSetGameResults
{
    return [self allGameResultsWithKey:SET_RESULTS_KEY];
}

-(void)synchronize
{
    [self synchronizeWithKey:SET_RESULTS_KEY];
}

@end
