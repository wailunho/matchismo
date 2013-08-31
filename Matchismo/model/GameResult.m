//
//  GameResult.m
//  Matchismo
//
//  Created by William Ho on 8/31/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "GameResult.h"

@implementation GameResult

#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

+(NSArray*) allGameResultsWithKey:(NSString*)key
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    for(id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:key] allValues])
    {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
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

-(void)synchronizeWithKey:(NSString*)key
{
    NSMutableDictionary *mutableMatchGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:key] mutableCopy];
    if(!mutableMatchGameResultsFromUserDefaults)
        mutableMatchGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableMatchGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableMatchGameResultsFromUserDefaults forKey:key];
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

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
}

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult
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