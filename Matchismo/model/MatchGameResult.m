//
//  GameResult.m
//  Matchismo
//
//  Created by William Ho on 8/25/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "MatchGameResult.h"

@interface MatchGameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation MatchGameResult

#define MATCH_RESULTS_KEY @"Match_GameResult_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

+(NSArray*) allMatchGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    for(id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:MATCH_RESULTS_KEY] allValues])
    {
        MatchGameResult *result = [[MatchGameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    return allGameResults;
}

- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    if(self)
    {
        if([plist isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDictionary = (NSDictionary*)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
                      if(!_start || !_end) self = nil;
        }
    }
    return self;
}

-(void)synchronize
{
    NSMutableDictionary *mutableMatchGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:MATCH_RESULTS_KEY] mutableCopy];
    if(!mutableMatchGameResultsFromUserDefaults)
        mutableMatchGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableMatchGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableMatchGameResultsFromUserDefaults forKey:MATCH_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{ START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score) };
}

// designated initializer
- (id)init
{
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

-(void) setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

- (NSComparisonResult)compareScoreToGameResult:(MatchGameResult *)otherResult
{
    if (self.score > otherResult.score) {
        return NSOrderedAscending;
    } else if (self.score < otherResult.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@end